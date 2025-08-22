# Proyecto "CodeUp HR": Arquitectura y Guía de Estilo

## 1. Filosofía del Proyecto

¡Bienvenidos al equipo! Este documento es nuestra única fuente de verdad para todos los estándares técnicos del proyecto. Nuestro objetivo es construir una aplicación full-stack de alta calidad, mantenible y profesional.

Para lograrlo, nos adheriremos a un principio fundamental: la **Separación de Responsabilidades (Separation of Concerns)**. Cada pieza de nuestra aplicación tendrá una única responsabilidad bien definida. Esto hará que nuestro código sea más fácil de escribir, depurar, probar y escalar.

## 2. Arquitectura General: Aplicaciones Desacopladas

Nuestro proyecto consiste en dos aplicaciones completamente independientes que se comunican a través de una API RESTful:

1.  **Backend:** Una aplicación en Node.js/Express responsable de toda la lógica de negocio, interacciones con la base de datos y validación de datos. No sabe nada sobre la interfaz de usuario.
2.  **Frontend:** Una Aplicación de Página Única (SPA) en JavaScript puro, construida con Vite. Es responsable de toda la renderización de la interfaz de usuario y la interacción con el usuario. No sabe nada de la base de datos; solo sabe cómo hablar con la API.

Este enfoque desacoplado nos permite desarrollar, probar y desplegar ambas partes del proyecto de forma independiente.

## 3. Estructura de Archivos del Proyecto

Usaremos una estructura de monorepo con dos directorios principales en la raíz. Todos los nombres de archivos y carpetas **deben estar en `kebab-case`** (por ejemplo, `customers.routes.js`).

```
codeup-hr-project/
├── backend/
│   ├── data/             # Archivos CSV para el seeder
│   ├── middleware/       # Manejador de errores global, middleware de autenticación, etc.
│   ├── models/           # Conexión a la base de datos (ej. db_connection.js)
│   ├── routes/           # Rutas de la API (ej. customers.routes.js)
│   ├── seeders/          # Scripts para poblar la base de datos
│   ├── services/         # Lógica de negocio y de base de datos
│   ├── controllers/      # Manejo de peticiones/respuestas HTTP
│   ├── .env              # Variables de entorno locales (NO SUBIR A GIT)
│   ├── .env.example      # Plantilla para las variables de entorno (SUBIR A GIT)
│   ├── database.sql      # Script DDL para la creación de la base de datos
│   ├── package.json
│   └── server.js         # Punto de entrada del servidor Express
│
├── frontend/
│   ├── public/           # Archivos estáticos (imágenes, iconos)
│   ├── src/
│   │   ├── css/          # Archivos CSS personalizados
│   │   └── js/
│   │       ├── api.js    # Toda la lógica de comunicación con la API
│   │       ├── ui.js     # Manipulación del DOM y renderizado
│   │       └── app.js    # Orquestador principal de la aplicación
│   ├── index.html
│   └── package.json
│
└── docs/                 # Toda la documentación del proyecto (ERD, documentos técnicos)
```

## 4. Arquitectura del Backend: El Modelo de 3 Capas

Nuestro backend sigue una estricta arquitectura de 3 capas (o *tiers*). Cada petición viaja a través de estas capas, y cada una tiene un trabajo específico.

#### a. Rutas (`/routes`)
-   **Reglas:**
    -   Mapea las rutas URL (ej. `/customers/:id`) a funciones específicas del controlador.
    -   **NO CONTIENE lógica de negocio.** Su único trabajo es enrutar.
    -   Los nombres de archivo deben corresponder al recurso (ej. `customers.routes.js`).

#### b. Controladores (`/controllers`)
-   **Reglas:**
    -   Maneja los objetos `req` (petición) y `res` (respuesta).
    -   Extrae datos de la petición (`req.params`, `req.body`).
    -   Realiza validaciones iniciales (ej. comprobar campos obligatorios).
    -   Llama a la función del servicio apropiada para hacer el trabajo real.
    -   Formatea la respuesta HTTP final (ej. `res.status(200).json(...)`).
    -   **NO DEBE** contener ninguna consulta directa a la base de datos (`pool.query`).

#### c. Servicios (`/services`)
-   **Reglas:**
    -   Contiene **TODA la lógica de negocio y las consultas a la base de datos**.
    -   Es llamado por los controladores.
    -   Devuelve datos puros (objetos o arrays de JavaScript), no respuestas HTTP.
    -   **NO DEBE** saber nada sobre los objetos `req` o `res`.

