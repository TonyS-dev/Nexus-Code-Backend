# Project "CodeUp HR": Architecture and Style Guide

## 1. Project Philosophy

Welcome to the team! This document is our single source of truth for all technical standards of the project. Our goal is to build a high-quality, maintainable, and professional full-stack application.

To achieve this, we adhere to a fundamental principle: **Separation of Concerns**. Every part of our application will have a single, well-defined responsibility. This makes our code easier to write, debug, test, and scale.

## 2. General Architecture: Decoupled Applications

Our project consists of two completely independent applications that communicate via a RESTful API:

1.  **Backend:** A Node.js/Express application responsible for all business logic, database interactions, and data validation. It knows nothing about the user interface.
2.  **Frontend:** A Single Page Application (SPA) built with pure JavaScript and Vite. It handles all UI rendering and user interaction. It knows nothing about the database; it only communicates with the API.

This decoupled approach allows us to develop, test, and deploy both parts of the project independently.

## 3. Project File Structure

We use a monorepo structure with two main directories at the root. All file and folder names **must use `kebab-case`** (e.g., `customers.routes.js`).

```
codeup-hr-project/
├── backend/
│   ├── data/             # CSV files for the seeder
│   ├── middleware/       # Global error handler, authentication middleware, etc.
│   ├── models/           # Database connection (e.g., db_connection.js)
│   ├── routes/           # API routes (e.g., customers.routes.js)
│   ├── seeders/          # Scripts to populate the database
│   ├── services/         # Business and database logic
│   ├── controllers/      # HTTP request/response handling
│   ├── .env              # Local environment variables (DO NOT COMMIT TO GIT)
│   ├── .env.example      # Template for environment variables (COMMIT TO GIT)
│   ├── database.sql      # DDL script for database creation
│   ├── package.json
│   └── server.js         # Express server entry point
│
├── frontend/
│   ├── public/           # Static files (images, icons)
│   ├── src/
│   │   ├── css/          # Custom CSS files
│   │   └── js/
│   │       ├── api.js    # All API communication logic
│   │       ├── ui.js     # DOM manipulation and rendering
│   │       └── app.js    # Main application orchestrator
│   ├── index.html
│   └── package.json
│
└── docs/                 # All project documentation (ERD, technical docs)
```

## 4. Backend Architecture: The 3-Layer Model

Our backend follows a strict 3-layer architecture. Each request travels through these layers, each with a specific job.

#### a. Routes (`/routes`)
-   **Rules:**
    -   Maps URL routes (e.g., `/customers/:id`) to specific controller functions.
    -   **DOES NOT contain business logic.** Its only job is routing.
    -   File names must match the resource (e.g., `customers.routes.js`).

#### b. Controllers (`/controllers`)
-   **Rules:**
    -   Handles `req` (request) and `res` (response) objects.
    -   Extracts data from the request (`req.params`, `req.body`).
    -   Performs initial validations (e.g., required fields).
    -   Calls the appropriate service function to do the real work.
    -   Formats the final HTTP response (e.g., `res.status(200).json(...)`).
    -   **MUST NOT** contain any direct database queries (`pool.query`).

#### c. Services (`/services`)
-   **Rules:**
    -   Contains **ALL business logic and database queries**.
    -   Called by controllers.
    -   Returns pure data (JavaScript objects or arrays), not HTTP responses.
    -   **MUST NOT** know anything about `req` or `res` objects.

This strict separation ensures our logic is reusable and easy to test.

## 5. Frontend Architecture: The Modular APP

Our frontend also follows a modular pattern to keep code organized and clean.

#### a. `api.js`
-   **Responsibility:** The "Communications Specialist".
-   **Rules:**
    -   Contains **ALL `fetch` calls** to our backend.
    -   Should have a central `apiRequest` function for common logic (base URL, headers, error handling).
    -   Exports a function for each API endpoint (e.g., `fetchAllCustomers`).
    -   **MUST NOT** manipulate the DOM.

#### b. `ui.js`
-   **Responsibility:** The "Presentation Layer".
-   **Rules:**
    -   Contains all functions that directly manipulate the DOM (e.g., `document.getElementById`, `.innerHTML`).
    -   Exports functions that receive data as arguments and render it as HTML (e.g., `renderCustomersTable(customers)`).
    -   **MUST NOT** make API calls. Only knows how to display the data it receives.

#### c. `app.js`
-   **Responsibility:** The "Orchestra Conductor".
-   **Rules:**
    -   Main entry point for application logic.
    -   Imports functions from `api.js` and `ui.js`.
    -   Contains all event listeners (button clicks, form submissions, etc.).
    -   **Workflow:** An event occurs -> `app.js` calls `api.js` to get data -> `app.js` passes that data to `ui.js` to display.

## 6. Style Guide and Git Workflow

To ensure consistency and quality, all team members **must** follow these guidelines.

#### a. General Rules
-   **Language:** All code, comments, and documentation **must be in English**.
-   **Naming Conventions:**
    -   Files: (e.g., `customer.service.js, customers.controller.js, customers.route.js`).
    -   Folders: lowercase and `snake_case` (e.g., `node_modules`)
    -   JavaScript Functions and Variables: `camelCase` (e.g., `fetchAllCustomers`).
    -   CSS Classes: `kebab-case` (e.g., `.customer-table`).
-   **JavaScript Style:**
    -   Use `async/await` for all asynchronous operations.
    -   Always use `const` by default; use `let` only when a variable needs to be reassigned.
    -   Use ES6 Modules (`import`/`export`) exclusively.

#### b. Git Workflow

1.  **`main` branch:** Production branch. Contains only deployed and stable code. **Direct commits to `main` are prohibited.**
2.  **`develop` branch:** Main integration branch. All finished features are merged here. Used as the base for test deployments.
3.  **Individual Development Branches:**
    -   Each developer works on their own long-lived branch, created from `develop`.
    -   **Naming:** `[developer-name]-dev` (e.g., `antonio-dev`, `juan-dev`).
4.  **Pull Requests (PRs):**
    -   When a feature is finished, the developer creates a **Pull Request** from their branch (e.g., `antonio-dev`) to the `merge-development` branch.
    -   **The DevOps/QA Lead is responsible for reviewing and approving** these PRs to `merge-development`, ensuring code meets standards and does not break integration.
5.  **Commit Messages:** We use the [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/) standard for a clean and professional history.
    -   `feat:` (a new feature)
    -   `fix:` (a bug fix)
    -   `docs:` (documentation changes)
    -   `style:` (code formatting)
    -   `refactor:` (code changes that neither fix a bug nor add a feature)
    -   **Example:** `feat: implement GET /customers/:id endpoint`