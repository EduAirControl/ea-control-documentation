-- EduAirControl - Script de referencia consolidado
-- Fuente: scripts SQL canonicos y migraciones Liquibase en proyecto.zip.
-- IMPORTANTE: no sustituye los changelogs Liquibase por microservicio.
-- Probar en una base vacia antes de cualquier uso.

CREATE SCHEMA IF NOT EXISTS "classrooms";
CREATE SCHEMA IF NOT EXISTS "environment_monitoring";
CREATE SCHEMA IF NOT EXISTS "seguridad";
CREATE SCHEMA IF NOT EXISTS "sensors";
CREATE SCHEMA IF NOT EXISTS "user_experience";
CREATE SCHEMA IF NOT EXISTS "user_management";

-- Fuente original: proyecto/microservicios/-ms-user-experience/src/main/resources/db/changelog/canonical/01_schemas/001_schemas.sql
-- Esquema propio del microservicio (ADR-003: cada servicio tiene su namespace).
CREATE SCHEMA IF NOT EXISTS user_experience;

CREATE EXTENSION IF NOT EXISTS pgcrypto;

-- Fuente original: proyecto/microservicios/-ms-user-experience/src/main/resources/db/changelog/canonical/03_tables/01_preferences/001_user_preferences.sql
-- Preferencias de interfaz y notificaciones por usuario.
-- user_id: referencia logica al servicio IAM. Un registro por usuario.
CREATE TABLE user_experience.user_preferences (
    preference_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL UNIQUE,
    language VARCHAR(10),
    color_theme VARCHAR(20),
    notifications_enabled BOOLEAN NOT NULL DEFAULT TRUE,
    time_zone VARCHAR(100),
    date_format VARCHAR(20),
    reminders JSONB NOT NULL DEFAULT '{}'::jsonb,
    dark_mode BOOLEAN NOT NULL DEFAULT FALSE,
    auto_time_zone BOOLEAN NOT NULL DEFAULT TRUE
);

-- Fuente original: proyecto/microservicios/-ms-user-experience/src/main/resources/db/changelog/canonical/03_tables/02_favorites/001_favorites.sql
-- Favoritos del usuario: ambientes y/o variables.
-- user_id / classroom_id / variable_id: referencias logicas (IAM, classrooms, sensors).
-- Al menos un objetivo debe estar presente.
CREATE TABLE user_experience.favorites (
    favorite_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL,
    classroom_id UUID,
    variable_id UUID,
    added_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT chk_favorite_target
        CHECK (
            classroom_id IS NOT NULL
            OR variable_id IS NOT NULL
        )
);

-- Fuente original: proyecto/microservicios/-ms-user-experience/src/main/resources/db/changelog/canonical/03_tables/03_ratings/001_classroom_ratings.sql
-- Calificaciones de ambientes por usuario (escala 1-5).
-- user_id / classroom_id: referencias logicas (IAM, classrooms).
CREATE TABLE user_experience.classroom_ratings (
    rating_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL,
    classroom_id UUID NOT NULL,
    score INTEGER NOT NULL,
    comment VARCHAR(1000),
    rated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT chk_classroom_rating_score
        CHECK (score BETWEEN 1 AND 5)
);

