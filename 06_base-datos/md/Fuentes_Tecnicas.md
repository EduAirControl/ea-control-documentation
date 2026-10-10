# Fuentes técnicas revisadas / Technical sources reviewed

## ea-control-ms-security
- `changes/000-create-schema.yaml`
- `changes/001-create-users.yaml`
- `changes/002-create-roles.yaml`
- `changes/003-create-user-roles.yaml`
- `changes/004-create-refresh-tokens.yaml`
- `changes/005-add-foreign-keys.yaml`
- `changes/006-create-indexes.yaml`
- `changes/007-create-institution.yaml`
- `changes/008-add-user-institution.yaml`
- `changes/009-create-oauth2-registered-client.yaml`
- `changes/010-create-oauth2-authorization.yaml`
- `changes/011-create-oauth2-authorization-consent.yaml`
- `changes/012-create-password-reset-tokens.yaml`
- `changes/013-create-user-identity.yaml`
- `db.changelog-master.yaml`

## ea-control-ms-user-management
- `changes/000-create-schema.yaml`
- `changes/001-create-user-profiles.yaml`
- `changes/002-add-user-profiles-constraints.yaml`
- `changes/003-add-profile-institution.yaml`
- `changes/004-add-profile-avatar-url.yaml`
- `db.changelog-master.yaml`

## ea-control-ms-classroom-management
- `changes/000-create-schema.yaml`
- `changes/001-create-campuses.yaml`
- `changes/002-create-environment-types.yaml`
- `changes/003-create-educational-environments.yaml`
- `changes/004-add-environment-constraints.yaml`
- `changes/005-create-indexes.yaml`
- `changes/006-add-campus-institution.yaml`
- `changes/007-add-environment-institution.yaml`
- `changes/008-create-outbox-event.yaml`
- `changes/009-seed-bootstrap.yaml`
- `db.changelog-master.yaml`

## ea-control-ms-sensor-management
- `changes/000-create-schema.yaml`
- `changes/001-create-sensor.yaml`
- `changes/002-create-sensor-installation.yaml`
- `changes/003-create-variable.yaml`
- `changes/004-create-sensor-variable.yaml`
- `changes/005-add-foreign-keys.yaml`
- `changes/006-create-indexes.yaml`
- `changes/007-add-sensor-institution.yaml`
- `changes/008-create-outbox-event.yaml`
- `changes/009-create-sensor-catalog.yaml`
- `changes/010-seed-variables.yaml`
- `changes/011-add-full-sensor-model.yaml`
- `db.changelog-master.yaml`

## ms-environment-monitoring
- `canonical/01_schemas/001_schemas.sql`
- `canonical/03_tables/01_catalogos/001_variable.sql`
- `canonical/03_tables/01_catalogos/002_educational_environment.sql`
- `canonical/03_tables/01_catalogos/003_variable_threshold.sql`
- `canonical/03_tables/01_catalogos/004_severity.sql`
- `canonical/03_tables/01_catalogos/005_quality_flag.sql`
- `canonical/03_tables/02_read_model/001_environment_measurement.sql`
- `canonical/03_tables/02_read_model/002_inbox_message.sql`
- `canonical/03_tables/03_analisis/001_analysis_statuses.sql`
- `canonical/03_tables/03_analisis/002_environmental_analysis.sql`
- `canonical/03_tables/03_analisis/003_analysis_result.sql`
- `canonical/03_tables/04_alertas/001_environment_alert.sql`
- `canonical/03_tables/05_proyeccion/001_installation_projection.sql`
- `canonical/10_indexes/001_indexes.sql`
- `changes/010-seed-reference.yaml`
- `db.changelog-master.yaml`

## -ms-user-experience
- `canonical/01_schemas/001_schemas.sql`
- `canonical/03_tables/01_preferences/001_user_preferences.sql`
- `canonical/03_tables/02_favorites/001_favorites.sql`
- `canonical/03_tables/03_ratings/001_classroom_ratings.sql`
- `canonical/03_tables/04_searches/001_searches.sql`
- `canonical/03_tables/05_notifications/001_notification_state.sql`
- `canonical/10_indexes/001_indexes.sql`
- `db.changelog-master.yaml`

