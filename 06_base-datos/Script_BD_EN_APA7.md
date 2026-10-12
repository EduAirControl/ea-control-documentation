# 06. Database — EduAirControl

**María de los Ángeles Olaya García; Jhon Jairo Cortez Vargas**

Servicio Nacional de Aprendizaje (SENA), Programa ADSO-3145556

Instructora: Karol Daniela Correa

12 de octubre de 2026

---

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
## Consolidated SQL script

`Script_BD.sql` combines canonical SQL scripts found in the project and generates reference DDL for tables declared in Liquibase YAML migrations. It may not reproduce every changeSet detail (for example, sequences, indexes, seed data, or special types). For installation and upgrades, run the original per-microservice migrations.

### Recommended procedure
1. Review each service's PostgreSQL configuration.
2. Back up data before changing an existing database.
3. Run Liquibase migrations in the order configured by each `db.changelog-master.yaml`.
4. Test any consolidated script against an empty non-production database.
5. Verify tables, indexes, constraints, and seed data after execution.