Esta estricta separación garantiza que nuestra lógica sea reutilizable y fácil de probar.

## 5. Arquitectura del Frontend: La APP Modular

Nuestro frontend también sigue un patrón modular para mantener el código organizado y limpio.

#### a. `api.js`
-   **Responsabilidad:** El "Especialista en Comunicaciones".
-   **Reglas:**
    -   Contiene **TODAS las llamadas `fetch`** a nuestro backend.
    -   Debe tener una función central `apiRequest` para manejar la lógica común (URL base, cabeceras, manejo de errores).
    -   Exporta una función para cada endpoint de la API (ej. `fetchAllCustomers`).
    -   **NO DEBE** manipular el DOM.

#### b. `ui.js`
-   **Responsabilidad:** La "Capa de Presentación".
-   **Reglas:**
    -   Contiene todas las funciones que manipulan directamente el DOM (ej. `document.getElementById`, `.innerHTML`).
    -   Exporta funciones que reciben datos como argumentos y los renderizan como HTML (ej. `renderCustomersTable(customers)`).
    -   **NO DEBE** hacer llamadas a la API. Solo sabe cómo mostrar los datos que se le entregan.

#### c. `app.js`
-   **Responsabilidad:** El "Director de Orquesta".
-   **Reglas:**
    -   Es el punto de entrada principal para la lógica de la aplicación.
    -   Importa funciones de `api.js` y `ui.js`.
    -   Contiene todos los `event listeners` (para clics de botones, envíos de formularios, etc.).
    -   **Flujo de trabajo:** Ocurre un evento -> `app.js` llama a `api.js` para obtener datos -> `app.js` le da esos datos a `ui.js` para que los muestre.

## 6. Guía de Estilo y Flujo de Trabajo con Git

Para garantizar la consistencia y la calidad, todos los miembros del equipo **deben** seguir estas pautas.

#### a. Reglas Generales
-   **Idioma:** Todo el código, comentarios y documentación **deben estar en Inglés**.
-   **Convenciones de Nomenclatura:**
    -   Archivos:  (ej. `customer.service.js, customers.controller.js, customers.route.js `).
    -   Folders: minuscula y `snake_case`  (ej. `node_modules`)
    -   Funciones y Variables en JavaScript: `camelCase` (ej. `fetchAllCustomers`).
    -   Clases de CSS: `kebab-case` (ej. `.customer-table`).
-   **Estilo de JavaScript:**
    -   Usar `async/await` para todas las operaciones asíncronas.
    -   Usar siempre `const` por defecto; usar `let` solo cuando una variable necesite ser reasignada.
    -   Usar Módulos de ES6 (`import`/`export`) exclusivamente.

#### b. Flujo de Trabajo con Git

1.  **Rama `main`:** Es la rama de producción. Contiene únicamente el código desplegado y estable. **Los commits directos a `main` están prohibidos.**
2.  **Rama `develop`:** Es nuestra rama principal de integración. Todas las funcionalidades terminadas se fusionan aquí. Sirve como base para los despliegues a un entorno de pruebas.
3.  **Ramas de Desarrollo Individuales:**
    -   Cada desarrollador trabajará en su propia rama de larga duración, creada a partir de `develop`.
    -   **Nomenclatura:** `[nombre-del-desarrollador]-dev` (ej. `antonio-dev`, `juan-dev`).
4.  **Pull Requests (PRs):**
    -   Cuando una funcionalidad está terminada, el desarrollador crea un **Pull Request** desde su rama `antonio-dev` hacia la rama `merge-development`. 
    -   **El DevOps/QA Lead es el responsable de revisar y autorizar** estos PRs hacia `merge-development`, asegurando que el código cumple con los estándares y no rompe la integración.
5.  **Mensajes de Commit:** Usaremos el estándar [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/) para mantener un historial limpio y profesional.
    -   `feat:` (una nueva funcionalidad)
    -   `fix:` (una corrección de bug)
    -   `docs:` (cambios en la documentación)
    -   `style:` (formateo de código)
    -   `refactor:` (cambios en el código que no arreglan un bug ni añaden una funcionalidad)
    -   **Ejemplo:** `feat: implement GET /customers/:id endpoint`