-- Fuente original: proyecto/microservicios/-ms-user-experience/src/main/resources/db/changelog/canonical/03_tables/04_searches/001_searches.sql
-- Historial de busquedas del usuario con filtros aplicados.
-- user_id: referencia logica al servicio IAM.
CREATE TABLE user_experience.searches (
    search_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL,
    search_text VARCHAR(500),
    applied_filter VARCHAR(500),
    searched_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Fuente original: proyecto/microservicios/-ms-user-experience/src/main/resources/db/changelog/canonical/03_tables/05_notifications/001_notification_state.sql
-- Estado de lectura de notificaciones por usuario y alerta.
-- Permite marcar alertas como leidas sin duplicar. La alerta en si vive en
-- ms-environment-monitoring; aqui solo se guarda la interaccion del usuario.
CREATE TABLE user_experience.notification_state (
    user_id UUID NOT NULL,
    alert_id UUID NOT NULL,
    read_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    PRIMARY KEY (user_id, alert_id)
);

-- Fuente original: proyecto/microservicios/-ms-user-experience/src/main/resources/db/changelog/canonical/10_indexes/001_indexes.sql
-- Indices para las consultas mas frecuentes del servicio.
CREATE INDEX ix_user_preferences_user_id
    ON user_experience.user_preferences (user_id);

CREATE INDEX ix_favorites_user_id
    ON user_experience.favorites (user_id);

CREATE INDEX ix_favorites_classroom_id
    ON user_experience.favorites (classroom_id);

CREATE INDEX ix_favorites_variable_id
    ON user_experience.favorites (variable_id);

CREATE INDEX ix_classroom_ratings_user_id
    ON user_experience.classroom_ratings (user_id);

CREATE INDEX ix_classroom_ratings_classroom_id
    ON user_experience.classroom_ratings (classroom_id);

CREATE INDEX ix_searches_user_id
    ON user_experience.searches (user_id);

CREATE INDEX ix_searches_searched_at
    ON user_experience.searches (searched_at DESC);

-- Fuente original: proyecto/microservicios/ms-environment-monitoring/src/main/resources/db/changelog/canonical/01_schemas/001_schemas.sql
-- Esquema propio del microservicio (ADR-003: cada servicio tiene su namespace).
CREATE SCHEMA IF NOT EXISTS environment_monitoring;

-- gen_random_uuid() viene de pgcrypto; el core de Postgres 15 ya lo expone, pero se
-- asegura la extension para no depender de la version de la imagen.
CREATE EXTENSION IF NOT EXISTS pgcrypto;

-- Fuente original: proyecto/microservicios/ms-environment-monitoring/src/main/resources/db/changelog/canonical/03_tables/01_catalogos/001_variable.sql
-- Replica local del catalogo de variables del dominio sensors.
-- Los UUID coinciden con los del monolito para que el backfill y los eventos
-- puedan referenciar la variable sin traduccion.
-- measurement_unit_id: referencia logica; la unidad se copia desnormalizada
-- porque el servicio solo la lee para etiquetar resultados.
CREATE TABLE environment_monitoring.variable (
    variable_id          UUID PRIMARY KEY,
    code                 VARCHAR(30) NOT NULL UNIQUE,
    name                 VARCHAR(80) NOT NULL,
    measurement_unit_id  UUID NOT NULL,
    unit_symbol          VARCHAR(10) NOT NULL,
    created_at           TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- Fuente original: proyecto/microservicios/ms-environment-monitoring/src/main/resources/db/changelog/canonical/03_tables/01_catalogos/002_educational_environment.sql
-- Replica minima de ambientes educativos (dominio classrooms).
-- El servicio no administra ambientes: solo necesita environment_type_id para
-- resolver la precedencia de umbrales y el nombre para etiquetar analisis.
CREATE TABLE environment_monitoring.educational_environment (
    educational_environment_id UUID PRIMARY KEY,
    code                       VARCHAR(30) NOT NULL,
    name                       VARCHAR(120) NOT NULL,
    campus_id                  UUID,
    environment_type_id        UUID NOT NULL,
    floor                      INTEGER
);

-- Fuente original: proyecto/microservicios/ms-environment-monitoring/src/main/resources/db/changelog/canonical/03_tables/01_catalogos/003_variable_threshold.sql
-- Umbrales de advertencia por variable y tipo de ambiente (ADR-014).
--
-- ADR-014 aceptado: el umbral es por (variable_id, environment_type_id,
-- severity_id). NO existe educational_environment_id: la especificacion lo
-- rechaza explicitamente. La precedencia ambiente > tipo del monolito queda
-- eliminada.
--
-- Los umbrales nunca se borran; se cierran con valid_to. Sin solape para la misma
-- combinacion en un mismo rango de fechas.
CREATE TABLE environment_monitoring.variable_threshold (
    variable_threshold_id UUID PRIMARY KEY,
    variable_id           UUID NOT NULL,
    environment_type_id   UUID NOT NULL,
    min_value             NUMERIC(12,4),
    max_value             NUMERIC(12,4),
    severity_id           UUID NOT NULL,
    valid_from            DATE NOT NULL,
    valid_to              DATE,
    CONSTRAINT ck_variable_threshold_values
        CHECK (min_value IS NULL OR max_value IS NULL OR min_value < max_value),
    CONSTRAINT ck_variable_threshold_validity
        CHECK (valid_to IS NULL OR valid_from < valid_to)
);

-- Fuente original: proyecto/microservicios/ms-environment-monitoring/src/main/resources/db/changelog/canonical/03_tables/01_catalogos/004_severity.sql
-- Catalogo de severidades de alerta (ADR-014).
-- Sembrado con INFO, WARNING y CRITICAL. Los umbrales referencian esta tabla por
-- FK; nunca se borran severidades, solo se dejan de usar.
CREATE TABLE environment_monitoring.severity (
    severity_id UUID PRIMARY KEY,
    code        VARCHAR(20) NOT NULL UNIQUE,
    name        VARCHAR(40) NOT NULL,
    level       SMALLINT NOT NULL UNIQUE
);

-- Fuente original: proyecto/microservicios/ms-environment-monitoring/src/main/resources/db/changelog/canonical/03_tables/01_catalogos/005_quality_flag.sql
-- Catalogo de calidad de medicion (DEC-006).
-- Catálogo local propio: VALID, SUSPECT, BAD. No se referencia al monolito.
CREATE TABLE environment_monitoring.quality_flag (
    quality_flag_id UUID PRIMARY KEY,
    code            VARCHAR(20) NOT NULL UNIQUE,
    name            VARCHAR(60) NOT NULL
);

-- Fuente original: proyecto/microservicios/ms-environment-monitoring/src/main/resources/db/changelog/canonical/03_tables/02_read_model/001_environment_measurement.sql
-- Mediciones ambientales atomicas (modelo canonico §4.1).
--
-- Una fila = una instalacion + una variable + un instante. Prohibida la fila ancha.
-- El ambiente se resuelve por la proyeccion local (installation_projection), no se
-- duplica aqui: el umbral se evalua por tipo de ambiente en tiempo de consulta.
--
-- measured_at es el instante real de la medicion y nunca se reemplaza; created_at
-- es cuando el servicio la persistio. Son conceptos distintos.
CREATE TABLE environment_monitoring.environment_measurement (
    environment_measurement_id UUID PRIMARY KEY,
    sensor_installation_id     UUID NOT NULL,
    variable_id                UUID NOT NULL,
    measured_value             NUMERIC(12,4) NOT NULL,
    measured_at                TIMESTAMPTZ NOT NULL,
    quality_flag_id            UUID NOT NULL,
    created_at                 TIMESTAMPTZ NOT NULL DEFAULT now(),
    CONSTRAINT uq_environment_measurement_inst_var_time
        UNIQUE (sensor_installation_id, variable_id, measured_at)
);

-- Fuente original: proyecto/microservicios/ms-environment-monitoring/src/main/resources/db/changelog/canonical/03_tables/02_read_model/002_inbox_message.sql
-- Registro de mensajes ya procesados, para idempotencia del consumidor.
-- Se apoya en message_id (el id del evento en el origen) y no en la clave
-- natural del mensaje, de modo que un redelivery del mismo evento se descarta
-- aunque el contenido haya cambiado.
CREATE TABLE environment_monitoring.inbox_message (
    message_id   UUID PRIMARY KEY,
    consumer     VARCHAR(60) NOT NULL,
    message_type VARCHAR(80) NOT NULL,
    received_at  TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- Fuente original: proyecto/microservicios/ms-environment-monitoring/src/main/resources/db/changelog/canonical/03_tables/03_analisis/001_analysis_statuses.sql
-- Catalogo del ciclo de vida de un analisis. Los UUID coinciden con los del
-- monolito para que la migracion de analisis existentes no requiera traduccion.
CREATE TABLE environment_monitoring.analysis_statuses (
    analysis_status_id UUID PRIMARY KEY,
    code               VARCHAR(20) NOT NULL UNIQUE,
    name               VARCHAR(60) NOT NULL
);

-- Fuente original: proyecto/microservicios/ms-environment-monitoring/src/main/resources/db/changelog/canonical/03_tables/03_analisis/002_environmental_analysis.sql
-- Dominio: analisis historico por periodo (core de ms-environment-monitoring).
-- educational_environment_id y variable_id: referencias logicas a las replicas
-- locales del servicio; requested_by: referencia logica al dominio identity.
CREATE TABLE environment_monitoring.environmental_analysis (
    environmental_analysis_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    educational_environment_id UUID NOT NULL,
    period_start TIMESTAMPTZ NOT NULL,
    period_end   TIMESTAMPTZ NOT NULL,
    analysis_status_id UUID NOT NULL,
    requested_by UUID,
    computed_at  TIMESTAMPTZ,
    CONSTRAINT ck_environmental_analysis_period CHECK (period_start < period_end)
);

-- Fuente original: proyecto/microservicios/ms-environment-monitoring/src/main/resources/db/changelog/canonical/03_tables/03_analisis/003_analysis_result.sql
-- Resultado agregado por analisis y variable.
CREATE TABLE environment_monitoring.analysis_result (
    analysis_result_id  UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    environmental_analysis_id UUID NOT NULL,
    variable_id      UUID NOT NULL,
    min_value        NUMERIC(12,4) NOT NULL,
    max_value        NUMERIC(12,4) NOT NULL,
    avg_value        NUMERIC(12,4) NOT NULL,
    sample_count     INTEGER NOT NULL,
    exceedance_count INTEGER NOT NULL,
    CONSTRAINT uq_analysis_result_period_variable
        UNIQUE (environmental_analysis_id, variable_id)
);

-- Fuente original: proyecto/microservicios/ms-environment-monitoring/src/main/resources/db/changelog/canonical/03_tables/04_alertas/001_environment_alert.sql
-- Alertas ambientales trazables (DEC-006, modelo canonico).
--
-- Cada alerta referencia el ambiente, la variable, el umbral activo que se excedio
-- y la medicion que disparo la condicion. No es una copia de la medicion: es un
-- hecho trazable basado en ella.
--
-- Estado por columnas (acknowledged_at/by), no por catalogo: es el modelo canonico
-- de 06-data/domain/ms-environment-monitoring.md. NULL en acknowledged_at significa
-- alerta activa.
CREATE TABLE environment_monitoring.environment_alert (
    environment_alert_id      UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    educational_environment_id UUID NOT NULL,
    variable_id               UUID NOT NULL,
    variable_threshold_id     UUID NOT NULL,
    triggering_measurement_id UUID NOT NULL,
    raised_at                 TIMESTAMPTZ NOT NULL DEFAULT now(),
    acknowledged_at           TIMESTAMPTZ,
    acknowledged_by           UUID,
    CONSTRAINT ck_environment_alert_acknowledge
        CHECK ((acknowledged_at IS NULL AND acknowledged_by IS NULL)
               OR (acknowledged_at IS NOT NULL))
);

-- Fuente original: proyecto/microservicios/ms-environment-monitoring/src/main/resources/db/changelog/canonical/03_tables/05_proyeccion/001_installation_projection.sql
-- Proyeccion local de instalaciones (DEC-006 §4.3).
--
-- El servicio no posee sensor_installation, educational_environment ni
-- environment_type. Para evaluar umbrales necesita resolver
-- sensor_installation_id -> educational_environment_id -> environment_type_id
-- sin llamar a otros servicios en cada medicion.
--
-- Se alimenta por eventos (SensorInstalled/SensorRemoved) y se refresca
-- periodicamente. Es un cache, no la fuente de verdad: si falta una fila, la
-- medicion se procesa sin evaluacion de umbral y se registra el hueco.
CREATE TABLE environment_monitoring.installation_projection (
    sensor_installation_id     UUID PRIMARY KEY,
    educational_environment_id UUID NOT NULL,
    environment_type_id        UUID NOT NULL,
    sensor_id                  UUID NOT NULL,
    removed_at                 TIMESTAMPTZ,
    synced_at                  TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- Fuente original: proyecto/microservicios/ms-environment-monitoring/src/main/resources/db/changelog/canonical/10_indexes/001_indexes.sql
-- Indices segun especificacion §4.2.
--
-- environment_measurement es la tabla de alto volumen: el indice compuesto
-- (sensor_installation_id, variable_id, measured_at) cubre la consulta principal
-- de agregacion y los unicos por variable o por tiempo ayudan al dashboard.
CREATE INDEX ix_environment_measurement_inst_var_time
    ON environment_monitoring.environment_measurement
    (sensor_installation_id, variable_id, measured_at);

CREATE INDEX ix_environment_measurement_variable
    ON environment_monitoring.environment_measurement (variable_id);

CREATE INDEX ix_environment_measurement_time
    ON environment_monitoring.environment_measurement (measured_at);

-- Umbrales vigentes por (variable, tipo, severidad). Sin solape por periodo.
CREATE INDEX ix_variable_threshold_var_type_sev
    ON environment_monitoring.variable_threshold
    (variable_id, environment_type_id, severity_id, valid_to);

CREATE INDEX ix_variable_threshold_type
    ON environment_monitoring.variable_threshold (environment_type_id);

-- Analisis: listado por ambiente y busqueda por ventana.
CREATE INDEX ix_environmental_analysis_environment
    ON environment_monitoring.environmental_analysis (educational_environment_id);

CREATE INDEX ix_environmental_analysis_period_start
    ON environment_monitoring.environmental_analysis (period_start);

CREATE INDEX ix_environmental_analysis_period_end
    ON environment_monitoring.environmental_analysis (period_end);

CREATE INDEX ix_environmental_analysis_status
    ON environment_monitoring.environmental_analysis (analysis_status_id);

-- Resultados: siempre junto a su analisis y por variable.
CREATE INDEX ix_analysis_result_analysis
    ON environment_monitoring.analysis_result (environmental_analysis_id);

CREATE INDEX ix_analysis_result_variable
    ON environment_monitoring.analysis_result (variable_id);

-- Alertas: listado por ambiente y por fecha de generacion.
CREATE INDEX ix_environment_alert_environment
    ON environment_monitoring.environment_alert (educational_environment_id);

CREATE INDEX ix_environment_alert_raised
    ON environment_monitoring.environment_alert (raised_at DESC);

-- Proyeccion: resolucion instalacion -> ambiente.
CREATE INDEX ix_installation_projection_environment
    ON environment_monitoring.installation_projection (educational_environment_id);

-- Referencia DDL derivada de proyecto/microservicios/ea-control-ms-classroom-management/src/main/resources/db/changelog/changes/001-create-campuses.yaml
CREATE TABLE IF NOT EXISTS classrooms.campuses (
  "campus_id" UUID DEFAULT gen_random_uuid() NOT NULL,
  "code" VARCHAR(30) NOT NULL UNIQUE,
  "name" VARCHAR(150) NOT NULL,
  "city" VARCHAR(100),
  "status" VARCHAR(30) DEFAULT 'ACTIVE' NOT NULL,
  "created_at" TIMESTAMPTZ DEFAULT now() NOT NULL,
  "updated_at" TIMESTAMPTZ DEFAULT now() NOT NULL,
  "deleted_at" TIMESTAMPTZ,
  PRIMARY KEY ("campus_id")
);

-- Referencia DDL derivada de proyecto/microservicios/ea-control-ms-classroom-management/src/main/resources/db/changelog/changes/003-create-educational-environments.yaml
CREATE TABLE IF NOT EXISTS classrooms.educational_environment (
  "educational_environment_id" UUID DEFAULT gen_random_uuid() NOT NULL,
  "campus_id" UUID NOT NULL,
  "code" VARCHAR(30) NOT NULL,
  "name" VARCHAR(120) NOT NULL,
  "environment_type_id" UUID NOT NULL,
  "floor" INTEGER,
  "area_m2" NUMERIC(8,2),
  "occupancy_capacity" INTEGER,
  "status" VARCHAR(30) DEFAULT 'ACTIVE' NOT NULL,
  "created_at" TIMESTAMPTZ DEFAULT now() NOT NULL,
  "updated_at" TIMESTAMPTZ DEFAULT now() NOT NULL,
  "deleted_at" TIMESTAMPTZ,
  PRIMARY KEY ("educational_environment_id")
);

-- Referencia DDL derivada de proyecto/microservicios/ea-control-ms-classroom-management/src/main/resources/db/changelog/changes/002-create-environment-types.yaml
CREATE TABLE IF NOT EXISTS classrooms.environment_types (
  "environment_type_id" UUID DEFAULT gen_random_uuid() NOT NULL,
  "code" VARCHAR(30) NOT NULL UNIQUE,
  "name" VARCHAR(80) NOT NULL UNIQUE,
  "description" VARCHAR(255),
  "created_at" TIMESTAMPTZ DEFAULT now() NOT NULL,
  "updated_at" TIMESTAMPTZ DEFAULT now() NOT NULL,
  "deleted_at" TIMESTAMPTZ,
  PRIMARY KEY ("environment_type_id")
);

-- Referencia DDL derivada de proyecto/microservicios/ea-control-ms-classroom-management/src/main/resources/db/changelog/changes/008-create-outbox-event.yaml
CREATE TABLE IF NOT EXISTS classrooms.outbox_event (
  "event_id" UUID NOT NULL,
  "event_type" VARCHAR(80) NOT NULL,
  "aggregate_type" VARCHAR(60) NOT NULL,
  "aggregate_id" VARCHAR(60) NOT NULL,
  "routing_key" VARCHAR(80) NOT NULL,
  "payload" TEXT NOT NULL,
  "occurred_at" TIMESTAMPTZ NOT NULL,
  "published_at" TIMESTAMPTZ,
  "attempts" INTEGER DEFAULT 0 NOT NULL,
  "last_error" TEXT,
  PRIMARY KEY ("event_id")
);

-- Referencia DDL derivada de proyecto/microservicios/ea-control-ms-security/src/main/resources/db/changelog/changes/007-create-institution.yaml
CREATE TABLE IF NOT EXISTS seguridad.institution (
  "id" UUID DEFAULT gen_random_uuid() NOT NULL,
  "code" VARCHAR(20) NOT NULL,
  "name" VARCHAR(150) NOT NULL,
  "type" VARCHAR(50),
  "status" VARCHAR(20) NOT NULL,
  "created_at" TIMESTAMPTZ NOT NULL,
  "updated_at" TIMESTAMPTZ NOT NULL,
  PRIMARY KEY ("id")
);

-- Referencia DDL derivada de proyecto/microservicios/ea-control-ms-security/src/main/resources/db/changelog/changes/012-create-password-reset-tokens.yaml
CREATE TABLE IF NOT EXISTS seguridad.password_reset_tokens (
  "id" UUID DEFAULT gen_random_uuid() NOT NULL,
  "user_id" UUID NOT NULL,
  "code_hash" VARCHAR(255) NOT NULL,
  "expires_at" TIMESTAMPTZ NOT NULL,
  "used_at" TIMESTAMPTZ,
  "created_at" TIMESTAMPTZ NOT NULL,
  PRIMARY KEY ("id")
);

-- Referencia DDL derivada de proyecto/microservicios/ea-control-ms-security/src/main/resources/db/changelog/changes/004-create-refresh-tokens.yaml
CREATE TABLE IF NOT EXISTS seguridad.refresh_tokens (
  "id" UUID DEFAULT gen_random_uuid() NOT NULL,
  "user_id" UUID NOT NULL,
  "token_hash" VARCHAR(255) NOT NULL,
  "expires_at" TIMESTAMPTZ NOT NULL,
  "revoked_at" TIMESTAMPTZ,
  "created_at" TIMESTAMPTZ DEFAULT now() NOT NULL,
  "user_agent" TEXT,
  PRIMARY KEY ("id")
);

-- Referencia DDL derivada de proyecto/microservicios/ea-control-ms-security/src/main/resources/db/changelog/changes/002-create-roles.yaml
CREATE TABLE IF NOT EXISTS seguridad.roles (
  "id" UUID DEFAULT gen_random_uuid() NOT NULL,
  "name" VARCHAR(50) NOT NULL UNIQUE,
  "description" TEXT,
  "created_at" TIMESTAMPTZ DEFAULT now() NOT NULL,
  PRIMARY KEY ("id")
);

-- Referencia DDL derivada de proyecto/microservicios/ea-control-ms-security/src/main/resources/db/changelog/changes/013-create-user-identity.yaml
CREATE TABLE IF NOT EXISTS seguridad.user_identity (
  "id" UUID DEFAULT gen_random_uuid() NOT NULL,
  "user_id" UUID NOT NULL,
  "provider" VARCHAR(30) NOT NULL,
  "provider_user_id" VARCHAR(255) NOT NULL,
  "email" VARCHAR(255),
  "display_name" VARCHAR(255),
  "avatar_url" VARCHAR(500),
  "created_at" TIMESTAMPTZ DEFAULT now() NOT NULL,
  PRIMARY KEY ("id")
);

-- Referencia DDL derivada de proyecto/microservicios/ea-control-ms-security/src/main/resources/db/changelog/changes/003-create-user-roles.yaml
CREATE TABLE IF NOT EXISTS seguridad.user_roles (
  "user_id" UUID NOT NULL,
  "role_id" UUID NOT NULL,
  "assigned_at" TIMESTAMPTZ DEFAULT now() NOT NULL,
  "assigned_by" UUID
);

-- Referencia DDL derivada de proyecto/microservicios/ea-control-ms-security/src/main/resources/db/changelog/changes/001-create-users.yaml
CREATE TABLE IF NOT EXISTS seguridad.users (
  "id" UUID DEFAULT gen_random_uuid() NOT NULL,
  "email" VARCHAR(255) NOT NULL UNIQUE,
  "username" VARCHAR(100) NOT NULL UNIQUE,
  "password_hash" VARCHAR(255) NOT NULL,
  "email_verified" BOOLEAN DEFAULT FALSE NOT NULL,
  "failed_attempts" INTEGER DEFAULT 0 NOT NULL,
  "locked_until" TIMESTAMPTZ,
  "created_at" TIMESTAMPTZ DEFAULT now() NOT NULL,
  "updated_at" TIMESTAMPTZ DEFAULT now() NOT NULL,
  "deleted_at" TIMESTAMPTZ,
  PRIMARY KEY ("id")
);

-- Referencia DDL derivada de proyecto/microservicios/ea-control-ms-sensor-management/src/main/resources/db/changelog/changes/009-create-sensor-catalog.yaml
CREATE TABLE IF NOT EXISTS sensors.measurement_unit (
  "measurement_unit_id" UUID DEFAULT gen_random_uuid() NOT NULL,
  "code" VARCHAR(30) NOT NULL UNIQUE,
  "symbol" VARCHAR(10) NOT NULL,
  "name" VARCHAR(80) NOT NULL,
  "created_at" TIMESTAMPTZ DEFAULT now() NOT NULL,
  PRIMARY KEY ("measurement_unit_id")
);

-- Referencia DDL derivada de proyecto/microservicios/ea-control-ms-sensor-management/src/main/resources/db/changelog/changes/008-create-outbox-event.yaml
CREATE TABLE IF NOT EXISTS sensors.outbox_event (
  "event_id" UUID NOT NULL,
  "event_type" VARCHAR(80) NOT NULL,
  "aggregate_type" VARCHAR(60) NOT NULL,
  "aggregate_id" VARCHAR(60) NOT NULL,
  "routing_key" VARCHAR(80) NOT NULL,
  "payload" TEXT NOT NULL,
  "occurred_at" TIMESTAMPTZ NOT NULL,
  "published_at" TIMESTAMPTZ,
  "attempts" INTEGER DEFAULT 0 NOT NULL,
  "last_error" TEXT,
  PRIMARY KEY ("event_id")
);

-- Referencia DDL derivada de proyecto/microservicios/ea-control-ms-sensor-management/src/main/resources/db/changelog/changes/001-create-sensor.yaml
CREATE TABLE IF NOT EXISTS sensors.sensor (
  "sensor_id" UUID DEFAULT gen_random_uuid() NOT NULL,
  "serial_number" VARCHAR(60) NOT NULL UNIQUE,
  "sensor_model_id" UUID NOT NULL,
  "sensor_status_id" UUID NOT NULL,
  "last_seen_at" TIMESTAMPTZ,
  "created_at" TIMESTAMPTZ DEFAULT now() NOT NULL,
  "updated_at" TIMESTAMPTZ,
  PRIMARY KEY ("sensor_id")
);

-- Referencia DDL derivada de proyecto/microservicios/ea-control-ms-sensor-management/src/main/resources/db/changelog/changes/002-create-sensor-installation.yaml
CREATE TABLE IF NOT EXISTS sensors.sensor_installation (
  "sensor_installation_id" UUID DEFAULT gen_random_uuid() NOT NULL,
  "sensor_id" UUID NOT NULL,
  "educational_environment_id" UUID NOT NULL,
  "installed_at" TIMESTAMPTZ NOT NULL,
  "removed_at" TIMESTAMPTZ,
  PRIMARY KEY ("sensor_installation_id")
);

-- Referencia DDL derivada de proyecto/microservicios/ea-control-ms-sensor-management/src/main/resources/db/changelog/changes/009-create-sensor-catalog.yaml
CREATE TABLE IF NOT EXISTS sensors.sensor_model (
  "sensor_model_id" UUID DEFAULT gen_random_uuid() NOT NULL,
  "code" VARCHAR(30) NOT NULL UNIQUE,
  "name" VARCHAR(80) NOT NULL,
  "description" VARCHAR(255),
  "created_at" TIMESTAMPTZ DEFAULT now() NOT NULL,
  PRIMARY KEY ("sensor_model_id")
);

-- Referencia DDL derivada de proyecto/microservicios/ea-control-ms-sensor-management/src/main/resources/db/changelog/changes/009-create-sensor-catalog.yaml
CREATE TABLE IF NOT EXISTS sensors.sensor_status (
  "sensor_status_id" UUID DEFAULT gen_random_uuid() NOT NULL,
  "code" VARCHAR(30) NOT NULL UNIQUE,
  "name" VARCHAR(80) NOT NULL,
  "created_at" TIMESTAMPTZ DEFAULT now() NOT NULL,
  PRIMARY KEY ("sensor_status_id")
);

-- Referencia DDL derivada de proyecto/microservicios/ea-control-ms-sensor-management/src/main/resources/db/changelog/changes/004-create-sensor-variable.yaml
CREATE TABLE IF NOT EXISTS sensors.sensor_variable (
  "sensor_id" UUID NOT NULL,
  "variable_id" UUID NOT NULL
);

-- Referencia DDL derivada de proyecto/microservicios/ea-control-ms-sensor-management/src/main/resources/db/changelog/changes/003-create-variable.yaml
CREATE TABLE IF NOT EXISTS sensors.variable (
  "variable_id" UUID DEFAULT gen_random_uuid() NOT NULL,
  "code" VARCHAR(30) NOT NULL UNIQUE,
  "name" VARCHAR(80) NOT NULL,
  "measurement_unit_id" UUID NOT NULL,
  "description" VARCHAR(255),
  "created_at" TIMESTAMPTZ DEFAULT now() NOT NULL,
  PRIMARY KEY ("variable_id")
);

-- Referencia DDL derivada de proyecto/microservicios/ea-control-ms-user-management/src/main/resources/db/changelog/changes/001-create-user-profiles.yaml
CREATE TABLE IF NOT EXISTS user_management.user_profiles (
  "profile_id" UUID DEFAULT gen_random_uuid() NOT NULL,
  "user_id" UUID NOT NULL,
  "full_name" VARCHAR(150) NOT NULL,
  "phone" VARCHAR(30),
  "department" VARCHAR(100),
  "position" VARCHAR(100),
  "locale" VARCHAR(10),
  "status" VARCHAR(20) NOT NULL,
  "created_at" TIMESTAMPTZ NOT NULL,
  "updated_at" TIMESTAMPTZ NOT NULL,
  "deleted_at" TIMESTAMPTZ,
  PRIMARY KEY ("profile_id")
);

-- Fin. Ejecutar y validar con DBA/desarrollador antes de produccion.
