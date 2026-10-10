# 06. Database — EduAirControl

**Project:** EduAirControl  
**Program:** Software Analysis and Development Technologist (ADSO)  
**Cohort:** ADSO-3145556  
**Institution:** SENA — Industry  
**Location:** Neiva, Huila, Colombia  
**Version:** 1.0  
**Source:** Liquibase migrations and SQL scripts found in `proyecto.zip`.

## Scope and caveats

This model is documented from the database structures present in project migration files. Technical table and column names remain in English to match the code. Data is separated by domain and microservice. Some cross-domain references are logical and are not necessarily physical foreign keys.

Original per-microservice Liquibase migrations are the source of truth for deployment, including execution order, seed data, indexes, and constraints. The consolidated SQL script included here is a documentation reference and must be tested before use in a live environment.
## Data dictionary

Descriptions inferred from technical names should be validated against the business rules.

| Table | Field | Type | Constraints | Description |
|---|---|---|---|---|
| `classrooms.campuses` | `campus_id` | `UUID` | PK, NOT NULL, DEFAULT gen_random_uuid() | Reference to the campus. |
| `classrooms.campuses` | `code` | `VARCHAR(30)` | NOT NULL, UNIQUE | Field of campuses; confirm meaning against business rules. |
| `classrooms.campuses` | `name` | `VARCHAR(150)` | NOT NULL | Element name. |
| `classrooms.campuses` | `city` | `VARCHAR(100)` | — | Field of campuses; confirm meaning against business rules. |
| `classrooms.campuses` | `status` | `VARCHAR(30)` | NOT NULL, DEFAULT ACTIVE | Element status. |
| `classrooms.campuses` | `created_at` | `TIMESTAMPTZ` | NOT NULL, DEFAULT now() | Creation timestamp. |
| `classrooms.campuses` | `updated_at` | `TIMESTAMPTZ` | NOT NULL, DEFAULT now() | Last update timestamp. |
| `classrooms.campuses` | `deleted_at` | `TIMESTAMPTZ` | — | Field of campuses; confirm meaning against business rules. |
| `classrooms.educational_environment` | `educational_environment_id` | `UUID` | PK, NOT NULL, DEFAULT gen_random_uuid() | Field of educational_environment; confirm meaning against business rules. |
| `classrooms.educational_environment` | `campus_id` | `UUID` | NOT NULL | Reference to the campus. |
| `classrooms.educational_environment` | `code` | `VARCHAR(30)` | NOT NULL | Field of educational_environment; confirm meaning against business rules. |
| `classrooms.educational_environment` | `name` | `VARCHAR(120)` | NOT NULL | Element name. |
| `classrooms.educational_environment` | `environment_type_id` | `UUID` | NOT NULL | Reference to the environment type. |
| `classrooms.educational_environment` | `floor` | `INTEGER` | — | Field of educational_environment; confirm meaning against business rules. |
| `classrooms.educational_environment` | `area_m2` | `NUMERIC(8,2)` | — | Field of educational_environment; confirm meaning against business rules. |
| `classrooms.educational_environment` | `occupancy_capacity` | `INTEGER` | — | Field of educational_environment; confirm meaning against business rules. |
| `classrooms.educational_environment` | `status` | `VARCHAR(30)` | NOT NULL, DEFAULT ACTIVE | Element status. |
| `classrooms.educational_environment` | `created_at` | `TIMESTAMPTZ` | NOT NULL, DEFAULT now() | Creation timestamp. |
| `classrooms.educational_environment` | `updated_at` | `TIMESTAMPTZ` | NOT NULL, DEFAULT now() | Last update timestamp. |
| `classrooms.educational_environment` | `deleted_at` | `TIMESTAMPTZ` | — | Field of educational_environment; confirm meaning against business rules. |
| `classrooms.environment_types` | `environment_type_id` | `UUID` | PK, NOT NULL, DEFAULT gen_random_uuid() | Reference to the environment type. |
| `classrooms.environment_types` | `code` | `VARCHAR(30)` | NOT NULL, UNIQUE | Field of environment_types; confirm meaning against business rules. |
| `classrooms.environment_types` | `name` | `VARCHAR(80)` | NOT NULL, UNIQUE | Element name. |
| `classrooms.environment_types` | `description` | `VARCHAR(255)` | — | Element description. |
| `classrooms.environment_types` | `created_at` | `TIMESTAMPTZ` | NOT NULL, DEFAULT now() | Creation timestamp. |
| `classrooms.environment_types` | `updated_at` | `TIMESTAMPTZ` | NOT NULL, DEFAULT now() | Last update timestamp. |
| `classrooms.environment_types` | `deleted_at` | `TIMESTAMPTZ` | — | Field of environment_types; confirm meaning against business rules. |
| `classrooms.outbox_event` | `event_id` | `UUID` | PK, NOT NULL | Field of outbox_event; confirm meaning against business rules. |
| `classrooms.outbox_event` | `event_type` | `VARCHAR(80)` | NOT NULL | Field of outbox_event; confirm meaning against business rules. |
| `classrooms.outbox_event` | `aggregate_type` | `VARCHAR(60)` | NOT NULL | Field of outbox_event; confirm meaning against business rules. |
| `classrooms.outbox_event` | `aggregate_id` | `VARCHAR(60)` | NOT NULL | Field of outbox_event; confirm meaning against business rules. |
| `classrooms.outbox_event` | `routing_key` | `VARCHAR(80)` | NOT NULL | Field of outbox_event; confirm meaning against business rules. |
| `classrooms.outbox_event` | `payload` | `TEXT` | NOT NULL | Field of outbox_event; confirm meaning against business rules. |
| `classrooms.outbox_event` | `occurred_at` | `TIMESTAMPTZ` | NOT NULL | Field of outbox_event; confirm meaning against business rules. |
| `classrooms.outbox_event` | `published_at` | `TIMESTAMPTZ` | — | Field of outbox_event; confirm meaning against business rules. |
| `classrooms.outbox_event` | `attempts` | `INTEGER` | NOT NULL, DEFAULT 0 | Field of outbox_event; confirm meaning against business rules. |
| `classrooms.outbox_event` | `last_error` | `TEXT` | — | Field of outbox_event; confirm meaning against business rules. |
| `environment_monitoring.analysis_result` | `analysis_result_id` | `UUID PRIMARY` | — | Field of analysis_result; confirm meaning against business rules. |
| `environment_monitoring.analysis_result` | `environmental_analysis_id` | `UUID NOT` | — | Reference to the environmental analysis. |
| `environment_monitoring.analysis_result` | `variable_id` | `UUID NOT` | — | Reference to the environmental variable. |
| `environment_monitoring.analysis_result` | `min_value` | `NUMERIC(12,4) NOT` | — | Field of analysis_result; confirm meaning against business rules. |
| `environment_monitoring.analysis_result` | `max_value` | `NUMERIC(12,4) NOT` | — | Field of analysis_result; confirm meaning against business rules. |
| `environment_monitoring.analysis_result` | `avg_value` | `NUMERIC(12,4) NOT` | — | Field of analysis_result; confirm meaning against business rules. |
| `environment_monitoring.analysis_result` | `sample_count` | `INTEGER NOT` | — | Field of analysis_result; confirm meaning against business rules. |
| `environment_monitoring.analysis_result` | `exceedance_count` | `INTEGER NOT` | — | Field of analysis_result; confirm meaning against business rules. |
| `environment_monitoring.analysis_statuses` | `analysis_status_id` | `UUID PRIMARY` | — | Reference to the analysis status. |
| `environment_monitoring.analysis_statuses` | `code` | `VARCHAR(20) NOT` | UNIQUE | Field of analysis_statuses; confirm meaning against business rules. |
| `environment_monitoring.analysis_statuses` | `name` | `VARCHAR(60) NOT` | — | Element name. |
| `environment_monitoring.educational_environment` | `educational_environment_id` | `UUID PRIMARY` | — | Field of educational_environment; confirm meaning against business rules. |
| `environment_monitoring.educational_environment` | `code` | `VARCHAR(30) NOT` | — | Field of educational_environment; confirm meaning against business rules. |
| `environment_monitoring.educational_environment` | `name` | `VARCHAR(120) NOT` | — | Element name. |
| `environment_monitoring.educational_environment` | `campus_id` | `UUID` | — | Reference to the campus. |
| `environment_monitoring.educational_environment` | `environment_type_id` | `UUID NOT` | — | Reference to the environment type. |
| `environment_monitoring.educational_environment` | `floor` | `INTEGER` | — | Field of educational_environment; confirm meaning against business rules. |
| `environment_monitoring.environment_alert` | `environment_alert_id` | `UUID PRIMARY` | — | Field of environment_alert; confirm meaning against business rules. |
| `environment_monitoring.environment_alert` | `educational_environment_id` | `UUID NOT` | — | Field of environment_alert; confirm meaning against business rules. |
| `environment_monitoring.environment_alert` | `variable_id` | `UUID NOT` | — | Reference to the environmental variable. |
| `environment_monitoring.environment_alert` | `variable_threshold_id` | `UUID NOT` | — | Field of environment_alert; confirm meaning against business rules. |
| `environment_monitoring.environment_alert` | `triggering_measurement_id` | `UUID NOT` | — | Field of environment_alert; confirm meaning against business rules. |
| `environment_monitoring.environment_alert` | `raised_at` | `TIMESTAMPTZ NOT` | — | Field of environment_alert; confirm meaning against business rules. |
| `environment_monitoring.environment_alert` | `acknowledged_at` | `TIMESTAMPTZ` | — | Field of environment_alert; confirm meaning against business rules. |
| `environment_monitoring.environment_alert` | `acknowledged_by` | `UUID` | — | Field of environment_alert; confirm meaning against business rules. |
| `environment_monitoring.environment_measurement` | `environment_measurement_id` | `UUID PRIMARY` | — | Field of environment_measurement; confirm meaning against business rules. |
| `environment_monitoring.environment_measurement` | `sensor_installation_id` | `UUID NOT` | — | Field of environment_measurement; confirm meaning against business rules. |
| `environment_monitoring.environment_measurement` | `variable_id` | `UUID NOT` | — | Reference to the environmental variable. |
| `environment_monitoring.environment_measurement` | `measured_value` | `NUMERIC(12,4) NOT` | — | Measured numeric value. |
| `environment_monitoring.environment_measurement` | `measured_at` | `TIMESTAMPTZ NOT` | — | Measurement timestamp. |
| `environment_monitoring.environment_measurement` | `quality_flag_id` | `UUID NOT` | — | Reference to the quality classification. |
| `environment_monitoring.environment_measurement` | `created_at` | `TIMESTAMPTZ NOT` | — | Creation timestamp. |
| `environment_monitoring.environmental_analysis` | `environmental_analysis_id` | `UUID PRIMARY` | — | Reference to the environmental analysis. |
| `environment_monitoring.environmental_analysis` | `educational_environment_id` | `UUID NOT` | — | Field of environmental_analysis; confirm meaning against business rules. |
| `environment_monitoring.environmental_analysis` | `period_start` | `TIMESTAMPTZ NOT` | — | Start of the analyzed period. |
| `environment_monitoring.environmental_analysis` | `period_end` | `TIMESTAMPTZ NOT` | — | End of the analyzed period. |
| `environment_monitoring.environmental_analysis` | `analysis_status_id` | `UUID NOT` | — | Reference to the analysis status. |
| `environment_monitoring.environmental_analysis` | `requested_by` | `UUID` | — | Field of environmental_analysis; confirm meaning against business rules. |
| `environment_monitoring.environmental_analysis` | `computed_at` | `TIMESTAMPTZ` | — | Field of environmental_analysis; confirm meaning against business rules. |
| `environment_monitoring.inbox_message` | `message_id` | `UUID PRIMARY` | — | Field of inbox_message; confirm meaning against business rules. |
| `environment_monitoring.inbox_message` | `consumer` | `VARCHAR(60) NOT` | — | Field of inbox_message; confirm meaning against business rules. |
| `environment_monitoring.inbox_message` | `message_type` | `VARCHAR(80) NOT` | — | Field of inbox_message; confirm meaning against business rules. |
| `environment_monitoring.inbox_message` | `received_at` | `TIMESTAMPTZ NOT` | — | Field of inbox_message; confirm meaning against business rules. |
| `environment_monitoring.installation_projection` | `sensor_installation_id` | `UUID PRIMARY` | — | Field of installation_projection; confirm meaning against business rules. |
| `environment_monitoring.installation_projection` | `educational_environment_id` | `UUID NOT` | — | Field of installation_projection; confirm meaning against business rules. |
| `environment_monitoring.installation_projection` | `environment_type_id` | `UUID NOT` | — | Reference to the environment type. |
| `environment_monitoring.installation_projection` | `sensor_id` | `UUID NOT` | — | Reference to the sensor. |
| `environment_monitoring.installation_projection` | `removed_at` | `TIMESTAMPTZ` | — | Field of installation_projection; confirm meaning against business rules. |
| `environment_monitoring.installation_projection` | `synced_at` | `TIMESTAMPTZ NOT` | — | Field of installation_projection; confirm meaning against business rules. |
| `environment_monitoring.quality_flag` | `quality_flag_id` | `UUID PRIMARY` | — | Reference to the quality classification. |
| `environment_monitoring.quality_flag` | `code` | `VARCHAR(20) NOT` | UNIQUE | Field of quality_flag; confirm meaning against business rules. |
| `environment_monitoring.quality_flag` | `name` | `VARCHAR(60) NOT` | — | Element name. |
| `environment_monitoring.severity` | `severity_id` | `UUID PRIMARY` | — | Reference to severity. |
| `environment_monitoring.severity` | `code` | `VARCHAR(20) NOT` | UNIQUE | Field of severity; confirm meaning against business rules. |
| `environment_monitoring.severity` | `name` | `VARCHAR(40) NOT` | — | Element name. |
| `environment_monitoring.severity` | `level` | `SMALLINT NOT` | UNIQUE | Field of severity; confirm meaning against business rules. |
| `environment_monitoring.variable` | `variable_id` | `UUID PRIMARY` | — | Reference to the environmental variable. |
| `environment_monitoring.variable` | `code` | `VARCHAR(30) NOT` | UNIQUE | Field of variable; confirm meaning against business rules. |
| `environment_monitoring.variable` | `name` | `VARCHAR(80) NOT` | — | Element name. |
| `environment_monitoring.variable` | `measurement_unit_id` | `UUID NOT` | — | Reference to the measurement unit. |
| `environment_monitoring.variable` | `unit_symbol` | `VARCHAR(10) NOT` | — | Field of variable; confirm meaning against business rules. |
| `environment_monitoring.variable` | `created_at` | `TIMESTAMPTZ NOT` | — | Creation timestamp. |
| `environment_monitoring.variable_threshold` | `variable_threshold_id` | `UUID PRIMARY` | — | Field of variable_threshold; confirm meaning against business rules. |
| `environment_monitoring.variable_threshold` | `variable_id` | `UUID NOT` | — | Reference to the environmental variable. |
| `environment_monitoring.variable_threshold` | `environment_type_id` | `UUID NOT` | — | Reference to the environment type. |
| `environment_monitoring.variable_threshold` | `min_value` | `NUMERIC(12,4)` | — | Field of variable_threshold; confirm meaning against business rules. |
| `environment_monitoring.variable_threshold` | `max_value` | `NUMERIC(12,4)` | — | Field of variable_threshold; confirm meaning against business rules. |
| `environment_monitoring.variable_threshold` | `severity_id` | `UUID NOT` | — | Reference to severity. |
| `environment_monitoring.variable_threshold` | `valid_from` | `DATE NOT` | — | Field of variable_threshold; confirm meaning against business rules. |
| `environment_monitoring.variable_threshold` | `valid_to` | `DATE` | — | End of validity, when applicable. |
| `seguridad.institution` | `id` | `UUID` | PK, NOT NULL, DEFAULT gen_random_uuid() | Unique record identifier. |
| `seguridad.institution` | `code` | `VARCHAR(20)` | NOT NULL | Field of institution; confirm meaning against business rules. |
| `seguridad.institution` | `name` | `VARCHAR(150)` | NOT NULL | Element name. |
| `seguridad.institution` | `type` | `VARCHAR(50)` | — | Field of institution; confirm meaning against business rules. |
| `seguridad.institution` | `status` | `VARCHAR(20)` | NOT NULL | Element status. |
| `seguridad.institution` | `created_at` | `TIMESTAMPTZ` | NOT NULL | Creation timestamp. |
| `seguridad.institution` | `updated_at` | `TIMESTAMPTZ` | NOT NULL | Last update timestamp. |
| `seguridad.password_reset_tokens` | `id` | `UUID` | PK, NOT NULL, DEFAULT gen_random_uuid() | Unique record identifier. |
| `seguridad.password_reset_tokens` | `user_id` | `UUID` | NOT NULL | Logical reference to the user. |
| `seguridad.password_reset_tokens` | `code_hash` | `VARCHAR(255)` | NOT NULL | Field of password_reset_tokens; confirm meaning against business rules. |
| `seguridad.password_reset_tokens` | `expires_at` | `TIMESTAMPTZ` | NOT NULL | Expiration timestamp. |
| `seguridad.password_reset_tokens` | `used_at` | `TIMESTAMPTZ` | — | Field of password_reset_tokens; confirm meaning against business rules. |
| `seguridad.password_reset_tokens` | `created_at` | `TIMESTAMPTZ` | NOT NULL | Creation timestamp. |
| `seguridad.refresh_tokens` | `id` | `UUID` | PK, NOT NULL, DEFAULT gen_random_uuid() | Unique record identifier. |
| `seguridad.refresh_tokens` | `user_id` | `UUID` | NOT NULL | Logical reference to the user. |
| `seguridad.refresh_tokens` | `token_hash` | `VARCHAR(255)` | NOT NULL | Token hash. |
| `seguridad.refresh_tokens` | `expires_at` | `TIMESTAMPTZ` | NOT NULL | Expiration timestamp. |
| `seguridad.refresh_tokens` | `revoked_at` | `TIMESTAMPTZ` | — | Field of refresh_tokens; confirm meaning against business rules. |
| `seguridad.refresh_tokens` | `created_at` | `TIMESTAMPTZ` | NOT NULL, DEFAULT now() | Creation timestamp. |
| `seguridad.refresh_tokens` | `user_agent` | `TEXT` | — | Field of refresh_tokens; confirm meaning against business rules. |
| `seguridad.roles` | `id` | `UUID` | PK, NOT NULL, DEFAULT gen_random_uuid() | Unique record identifier. |
| `seguridad.roles` | `name` | `VARCHAR(50)` | NOT NULL, UNIQUE | Element name. |
| `seguridad.roles` | `description` | `TEXT` | — | Element description. |
| `seguridad.roles` | `created_at` | `TIMESTAMPTZ` | NOT NULL, DEFAULT now() | Creation timestamp. |
| `seguridad.user_identity` | `id` | `UUID` | PK, NOT NULL, DEFAULT gen_random_uuid() | Unique record identifier. |
| `seguridad.user_identity` | `user_id` | `UUID` | NOT NULL | Logical reference to the user. |
| `seguridad.user_identity` | `provider` | `VARCHAR(30)` | NOT NULL | Field of user_identity; confirm meaning against business rules. |
| `seguridad.user_identity` | `provider_user_id` | `VARCHAR(255)` | NOT NULL | Field of user_identity; confirm meaning against business rules. |
| `seguridad.user_identity` | `email` | `VARCHAR(255)` | — | Email address. |
| `seguridad.user_identity` | `display_name` | `VARCHAR(255)` | — | Field of user_identity; confirm meaning against business rules. |
| `seguridad.user_identity` | `avatar_url` | `VARCHAR(500)` | — | Field of user_identity; confirm meaning against business rules. |
| `seguridad.user_identity` | `created_at` | `TIMESTAMPTZ` | NOT NULL, DEFAULT now() | Creation timestamp. |
| `seguridad.user_roles` | `user_id` | `UUID` | NOT NULL | Logical reference to the user. |
| `seguridad.user_roles` | `role_id` | `UUID` | NOT NULL | Reference to the role. |
| `seguridad.user_roles` | `assigned_at` | `TIMESTAMPTZ` | NOT NULL, DEFAULT now() | Field of user_roles; confirm meaning against business rules. |
| `seguridad.user_roles` | `assigned_by` | `UUID` | — | Field of user_roles; confirm meaning against business rules. |
| `seguridad.users` | `id` | `UUID` | PK, NOT NULL, DEFAULT gen_random_uuid() | Unique record identifier. |
| `seguridad.users` | `email` | `VARCHAR(255)` | NOT NULL, UNIQUE | Email address. |
| `seguridad.users` | `username` | `VARCHAR(100)` | NOT NULL, UNIQUE | Field of users; confirm meaning against business rules. |
| `seguridad.users` | `password_hash` | `VARCHAR(255)` | NOT NULL | Password hash; never store a plain-text password. |
| `seguridad.users` | `email_verified` | `BOOLEAN` | NOT NULL, DEFAULT False | Field of users; confirm meaning against business rules. |
| `seguridad.users` | `failed_attempts` | `INTEGER` | NOT NULL, DEFAULT 0 | Field of users; confirm meaning against business rules. |
| `seguridad.users` | `locked_until` | `TIMESTAMPTZ` | — | Field of users; confirm meaning against business rules. |
| `seguridad.users` | `created_at` | `TIMESTAMPTZ` | NOT NULL, DEFAULT now() | Creation timestamp. |
| `seguridad.users` | `updated_at` | `TIMESTAMPTZ` | NOT NULL, DEFAULT now() | Last update timestamp. |
| `seguridad.users` | `deleted_at` | `TIMESTAMPTZ` | — | Field of users; confirm meaning against business rules. |
| `sensors.measurement_unit` | `measurement_unit_id` | `UUID` | PK, NOT NULL, DEFAULT gen_random_uuid() | Reference to the measurement unit. |
| `sensors.measurement_unit` | `code` | `VARCHAR(30)` | NOT NULL, UNIQUE | Field of measurement_unit; confirm meaning against business rules. |
| `sensors.measurement_unit` | `symbol` | `VARCHAR(10)` | NOT NULL | Field of measurement_unit; confirm meaning against business rules. |
| `sensors.measurement_unit` | `name` | `VARCHAR(80)` | NOT NULL | Element name. |
| `sensors.measurement_unit` | `created_at` | `TIMESTAMPTZ` | NOT NULL, DEFAULT now() | Creation timestamp. |
| `sensors.outbox_event` | `event_id` | `UUID` | PK, NOT NULL | Field of outbox_event; confirm meaning against business rules. |
| `sensors.outbox_event` | `event_type` | `VARCHAR(80)` | NOT NULL | Field of outbox_event; confirm meaning against business rules. |
| `sensors.outbox_event` | `aggregate_type` | `VARCHAR(60)` | NOT NULL | Field of outbox_event; confirm meaning against business rules. |
| `sensors.outbox_event` | `aggregate_id` | `VARCHAR(60)` | NOT NULL | Field of outbox_event; confirm meaning against business rules. |
| `sensors.outbox_event` | `routing_key` | `VARCHAR(80)` | NOT NULL | Field of outbox_event; confirm meaning against business rules. |
| `sensors.outbox_event` | `payload` | `TEXT` | NOT NULL | Field of outbox_event; confirm meaning against business rules. |
| `sensors.outbox_event` | `occurred_at` | `TIMESTAMPTZ` | NOT NULL | Field of outbox_event; confirm meaning against business rules. |
| `sensors.outbox_event` | `published_at` | `TIMESTAMPTZ` | — | Field of outbox_event; confirm meaning against business rules. |
| `sensors.outbox_event` | `attempts` | `INTEGER` | NOT NULL, DEFAULT 0 | Field of outbox_event; confirm meaning against business rules. |
| `sensors.outbox_event` | `last_error` | `TEXT` | — | Field of outbox_event; confirm meaning against business rules. |
| `sensors.sensor` | `sensor_id` | `UUID` | PK, NOT NULL, DEFAULT gen_random_uuid() | Reference to the sensor. |
| `sensors.sensor` | `serial_number` | `VARCHAR(60)` | NOT NULL, UNIQUE | Device serial number. |
| `sensors.sensor` | `sensor_model_id` | `UUID` | NOT NULL | Reference to the sensor model. |
| `sensors.sensor` | `sensor_status_id` | `UUID` | NOT NULL | Reference to the sensor status. |
| `sensors.sensor` | `last_seen_at` | `TIMESTAMPTZ` | — | Field of sensor; confirm meaning against business rules. |
| `sensors.sensor` | `created_at` | `TIMESTAMPTZ` | NOT NULL, DEFAULT now() | Creation timestamp. |
| `sensors.sensor` | `updated_at` | `TIMESTAMPTZ` | — | Last update timestamp. |
| `sensors.sensor_installation` | `sensor_installation_id` | `UUID` | PK, NOT NULL, DEFAULT gen_random_uuid() | Field of sensor_installation; confirm meaning against business rules. |
| `sensors.sensor_installation` | `sensor_id` | `UUID` | NOT NULL | Reference to the sensor. |
| `sensors.sensor_installation` | `educational_environment_id` | `UUID` | NOT NULL | Field of sensor_installation; confirm meaning against business rules. |
| `sensors.sensor_installation` | `installed_at` | `TIMESTAMPTZ` | NOT NULL | Installation timestamp. |
| `sensors.sensor_installation` | `removed_at` | `TIMESTAMPTZ` | — | Field of sensor_installation; confirm meaning against business rules. |
| `sensors.sensor_model` | `sensor_model_id` | `UUID` | PK, NOT NULL, DEFAULT gen_random_uuid() | Reference to the sensor model. |
| `sensors.sensor_model` | `code` | `VARCHAR(30)` | NOT NULL, UNIQUE | Field of sensor_model; confirm meaning against business rules. |
| `sensors.sensor_model` | `name` | `VARCHAR(80)` | NOT NULL | Element name. |
| `sensors.sensor_model` | `description` | `VARCHAR(255)` | — | Element description. |
| `sensors.sensor_model` | `created_at` | `TIMESTAMPTZ` | NOT NULL, DEFAULT now() | Creation timestamp. |
| `sensors.sensor_status` | `sensor_status_id` | `UUID` | PK, NOT NULL, DEFAULT gen_random_uuid() | Reference to the sensor status. |
| `sensors.sensor_status` | `code` | `VARCHAR(30)` | NOT NULL, UNIQUE | Field of sensor_status; confirm meaning against business rules. |
| `sensors.sensor_status` | `name` | `VARCHAR(80)` | NOT NULL | Element name. |
| `sensors.sensor_status` | `created_at` | `TIMESTAMPTZ` | NOT NULL, DEFAULT now() | Creation timestamp. |
| `sensors.sensor_variable` | `sensor_id` | `UUID` | NOT NULL | Reference to the sensor. |
| `sensors.sensor_variable` | `variable_id` | `UUID` | NOT NULL | Reference to the environmental variable. |
| `sensors.variable` | `variable_id` | `UUID` | PK, NOT NULL, DEFAULT gen_random_uuid() | Reference to the environmental variable. |
| `sensors.variable` | `code` | `VARCHAR(30)` | NOT NULL, UNIQUE | Field of variable; confirm meaning against business rules. |
| `sensors.variable` | `name` | `VARCHAR(80)` | NOT NULL | Element name. |
| `sensors.variable` | `measurement_unit_id` | `UUID` | NOT NULL | Reference to the measurement unit. |
| `sensors.variable` | `description` | `VARCHAR(255)` | — | Element description. |
| `sensors.variable` | `created_at` | `TIMESTAMPTZ` | NOT NULL, DEFAULT now() | Creation timestamp. |
| `user_experience.classroom_ratings` | `rating_id` | `UUID PRIMARY` | — | Field of classroom_ratings; confirm meaning against business rules. |
| `user_experience.classroom_ratings` | `user_id` | `UUID NOT` | — | Logical reference to the user. |
| `user_experience.classroom_ratings` | `classroom_id` | `UUID NOT` | — | Field of classroom_ratings; confirm meaning against business rules. |
| `user_experience.classroom_ratings` | `score` | `INTEGER NOT` | — | Field of classroom_ratings; confirm meaning against business rules. |
| `user_experience.classroom_ratings` | `comment` | `VARCHAR(1000)` | — | Field of classroom_ratings; confirm meaning against business rules. |
| `user_experience.classroom_ratings` | `rated_at` | `TIMESTAMPTZ NOT` | — | Field of classroom_ratings; confirm meaning against business rules. |
| `user_experience.favorites` | `favorite_id` | `UUID PRIMARY` | — | Field of favorites; confirm meaning against business rules. |
| `user_experience.favorites` | `user_id` | `UUID NOT` | — | Logical reference to the user. |
| `user_experience.favorites` | `classroom_id` | `UUID` | — | Field of favorites; confirm meaning against business rules. |
| `user_experience.favorites` | `variable_id` | `UUID` | — | Reference to the environmental variable. |
| `user_experience.favorites` | `added_at` | `TIMESTAMPTZ NOT` | — | Field of favorites; confirm meaning against business rules. |
| `user_experience.favorites` | `OR` | `VARIABLE` | NOT NULL | Field of favorites; confirm meaning against business rules. |
| `user_experience.notification_state` | `user_id` | `UUID NOT` | — | Logical reference to the user. |
| `user_experience.notification_state` | `alert_id` | `UUID NOT` | — | Field of notification_state; confirm meaning against business rules. |
| `user_experience.notification_state` | `read_at` | `TIMESTAMPTZ NOT` | — | Field of notification_state; confirm meaning against business rules. |
| `user_experience.searches` | `search_id` | `UUID PRIMARY` | — | Field of searches; confirm meaning against business rules. |
| `user_experience.searches` | `user_id` | `UUID NOT` | — | Logical reference to the user. |
| `user_experience.searches` | `search_text` | `VARCHAR(500)` | — | Field of searches; confirm meaning against business rules. |
| `user_experience.searches` | `applied_filter` | `VARCHAR(500)` | — | Field of searches; confirm meaning against business rules. |
| `user_experience.searches` | `searched_at` | `TIMESTAMPTZ NOT` | — | Field of searches; confirm meaning against business rules. |
| `user_experience.user_preferences` | `preference_id` | `UUID PRIMARY` | — | Field of user_preferences; confirm meaning against business rules. |
| `user_experience.user_preferences` | `user_id` | `UUID NOT` | UNIQUE | Logical reference to the user. |
| `user_experience.user_preferences` | `language` | `VARCHAR(10)` | — | Field of user_preferences; confirm meaning against business rules. |
| `user_experience.user_preferences` | `color_theme` | `VARCHAR(20)` | — | Field of user_preferences; confirm meaning against business rules. |
| `user_experience.user_preferences` | `notifications_enabled` | `BOOLEAN NOT` | — | Field of user_preferences; confirm meaning against business rules. |
| `user_experience.user_preferences` | `time_zone` | `VARCHAR(100)` | — | Field of user_preferences; confirm meaning against business rules. |
| `user_experience.user_preferences` | `date_format` | `VARCHAR(20)` | — | Field of user_preferences; confirm meaning against business rules. |
| `user_experience.user_preferences` | `reminders` | `JSONB NOT` | — | Field of user_preferences; confirm meaning against business rules. |
| `user_experience.user_preferences` | `dark_mode` | `BOOLEAN NOT` | — | Field of user_preferences; confirm meaning against business rules. |
| `user_experience.user_preferences` | `auto_time_zone` | `BOOLEAN NOT` | — | Field of user_preferences; confirm meaning against business rules. |
| `user_management.user_profiles` | `profile_id` | `UUID` | PK, NOT NULL, DEFAULT gen_random_uuid() | Field of user_profiles; confirm meaning against business rules. |
| `user_management.user_profiles` | `user_id` | `UUID` | NOT NULL | Logical reference to the user. |
| `user_management.user_profiles` | `full_name` | `VARCHAR(150)` | NOT NULL | Field of user_profiles; confirm meaning against business rules. |
| `user_management.user_profiles` | `phone` | `VARCHAR(30)` | — | Field of user_profiles; confirm meaning against business rules. |
| `user_management.user_profiles` | `department` | `VARCHAR(100)` | — | Field of user_profiles; confirm meaning against business rules. |
| `user_management.user_profiles` | `position` | `VARCHAR(100)` | — | Field of user_profiles; confirm meaning against business rules. |
| `user_management.user_profiles` | `locale` | `VARCHAR(10)` | — | Field of user_profiles; confirm meaning against business rules. |
| `user_management.user_profiles` | `status` | `VARCHAR(20)` | NOT NULL | Element status. |
| `user_management.user_profiles` | `created_at` | `TIMESTAMPTZ` | NOT NULL | Creation timestamp. |
| `user_management.user_profiles` | `updated_at` | `TIMESTAMPTZ` | NOT NULL | Last update timestamp. |
| `user_management.user_profiles` | `deleted_at` | `TIMESTAMPTZ` | — | Field of user_profiles; confirm meaning against business rules. |
