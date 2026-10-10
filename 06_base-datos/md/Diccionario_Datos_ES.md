# 06. Base de Datos — EduAirControl

**Proyecto:** EduAirControl  
**Programa:** Tecnólogo en Análisis y Desarrollo de Software (ADSO)  
**Ficha:** ADSO-3145556  
**Institución:** SENA — Industria  
**Ubicación:** Neiva, Huila, Colombia  
**Versión:** 1.0  
**Fuente:** migraciones Liquibase y scripts SQL encontrados en `proyecto.zip`.

## Alcance y advertencias

El modelo se documenta a partir de las estructuras presentes en los archivos de migración del proyecto. Los nombres técnicos de tablas y columnas se conservan en inglés para coincidir con el código. El diseño separa datos por dominios y microservicios. Algunas referencias entre dominios son lógicas y no necesariamente claves foráneas físicas.

Las migraciones Liquibase originales por microservicio son la fuente de verdad para desplegar el esquema, incluyendo el orden de ejecución, datos iniciales, índices y restricciones. El script consolidado incluido aquí es una referencia documental y debe probarse antes de usarlo en un entorno real.
## Diccionario de datos

Las descripciones inferidas por el nombre técnico se marcan como pendientes de validación con la regla de negocio.

| Tabla | Campo | Tipo | Restricciones | Descripción |
|---|---|---|---|---|
| `classrooms.campuses` | `campus_id` | `UUID` | PK, NOT NULL, DEFAULT gen_random_uuid() | Referencia al campus. |
| `classrooms.campuses` | `code` | `VARCHAR(30)` | NOT NULL, UNIQUE | Campo de campuses; validar el significado con la regla de negocio. |
| `classrooms.campuses` | `name` | `VARCHAR(150)` | NOT NULL | Nombre del elemento. |
| `classrooms.campuses` | `city` | `VARCHAR(100)` | — | Campo de campuses; validar el significado con la regla de negocio. |
| `classrooms.campuses` | `status` | `VARCHAR(30)` | NOT NULL, DEFAULT ACTIVE | Estado del elemento. |
| `classrooms.campuses` | `created_at` | `TIMESTAMPTZ` | NOT NULL, DEFAULT now() | Fecha y hora de creación. |
| `classrooms.campuses` | `updated_at` | `TIMESTAMPTZ` | NOT NULL, DEFAULT now() | Fecha y hora de actualización. |
| `classrooms.campuses` | `deleted_at` | `TIMESTAMPTZ` | — | Campo de campuses; validar el significado con la regla de negocio. |
| `classrooms.educational_environment` | `educational_environment_id` | `UUID` | PK, NOT NULL, DEFAULT gen_random_uuid() | Campo de educational_environment; validar el significado con la regla de negocio. |
| `classrooms.educational_environment` | `campus_id` | `UUID` | NOT NULL | Referencia al campus. |
| `classrooms.educational_environment` | `code` | `VARCHAR(30)` | NOT NULL | Campo de educational_environment; validar el significado con la regla de negocio. |
| `classrooms.educational_environment` | `name` | `VARCHAR(120)` | NOT NULL | Nombre del elemento. |
| `classrooms.educational_environment` | `environment_type_id` | `UUID` | NOT NULL | Referencia al tipo de ambiente. |
| `classrooms.educational_environment` | `floor` | `INTEGER` | — | Campo de educational_environment; validar el significado con la regla de negocio. |
| `classrooms.educational_environment` | `area_m2` | `NUMERIC(8,2)` | — | Campo de educational_environment; validar el significado con la regla de negocio. |
| `classrooms.educational_environment` | `occupancy_capacity` | `INTEGER` | — | Campo de educational_environment; validar el significado con la regla de negocio. |
| `classrooms.educational_environment` | `status` | `VARCHAR(30)` | NOT NULL, DEFAULT ACTIVE | Estado del elemento. |
| `classrooms.educational_environment` | `created_at` | `TIMESTAMPTZ` | NOT NULL, DEFAULT now() | Fecha y hora de creación. |
| `classrooms.educational_environment` | `updated_at` | `TIMESTAMPTZ` | NOT NULL, DEFAULT now() | Fecha y hora de actualización. |
| `classrooms.educational_environment` | `deleted_at` | `TIMESTAMPTZ` | — | Campo de educational_environment; validar el significado con la regla de negocio. |
| `classrooms.environment_types` | `environment_type_id` | `UUID` | PK, NOT NULL, DEFAULT gen_random_uuid() | Referencia al tipo de ambiente. |
| `classrooms.environment_types` | `code` | `VARCHAR(30)` | NOT NULL, UNIQUE | Campo de environment_types; validar el significado con la regla de negocio. |
| `classrooms.environment_types` | `name` | `VARCHAR(80)` | NOT NULL, UNIQUE | Nombre del elemento. |
| `classrooms.environment_types` | `description` | `VARCHAR(255)` | — | Descripción del elemento. |
| `classrooms.environment_types` | `created_at` | `TIMESTAMPTZ` | NOT NULL, DEFAULT now() | Fecha y hora de creación. |
| `classrooms.environment_types` | `updated_at` | `TIMESTAMPTZ` | NOT NULL, DEFAULT now() | Fecha y hora de actualización. |
| `classrooms.environment_types` | `deleted_at` | `TIMESTAMPTZ` | — | Campo de environment_types; validar el significado con la regla de negocio. |
| `classrooms.outbox_event` | `event_id` | `UUID` | PK, NOT NULL | Campo de outbox_event; validar el significado con la regla de negocio. |
| `classrooms.outbox_event` | `event_type` | `VARCHAR(80)` | NOT NULL | Tipo de evento. |
| `classrooms.outbox_event` | `aggregate_type` | `VARCHAR(60)` | NOT NULL | Campo de outbox_event; validar el significado con la regla de negocio. |
| `classrooms.outbox_event` | `aggregate_id` | `VARCHAR(60)` | NOT NULL | Campo de outbox_event; validar el significado con la regla de negocio. |
| `classrooms.outbox_event` | `routing_key` | `VARCHAR(80)` | NOT NULL | Campo de outbox_event; validar el significado con la regla de negocio. |
| `classrooms.outbox_event` | `payload` | `TEXT` | NOT NULL | Contenido del evento o mensaje. |
| `classrooms.outbox_event` | `occurred_at` | `TIMESTAMPTZ` | NOT NULL | Fecha y hora del evento. |
| `classrooms.outbox_event` | `published_at` | `TIMESTAMPTZ` | — | Fecha y hora de publicación. |
| `classrooms.outbox_event` | `attempts` | `INTEGER` | NOT NULL, DEFAULT 0 | Campo de outbox_event; validar el significado con la regla de negocio. |
| `classrooms.outbox_event` | `last_error` | `TEXT` | — | Campo de outbox_event; validar el significado con la regla de negocio. |
| `environment_monitoring.analysis_result` | `analysis_result_id` | `UUID PRIMARY` | — | Campo de analysis_result; validar el significado con la regla de negocio. |
| `environment_monitoring.analysis_result` | `environmental_analysis_id` | `UUID NOT` | — | Referencia al análisis ambiental. |
| `environment_monitoring.analysis_result` | `variable_id` | `UUID NOT` | — | Referencia a la variable ambiental. |
| `environment_monitoring.analysis_result` | `min_value` | `NUMERIC(12,4) NOT` | — | Valor mínimo configurado o calculado. |
| `environment_monitoring.analysis_result` | `max_value` | `NUMERIC(12,4) NOT` | — | Valor máximo configurado o calculado. |
| `environment_monitoring.analysis_result` | `avg_value` | `NUMERIC(12,4) NOT` | — | Valor promedio calculado. |
| `environment_monitoring.analysis_result` | `sample_count` | `INTEGER NOT` | — | Número de muestras incluidas. |
| `environment_monitoring.analysis_result` | `exceedance_count` | `INTEGER NOT` | — | Número de mediciones fuera del umbral. |
| `environment_monitoring.analysis_statuses` | `analysis_status_id` | `UUID PRIMARY` | — | Referencia al estado del análisis. |
| `environment_monitoring.analysis_statuses` | `code` | `VARCHAR(20) NOT` | UNIQUE | Campo de analysis_statuses; validar el significado con la regla de negocio. |
| `environment_monitoring.analysis_statuses` | `name` | `VARCHAR(60) NOT` | — | Nombre del elemento. |
| `environment_monitoring.educational_environment` | `educational_environment_id` | `UUID PRIMARY` | — | Campo de educational_environment; validar el significado con la regla de negocio. |
| `environment_monitoring.educational_environment` | `code` | `VARCHAR(30) NOT` | — | Campo de educational_environment; validar el significado con la regla de negocio. |
| `environment_monitoring.educational_environment` | `name` | `VARCHAR(120) NOT` | — | Nombre del elemento. |
| `environment_monitoring.educational_environment` | `campus_id` | `UUID` | — | Referencia al campus. |
| `environment_monitoring.educational_environment` | `environment_type_id` | `UUID NOT` | — | Referencia al tipo de ambiente. |
| `environment_monitoring.educational_environment` | `floor` | `INTEGER` | — | Campo de educational_environment; validar el significado con la regla de negocio. |
| `environment_monitoring.environment_alert` | `environment_alert_id` | `UUID PRIMARY` | — | Campo de environment_alert; validar el significado con la regla de negocio. |
| `environment_monitoring.environment_alert` | `educational_environment_id` | `UUID NOT` | — | Campo de environment_alert; validar el significado con la regla de negocio. |
| `environment_monitoring.environment_alert` | `variable_id` | `UUID NOT` | — | Referencia a la variable ambiental. |
| `environment_monitoring.environment_alert` | `variable_threshold_id` | `UUID NOT` | — | Campo de environment_alert; validar el significado con la regla de negocio. |
| `environment_monitoring.environment_alert` | `triggering_measurement_id` | `UUID NOT` | — | Campo de environment_alert; validar el significado con la regla de negocio. |
| `environment_monitoring.environment_alert` | `raised_at` | `TIMESTAMPTZ NOT` | — | Campo de environment_alert; validar el significado con la regla de negocio. |
| `environment_monitoring.environment_alert` | `acknowledged_at` | `TIMESTAMPTZ` | — | Campo de environment_alert; validar el significado con la regla de negocio. |
| `environment_monitoring.environment_alert` | `acknowledged_by` | `UUID` | — | Campo de environment_alert; validar el significado con la regla de negocio. |
| `environment_monitoring.environment_measurement` | `environment_measurement_id` | `UUID PRIMARY` | — | Campo de environment_measurement; validar el significado con la regla de negocio. |
| `environment_monitoring.environment_measurement` | `sensor_installation_id` | `UUID NOT` | — | Campo de environment_measurement; validar el significado con la regla de negocio. |
| `environment_monitoring.environment_measurement` | `variable_id` | `UUID NOT` | — | Referencia a la variable ambiental. |
| `environment_monitoring.environment_measurement` | `measured_value` | `NUMERIC(12,4) NOT` | — | Valor numérico medido. |
| `environment_monitoring.environment_measurement` | `measured_at` | `TIMESTAMPTZ NOT` | — | Fecha y hora de la medición. |
| `environment_monitoring.environment_measurement` | `quality_flag_id` | `UUID NOT` | — | Referencia a la clasificación de calidad. |
| `environment_monitoring.environment_measurement` | `created_at` | `TIMESTAMPTZ NOT` | — | Fecha y hora de creación. |
| `environment_monitoring.environmental_analysis` | `environmental_analysis_id` | `UUID PRIMARY` | — | Referencia al análisis ambiental. |
| `environment_monitoring.environmental_analysis` | `educational_environment_id` | `UUID NOT` | — | Campo de environmental_analysis; validar el significado con la regla de negocio. |
| `environment_monitoring.environmental_analysis` | `period_start` | `TIMESTAMPTZ NOT` | — | Inicio del periodo analizado. |
| `environment_monitoring.environmental_analysis` | `period_end` | `TIMESTAMPTZ NOT` | — | Fin del periodo analizado. |
| `environment_monitoring.environmental_analysis` | `analysis_status_id` | `UUID NOT` | — | Referencia al estado del análisis. |
| `environment_monitoring.environmental_analysis` | `requested_by` | `UUID` | — | Campo de environmental_analysis; validar el significado con la regla de negocio. |
| `environment_monitoring.environmental_analysis` | `computed_at` | `TIMESTAMPTZ` | — | Campo de environmental_analysis; validar el significado con la regla de negocio. |
| `environment_monitoring.inbox_message` | `message_id` | `UUID PRIMARY` | — | Campo de inbox_message; validar el significado con la regla de negocio. |
| `environment_monitoring.inbox_message` | `consumer` | `VARCHAR(60) NOT` | — | Campo de inbox_message; validar el significado con la regla de negocio. |
| `environment_monitoring.inbox_message` | `message_type` | `VARCHAR(80) NOT` | — | Campo de inbox_message; validar el significado con la regla de negocio. |
| `environment_monitoring.inbox_message` | `received_at` | `TIMESTAMPTZ NOT` | — | Campo de inbox_message; validar el significado con la regla de negocio. |
| `environment_monitoring.installation_projection` | `sensor_installation_id` | `UUID PRIMARY` | — | Campo de installation_projection; validar el significado con la regla de negocio. |
| `environment_monitoring.installation_projection` | `educational_environment_id` | `UUID NOT` | — | Campo de installation_projection; validar el significado con la regla de negocio. |
| `environment_monitoring.installation_projection` | `environment_type_id` | `UUID NOT` | — | Referencia al tipo de ambiente. |
| `environment_monitoring.installation_projection` | `sensor_id` | `UUID NOT` | — | Referencia al sensor. |
| `environment_monitoring.installation_projection` | `removed_at` | `TIMESTAMPTZ` | — | Fecha y hora de retiro, si aplica. |
| `environment_monitoring.installation_projection` | `synced_at` | `TIMESTAMPTZ NOT` | — | Campo de installation_projection; validar el significado con la regla de negocio. |
| `environment_monitoring.quality_flag` | `quality_flag_id` | `UUID PRIMARY` | — | Referencia a la clasificación de calidad. |
| `environment_monitoring.quality_flag` | `code` | `VARCHAR(20) NOT` | UNIQUE | Campo de quality_flag; validar el significado con la regla de negocio. |
| `environment_monitoring.quality_flag` | `name` | `VARCHAR(60) NOT` | — | Nombre del elemento. |
| `environment_monitoring.severity` | `severity_id` | `UUID PRIMARY` | — | Referencia a la severidad. |
| `environment_monitoring.severity` | `code` | `VARCHAR(20) NOT` | UNIQUE | Campo de severity; validar el significado con la regla de negocio. |
| `environment_monitoring.severity` | `name` | `VARCHAR(40) NOT` | — | Nombre del elemento. |
| `environment_monitoring.severity` | `level` | `SMALLINT NOT` | UNIQUE | Campo de severity; validar el significado con la regla de negocio. |
| `environment_monitoring.variable` | `variable_id` | `UUID PRIMARY` | — | Referencia a la variable ambiental. |
| `environment_monitoring.variable` | `code` | `VARCHAR(30) NOT` | UNIQUE | Campo de variable; validar el significado con la regla de negocio. |
| `environment_monitoring.variable` | `name` | `VARCHAR(80) NOT` | — | Nombre del elemento. |
| `environment_monitoring.variable` | `measurement_unit_id` | `UUID NOT` | — | Referencia a la unidad de medida. |
| `environment_monitoring.variable` | `unit_symbol` | `VARCHAR(10) NOT` | — | Campo de variable; validar el significado con la regla de negocio. |
| `environment_monitoring.variable` | `created_at` | `TIMESTAMPTZ NOT` | — | Fecha y hora de creación. |
| `environment_monitoring.variable_threshold` | `variable_threshold_id` | `UUID PRIMARY` | — | Campo de variable_threshold; validar el significado con la regla de negocio. |
| `environment_monitoring.variable_threshold` | `variable_id` | `UUID NOT` | — | Referencia a la variable ambiental. |
| `environment_monitoring.variable_threshold` | `environment_type_id` | `UUID NOT` | — | Referencia al tipo de ambiente. |
| `environment_monitoring.variable_threshold` | `min_value` | `NUMERIC(12,4)` | — | Valor mínimo configurado o calculado. |
| `environment_monitoring.variable_threshold` | `max_value` | `NUMERIC(12,4)` | — | Valor máximo configurado o calculado. |
| `environment_monitoring.variable_threshold` | `severity_id` | `UUID NOT` | — | Referencia a la severidad. |
| `environment_monitoring.variable_threshold` | `valid_from` | `DATE NOT` | — | Inicio de vigencia. |
| `environment_monitoring.variable_threshold` | `valid_to` | `DATE` | — | Fin de vigencia, si aplica. |
| `seguridad.institution` | `id` | `UUID` | PK, NOT NULL, DEFAULT gen_random_uuid() | Identificador único del registro. |
| `seguridad.institution` | `code` | `VARCHAR(20)` | NOT NULL | Campo de institution; validar el significado con la regla de negocio. |
| `seguridad.institution` | `name` | `VARCHAR(150)` | NOT NULL | Nombre del elemento. |
| `seguridad.institution` | `type` | `VARCHAR(50)` | — | Campo de institution; validar el significado con la regla de negocio. |
| `seguridad.institution` | `status` | `VARCHAR(20)` | NOT NULL | Estado del elemento. |
| `seguridad.institution` | `created_at` | `TIMESTAMPTZ` | NOT NULL | Fecha y hora de creación. |
| `seguridad.institution` | `updated_at` | `TIMESTAMPTZ` | NOT NULL | Fecha y hora de actualización. |
| `seguridad.password_reset_tokens` | `id` | `UUID` | PK, NOT NULL, DEFAULT gen_random_uuid() | Identificador único del registro. |
| `seguridad.password_reset_tokens` | `user_id` | `UUID` | NOT NULL | Referencia lógica al usuario. |
| `seguridad.password_reset_tokens` | `code_hash` | `VARCHAR(255)` | NOT NULL | Campo de password_reset_tokens; validar el significado con la regla de negocio. |
| `seguridad.password_reset_tokens` | `expires_at` | `TIMESTAMPTZ` | NOT NULL | Fecha y hora de expiración. |
| `seguridad.password_reset_tokens` | `used_at` | `TIMESTAMPTZ` | — | Campo de password_reset_tokens; validar el significado con la regla de negocio. |
| `seguridad.password_reset_tokens` | `created_at` | `TIMESTAMPTZ` | NOT NULL | Fecha y hora de creación. |
| `seguridad.refresh_tokens` | `id` | `UUID` | PK, NOT NULL, DEFAULT gen_random_uuid() | Identificador único del registro. |
| `seguridad.refresh_tokens` | `user_id` | `UUID` | NOT NULL | Referencia lógica al usuario. |
| `seguridad.refresh_tokens` | `token_hash` | `VARCHAR(255)` | NOT NULL | Hash del token. |
| `seguridad.refresh_tokens` | `expires_at` | `TIMESTAMPTZ` | NOT NULL | Fecha y hora de expiración. |
| `seguridad.refresh_tokens` | `revoked_at` | `TIMESTAMPTZ` | — | Campo de refresh_tokens; validar el significado con la regla de negocio. |
| `seguridad.refresh_tokens` | `created_at` | `TIMESTAMPTZ` | NOT NULL, DEFAULT now() | Fecha y hora de creación. |
| `seguridad.refresh_tokens` | `user_agent` | `TEXT` | — | Campo de refresh_tokens; validar el significado con la regla de negocio. |
| `seguridad.roles` | `id` | `UUID` | PK, NOT NULL, DEFAULT gen_random_uuid() | Identificador único del registro. |
| `seguridad.roles` | `name` | `VARCHAR(50)` | NOT NULL, UNIQUE | Nombre del elemento. |
| `seguridad.roles` | `description` | `TEXT` | — | Descripción del elemento. |
| `seguridad.roles` | `created_at` | `TIMESTAMPTZ` | NOT NULL, DEFAULT now() | Fecha y hora de creación. |
| `seguridad.user_identity` | `id` | `UUID` | PK, NOT NULL, DEFAULT gen_random_uuid() | Identificador único del registro. |
| `seguridad.user_identity` | `user_id` | `UUID` | NOT NULL | Referencia lógica al usuario. |
| `seguridad.user_identity` | `provider` | `VARCHAR(30)` | NOT NULL | Campo de user_identity; validar el significado con la regla de negocio. |
| `seguridad.user_identity` | `provider_user_id` | `VARCHAR(255)` | NOT NULL | Campo de user_identity; validar el significado con la regla de negocio. |
| `seguridad.user_identity` | `email` | `VARCHAR(255)` | — | Correo electrónico. |
| `seguridad.user_identity` | `display_name` | `VARCHAR(255)` | — | Campo de user_identity; validar el significado con la regla de negocio. |
| `seguridad.user_identity` | `avatar_url` | `VARCHAR(500)` | — | Campo de user_identity; validar el significado con la regla de negocio. |
| `seguridad.user_identity` | `created_at` | `TIMESTAMPTZ` | NOT NULL, DEFAULT now() | Fecha y hora de creación. |
| `seguridad.user_roles` | `user_id` | `UUID` | NOT NULL | Referencia lógica al usuario. |
| `seguridad.user_roles` | `role_id` | `UUID` | NOT NULL | Referencia al rol. |
| `seguridad.user_roles` | `assigned_at` | `TIMESTAMPTZ` | NOT NULL, DEFAULT now() | Campo de user_roles; validar el significado con la regla de negocio. |
| `seguridad.user_roles` | `assigned_by` | `UUID` | — | Campo de user_roles; validar el significado con la regla de negocio. |
| `seguridad.users` | `id` | `UUID` | PK, NOT NULL, DEFAULT gen_random_uuid() | Identificador único del registro. |
| `seguridad.users` | `email` | `VARCHAR(255)` | NOT NULL, UNIQUE | Correo electrónico. |
| `seguridad.users` | `username` | `VARCHAR(100)` | NOT NULL, UNIQUE | Campo de users; validar el significado con la regla de negocio. |
| `seguridad.users` | `password_hash` | `VARCHAR(255)` | NOT NULL | Hash de contraseña; nunca almacenar contraseña en texto plano. |
| `seguridad.users` | `email_verified` | `BOOLEAN` | NOT NULL, DEFAULT False | Campo de users; validar el significado con la regla de negocio. |
| `seguridad.users` | `failed_attempts` | `INTEGER` | NOT NULL, DEFAULT 0 | Campo de users; validar el significado con la regla de negocio. |
| `seguridad.users` | `locked_until` | `TIMESTAMPTZ` | — | Campo de users; validar el significado con la regla de negocio. |
| `seguridad.users` | `created_at` | `TIMESTAMPTZ` | NOT NULL, DEFAULT now() | Fecha y hora de creación. |
| `seguridad.users` | `updated_at` | `TIMESTAMPTZ` | NOT NULL, DEFAULT now() | Fecha y hora de actualización. |
| `seguridad.users` | `deleted_at` | `TIMESTAMPTZ` | — | Campo de users; validar el significado con la regla de negocio. |
| `sensors.measurement_unit` | `measurement_unit_id` | `UUID` | PK, NOT NULL, DEFAULT gen_random_uuid() | Referencia a la unidad de medida. |
| `sensors.measurement_unit` | `code` | `VARCHAR(30)` | NOT NULL, UNIQUE | Campo de measurement_unit; validar el significado con la regla de negocio. |
| `sensors.measurement_unit` | `symbol` | `VARCHAR(10)` | NOT NULL | Campo de measurement_unit; validar el significado con la regla de negocio. |
| `sensors.measurement_unit` | `name` | `VARCHAR(80)` | NOT NULL | Nombre del elemento. |
| `sensors.measurement_unit` | `created_at` | `TIMESTAMPTZ` | NOT NULL, DEFAULT now() | Fecha y hora de creación. |
| `sensors.outbox_event` | `event_id` | `UUID` | PK, NOT NULL | Campo de outbox_event; validar el significado con la regla de negocio. |
| `sensors.outbox_event` | `event_type` | `VARCHAR(80)` | NOT NULL | Tipo de evento. |
| `sensors.outbox_event` | `aggregate_type` | `VARCHAR(60)` | NOT NULL | Campo de outbox_event; validar el significado con la regla de negocio. |
| `sensors.outbox_event` | `aggregate_id` | `VARCHAR(60)` | NOT NULL | Campo de outbox_event; validar el significado con la regla de negocio. |
| `sensors.outbox_event` | `routing_key` | `VARCHAR(80)` | NOT NULL | Campo de outbox_event; validar el significado con la regla de negocio. |
| `sensors.outbox_event` | `payload` | `TEXT` | NOT NULL | Contenido del evento o mensaje. |
| `sensors.outbox_event` | `occurred_at` | `TIMESTAMPTZ` | NOT NULL | Fecha y hora del evento. |
| `sensors.outbox_event` | `published_at` | `TIMESTAMPTZ` | — | Fecha y hora de publicación. |
| `sensors.outbox_event` | `attempts` | `INTEGER` | NOT NULL, DEFAULT 0 | Campo de outbox_event; validar el significado con la regla de negocio. |
| `sensors.outbox_event` | `last_error` | `TEXT` | — | Campo de outbox_event; validar el significado con la regla de negocio. |
| `sensors.sensor` | `sensor_id` | `UUID` | PK, NOT NULL, DEFAULT gen_random_uuid() | Referencia al sensor. |
| `sensors.sensor` | `serial_number` | `VARCHAR(60)` | NOT NULL, UNIQUE | Número de serie del dispositivo. |
| `sensors.sensor` | `sensor_model_id` | `UUID` | NOT NULL | Referencia al modelo del sensor. |
| `sensors.sensor` | `sensor_status_id` | `UUID` | NOT NULL | Referencia al estado del sensor. |
| `sensors.sensor` | `last_seen_at` | `TIMESTAMPTZ` | — | Campo de sensor; validar el significado con la regla de negocio. |
| `sensors.sensor` | `created_at` | `TIMESTAMPTZ` | NOT NULL, DEFAULT now() | Fecha y hora de creación. |
| `sensors.sensor` | `updated_at` | `TIMESTAMPTZ` | — | Fecha y hora de actualización. |
| `sensors.sensor_installation` | `sensor_installation_id` | `UUID` | PK, NOT NULL, DEFAULT gen_random_uuid() | Campo de sensor_installation; validar el significado con la regla de negocio. |
| `sensors.sensor_installation` | `sensor_id` | `UUID` | NOT NULL | Referencia al sensor. |
| `sensors.sensor_installation` | `educational_environment_id` | `UUID` | NOT NULL | Campo de sensor_installation; validar el significado con la regla de negocio. |
| `sensors.sensor_installation` | `installed_at` | `TIMESTAMPTZ` | NOT NULL | Fecha y hora de instalación. |
| `sensors.sensor_installation` | `removed_at` | `TIMESTAMPTZ` | — | Fecha y hora de retiro, si aplica. |
| `sensors.sensor_model` | `sensor_model_id` | `UUID` | PK, NOT NULL, DEFAULT gen_random_uuid() | Referencia al modelo del sensor. |
| `sensors.sensor_model` | `code` | `VARCHAR(30)` | NOT NULL, UNIQUE | Campo de sensor_model; validar el significado con la regla de negocio. |
| `sensors.sensor_model` | `name` | `VARCHAR(80)` | NOT NULL | Nombre del elemento. |
| `sensors.sensor_model` | `description` | `VARCHAR(255)` | — | Descripción del elemento. |
| `sensors.sensor_model` | `created_at` | `TIMESTAMPTZ` | NOT NULL, DEFAULT now() | Fecha y hora de creación. |
| `sensors.sensor_status` | `sensor_status_id` | `UUID` | PK, NOT NULL, DEFAULT gen_random_uuid() | Referencia al estado del sensor. |
| `sensors.sensor_status` | `code` | `VARCHAR(30)` | NOT NULL, UNIQUE | Campo de sensor_status; validar el significado con la regla de negocio. |
| `sensors.sensor_status` | `name` | `VARCHAR(80)` | NOT NULL | Nombre del elemento. |
| `sensors.sensor_status` | `created_at` | `TIMESTAMPTZ` | NOT NULL, DEFAULT now() | Fecha y hora de creación. |
| `sensors.sensor_variable` | `sensor_id` | `UUID` | NOT NULL | Referencia al sensor. |
| `sensors.sensor_variable` | `variable_id` | `UUID` | NOT NULL | Referencia a la variable ambiental. |
| `sensors.variable` | `variable_id` | `UUID` | PK, NOT NULL, DEFAULT gen_random_uuid() | Referencia a la variable ambiental. |
| `sensors.variable` | `code` | `VARCHAR(30)` | NOT NULL, UNIQUE | Campo de variable; validar el significado con la regla de negocio. |
| `sensors.variable` | `name` | `VARCHAR(80)` | NOT NULL | Nombre del elemento. |
| `sensors.variable` | `measurement_unit_id` | `UUID` | NOT NULL | Referencia a la unidad de medida. |
| `sensors.variable` | `description` | `VARCHAR(255)` | — | Descripción del elemento. |
| `sensors.variable` | `created_at` | `TIMESTAMPTZ` | NOT NULL, DEFAULT now() | Fecha y hora de creación. |
| `user_experience.classroom_ratings` | `rating_id` | `UUID PRIMARY` | — | Campo de classroom_ratings; validar el significado con la regla de negocio. |
| `user_experience.classroom_ratings` | `user_id` | `UUID NOT` | — | Referencia lógica al usuario. |
| `user_experience.classroom_ratings` | `classroom_id` | `UUID NOT` | — | Campo de classroom_ratings; validar el significado con la regla de negocio. |
| `user_experience.classroom_ratings` | `score` | `INTEGER NOT` | — | Campo de classroom_ratings; validar el significado con la regla de negocio. |
| `user_experience.classroom_ratings` | `comment` | `VARCHAR(1000)` | — | Campo de classroom_ratings; validar el significado con la regla de negocio. |
| `user_experience.classroom_ratings` | `rated_at` | `TIMESTAMPTZ NOT` | — | Campo de classroom_ratings; validar el significado con la regla de negocio. |
| `user_experience.favorites` | `favorite_id` | `UUID PRIMARY` | — | Campo de favorites; validar el significado con la regla de negocio. |
| `user_experience.favorites` | `user_id` | `UUID NOT` | — | Referencia lógica al usuario. |
| `user_experience.favorites` | `classroom_id` | `UUID` | — | Campo de favorites; validar el significado con la regla de negocio. |
| `user_experience.favorites` | `variable_id` | `UUID` | — | Referencia a la variable ambiental. |
| `user_experience.favorites` | `added_at` | `TIMESTAMPTZ NOT` | — | Campo de favorites; validar el significado con la regla de negocio. |
| `user_experience.favorites` | `OR` | `VARIABLE` | NOT NULL | Campo de favorites; validar el significado con la regla de negocio. |
| `user_experience.notification_state` | `user_id` | `UUID NOT` | — | Referencia lógica al usuario. |
| `user_experience.notification_state` | `alert_id` | `UUID NOT` | — | Campo de notification_state; validar el significado con la regla de negocio. |
| `user_experience.notification_state` | `read_at` | `TIMESTAMPTZ NOT` | — | Campo de notification_state; validar el significado con la regla de negocio. |
| `user_experience.searches` | `search_id` | `UUID PRIMARY` | — | Campo de searches; validar el significado con la regla de negocio. |
| `user_experience.searches` | `user_id` | `UUID NOT` | — | Referencia lógica al usuario. |
| `user_experience.searches` | `search_text` | `VARCHAR(500)` | — | Campo de searches; validar el significado con la regla de negocio. |
| `user_experience.searches` | `applied_filter` | `VARCHAR(500)` | — | Campo de searches; validar el significado con la regla de negocio. |
| `user_experience.searches` | `searched_at` | `TIMESTAMPTZ NOT` | — | Campo de searches; validar el significado con la regla de negocio. |
| `user_experience.user_preferences` | `preference_id` | `UUID PRIMARY` | — | Campo de user_preferences; validar el significado con la regla de negocio. |
| `user_experience.user_preferences` | `user_id` | `UUID NOT` | UNIQUE | Referencia lógica al usuario. |
| `user_experience.user_preferences` | `language` | `VARCHAR(10)` | — | Idioma preferido. |
| `user_experience.user_preferences` | `color_theme` | `VARCHAR(20)` | — | Campo de user_preferences; validar el significado con la regla de negocio. |
| `user_experience.user_preferences` | `notifications_enabled` | `BOOLEAN NOT` | — | Indica si las notificaciones están habilitadas. |
| `user_experience.user_preferences` | `time_zone` | `VARCHAR(100)` | — | Campo de user_preferences; validar el significado con la regla de negocio. |
| `user_experience.user_preferences` | `date_format` | `VARCHAR(20)` | — | Campo de user_preferences; validar el significado con la regla de negocio. |
| `user_experience.user_preferences` | `reminders` | `JSONB NOT` | — | Campo de user_preferences; validar el significado con la regla de negocio. |
| `user_experience.user_preferences` | `dark_mode` | `BOOLEAN NOT` | — | Indica si está habilitado el modo oscuro. |
| `user_experience.user_preferences` | `auto_time_zone` | `BOOLEAN NOT` | — | Campo de user_preferences; validar el significado con la regla de negocio. |
| `user_management.user_profiles` | `profile_id` | `UUID` | PK, NOT NULL, DEFAULT gen_random_uuid() | Campo de user_profiles; validar el significado con la regla de negocio. |
| `user_management.user_profiles` | `user_id` | `UUID` | NOT NULL | Referencia lógica al usuario. |
| `user_management.user_profiles` | `full_name` | `VARCHAR(150)` | NOT NULL | Campo de user_profiles; validar el significado con la regla de negocio. |
| `user_management.user_profiles` | `phone` | `VARCHAR(30)` | — | Campo de user_profiles; validar el significado con la regla de negocio. |
| `user_management.user_profiles` | `department` | `VARCHAR(100)` | — | Campo de user_profiles; validar el significado con la regla de negocio. |
| `user_management.user_profiles` | `position` | `VARCHAR(100)` | — | Campo de user_profiles; validar el significado con la regla de negocio. |
| `user_management.user_profiles` | `locale` | `VARCHAR(10)` | — | Campo de user_profiles; validar el significado con la regla de negocio. |
| `user_management.user_profiles` | `status` | `VARCHAR(20)` | NOT NULL | Estado del elemento. |
| `user_management.user_profiles` | `created_at` | `TIMESTAMPTZ` | NOT NULL | Fecha y hora de creación. |
| `user_management.user_profiles` | `updated_at` | `TIMESTAMPTZ` | NOT NULL | Fecha y hora de actualización. |
| `user_management.user_profiles` | `deleted_at` | `TIMESTAMPTZ` | — | Campo de user_profiles; validar el significado con la regla de negocio. |
