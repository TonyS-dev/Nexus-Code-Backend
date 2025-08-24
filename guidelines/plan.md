### **El Plan de Batalla: Plataforma de Gestión de Personal "CodeUp HR"**

Este plan divide el proyecto en roles claros y un cronograma de 3 semanas de desarrollo (Sprints), asegurando que cada miembro del equipo tenga una carga de trabajo balanceada y responsabilidades definidas.

#### **Paso 1: Definir los Roles**

En un equipo de 5, es crucial definir roles con responsabilidades primarias para operar de manera profesional y cumplir con los requisitos de SCRUM. Aunque todos los miembros son desarrolladores full-stack, cada rol es el "dueño" de un área para garantizar la calidad y coherencia del proyecto.

*   **Rol 1: Scrum Master / Project Manager (Alvaro) + Backend Support**
    *   **Responsabilidades:** Es el facilitador del equipo, responsable de que el proceso ágil funcione sin problemas.
    *   **Tareas Clave:** Organizar y dirigir las reuniones (Daily Standups, Sprint Planning, Retrospectivas). Mantener el board de Azure DevOps actualizado. Identificar y ayudar a eliminar cualquier bloqueo que afecte al equipo. Es el guardián del proceso.

*   **Rol 2: Product Owner / Analista de Negocio (Roberto) + Frontend Support**
    *   **Responsabilidades:** Actúa como la "voz del cliente", asegurando que el producto final cumpla con la visión y los requisitos.
    *   **Tareas Clave:** Redactar y detallar las Historias de Usuario. Priorizar el Product Backlog. Tomar decisiones sobre el alcance y las funcionalidades del producto. Es responsable principal de la documentación técnica.

*   **Rol 3: Backend Lead / Arquitecto de Datos (Luis)**
    *   **Responsabilidades:** Es el dueño de la API y la base de datos. Garantiza que el backend sea sólido, seguro y escalable.
    *   **Tareas Clave:** Diseñar el Modelo Entidad-Relación (ERD) final. Escribir el script SQL (DDL). Definir la arquitectura de la API (Controllers, Services, Routes). Implementar el núcleo de la lógica de negocio y las consultas complejas.

*   **Rol 4: Frontend Lead / Diseñador UI/UX (Sebastian)**
    *   **Responsabilidades:** Es el dueño de la experiencia del usuario. Garantiza que la aplicación sea intuitiva, funcional y visualmente atractiva.
    *   **Tareas Clave:** Crear los prototipos y wireframes en Figma o herramientas similares. Definir la estructura de componentes del frontend (`api.js`, `ui.js`). Implementar las vistas principales y asegurar que el diseño sea responsivo.

*   **Rol 5: DevOps Lead / Especialista en QA (Antonio) + Backend & Frontend Support**
    *   **Responsabilidades:** Es responsable de la integración, despliegue y calidad del proyecto. Actúa como el puente entre el desarrollo y la producción.
    *   **Tareas Clave:** Configurar y mantener el repositorio en GitHub (ramas, reglas de merge). Escribir los scripts de carga masiva (seeder). Gestionar el despliegue a Netlify/Vercel. Liderar las pruebas manuales End-to-End (E2E) y reportar bugs.

---

#### **Paso 2: Dividir el Proyecto en Sprints (El Cronograma)**

Esta es la división del trabajo a lo largo de las 3 semanas de desarrollo, diseñada para entregar valor de forma incremental.

##### **Semana 1 / Sprint 1: Fundación y MVP Mínimo (Autenticación y Vacaciones)**
**Objetivo:** Tener un sistema donde un usuario pueda iniciar sesión por rol y ver una página funcional de "Solicitar Vacaciones". La base técnica y de gestión del proyecto debe estar completamente construida.

