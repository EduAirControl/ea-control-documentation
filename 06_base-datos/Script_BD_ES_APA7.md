# 06. Base de Datos — EduAirControl

**María de los Ángeles Olaya García; Jhon Jairo Cortez Vargas**

Servicio Nacional de Aprendizaje (SENA), Programa ADSO-3145556

Instructora: Karol Daniela Correa

12 de octubre de 2026

---

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
## Script SQL consolidado

El archivo `Script_BD.sql` reúne los scripts SQL canónicos encontrados y genera una referencia DDL para las tablas declaradas en las migraciones Liquibase YAML. Puede no reproducir cada detalle de los changeSets (por ejemplo, secuencias, índices, datos iniciales o tipos especiales). Para instalaciones y actualizaciones, ejecutar las migraciones originales por microservicio.

### Procedimiento recomendado
1. Revisar la configuración de PostgreSQL de cada servicio.
2. Hacer copia de seguridad antes de modificar una base existente.
3. Ejecutar las migraciones Liquibase en el orden configurado por cada `db.changelog-master.yaml`.
4. Probar cualquier script consolidado en una base vacía no productiva.
5. Verificar tablas, índices, restricciones y datos iniciales tras la ejecución.