*   **Scrum Master:** Configurar el proyecto en Azure DevOps (Backlog, Sprints, Board). Crear y configurar el repositorio en GitHub. Dirigir la reunión de Kickoff y las Dailies.
*   **Product Owner:** Escribir y detallar todas las Historias de Usuario para el **Módulo de Vacaciones** y el **flujo de Autenticación por roles**. Priorizar el Product Backlog inicial. Iniciar la redacción del Documento Técnico.
*   **Backend Lead:** Diseñar el ERD completo. Escribir el script `database.sql` para las tablas de **Usuarios**, **Roles** y **Solicitudes de Vacaciones**. Implementar el servicio y controlador para el **registro de usuarios y login** (con roles) y el **CRUD completo para el Módulo de Vacaciones**.
*   **Frontend Lead:** Crear el prototipo en Figma para la **página de Login**, el **Dashboard principal** y el **formulario de Vacaciones**. Implementar la estructura del proyecto con Vite y Bootstrap. Construir la página de Login y el layout principal (navbar, sidebar) que se muestra a los usuarios autenticados.
*   **DevOps/QA Lead:** Escribir el script **Seeder** para poblar las tablas de Roles y crear usuarios de prueba para cada rol (Admin, Líder, Empleado). Realizar las primeras pruebas manuales del flujo de login y solicitud de vacaciones.

##### **Semana 2 / Sprint 2: Expansión de Funcionalidades (Permisos y Certificados)**
**Objetivo:** Expandir el sistema para que los usuarios puedan solicitar permisos y certificados. La funcionalidad principal de la aplicación debe estar casi completa al final de la semana.

*   **Scrum Master:** Dirigir la Sprint Planning para la Semana 2. Asegurarse de que los bloqueos de la semana 1 estén resueltos y facilitar la comunicación entre los leads de backend y frontend.
*   **Product Owner:** Detallar las Historias de Usuario para los **Módulos de Permisos y Certificados**. Actualizar el Documento Técnico con los nuevos diagramas y funcionalidades.
*   **Backend Lead:** Escribir el script SQL para las tablas de **Permisos/Licencias** y **Solicitudes de Certificados**. Implementar el **CRUD completo** para ambos módulos en el backend (Service, Controller, Route).
*   **Frontend Lead:** Implementar las vistas y formularios para **solicitar Permisos** y **solicitar Certificados**. Construir la vista de "Mi Historial" donde un empleado puede ver un consolidado de todas sus solicitudes.
*   **DevOps/QA Lead:** Ampliar el Seeder con datos de prueba para permisos y certificados. Investigar y documentar el proceso de despliegue (variables de entorno en Netlify/Vercel). Realizar pruebas E2E del flujo completo de solicitudes.

##### **Semana 3 / Sprint 3: Paneles de Gestión, Pruebas y Despliegue**
**Objetivo:** Finalizar la aplicación, incluyendo los paneles para roles de gestión (Líderes, Talento Humano), y tener el proyecto completamente desplegado, probado y documentado. **No se añaden nuevas funcionalidades grandes esta semana.**

*   **Scrum Master:** Enfocarse en que el equipo esté alineado para la entrega final. Revisar el progreso de todos los entregables obligatorios (código, documentos, etc.).
*   **Product Owner:** Terminar y formatear el Documento Técnico final. Preparar la estructura de la presentación final y el elevator pitch.
*   **Backend Lead:** Implementar las **consultas avanzadas** para el panel de Talento Humano (filtros, reportes, etc.). Crear los endpoints correspondientes para consumir estos datos. Refactorizar y añadir comentarios al código del backend.
*   **Frontend Lead:** Construir las vistas del **Panel de Talento Humano y Líderes**, consumiendo los endpoints de reportes. Realizar el pulido final de la UI/UX (estilos, responsividad, feedback visual).
*   **DevOps/QA Lead:** **Realizar el despliegue final** del frontend en Netlify/Vercel (y del backend si se requiere). Configurar las variables de entorno en producción. Liderar la sesión final de pruebas E2E con el checklist completo. Finalizar la colección de Postman y el README.md.