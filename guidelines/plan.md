### **Battle Plan: Personnel Management Platform "CodeUp HR"**

This plan divides the project into clear roles and a 3-week development timeline (Sprints), ensuring each team member has a balanced workload and defined responsibilities.

#### **Step 1: Define the Roles**

In a team of 5, it is crucial to define roles with primary responsibilities to operate professionally and meet SCRUM requirements. Although all members are full-stack developers, each role is the "owner" of an area to guarantee project quality and consistency.

*   **Role 1: Scrum Master / Project Manager (Alvaro) + Backend Support**
    *   **Responsibilities:** Facilitates the team, ensuring the agile process runs smoothly.
    *   **Key Tasks:** Organize and lead meetings (Daily Standups, Sprint Planning, Retrospectives). Keep the Azure DevOps board updated. Identify and help remove any blockers affecting the team. Acts as the process guardian.

*   **Role 2: Product Owner / Business Analyst (Roberto) + Frontend Support**
    *   **Responsibilities:** Acts as the "voice of the customer," ensuring the final product meets the vision and requirements.
    *   **Key Tasks:** Write and detail User Stories. Prioritize the Product Backlog. Make decisions about product scope and features. Main responsible for technical documentation.

*   **Role 3: Backend Lead / Data Architect (Luis)**
    *   **Responsibilities:** Owns the API and database. Ensures the backend is robust, secure, and scalable.
    *   **Key Tasks:** Design the final Entity-Relationship Model (ERD). Write the SQL script (DDL). Define API architecture (Controllers, Services, Routes). Implement core business logic and complex queries.

*   **Role 4: Frontend Lead / UI/UX Designer (Sebastian)**
    *   **Responsibilities:** Owns the user experience. Ensures the application is intuitive, functional, and visually appealing.
    *   **Key Tasks:** Create prototypes and wireframes in Figma or similar tools. Define the frontend component structure (`api.js`, `ui.js`). Implement main views and ensure responsive design.

*   **Role 5: DevOps Lead / QA Specialist (Antonio) + Backend & Frontend Support**
    *   **Responsibilities:** Responsible for integration, deployment, and project quality. Acts as the bridge between development and production.
    *   **Key Tasks:** Set up and maintain the GitHub repository (branches, merge rules). Write bulk load scripts (seeders). Manage deployment to Netlify/Vercel. Lead manual End-to-End (E2E) testing and report bugs.

---

#### **Step 2: Divide the Project into Sprints (Timeline)**

This is the division of work over the 3 weeks of development, designed to deliver value incrementally.

##### **Week 1 / Sprint 1: Foundation and Minimum MVP (Authentication and Vacation Requests)**
**Goal:** Have a system where a user can log in by role and see a functional "Request Vacation" page. The technical and management foundation of the project must be fully built.

*   **Scrum Master:** Set up the project in Azure DevOps (Backlog, Sprints, Board). Create and configure the GitHub repository. Lead the Kickoff and Daily meetings.
*   **Product Owner:** Write and detail all User Stories for the **Vacation Module** and **role-based Authentication flow**. Prioritize the initial Product Backlog. Start drafting the Technical Document.
*   **Backend Lead:** Design the complete ERD. Write the `database.sql` script for **Users**, **Roles**, and **Vacation Requests** tables. Implement the service and controller for **user registration and login** (with roles) and the **full CRUD for the Vacation Module**.
*   **Frontend Lead:** Create the Figma prototype for the **Login page**, **main Dashboard**, and **Vacation form**. Set up the project structure with Vite and Bootstrap. Build the Login page and main layout (navbar, sidebar) shown to authenticated users.
*   **DevOps/QA Lead:** Write the **Seeder** script to populate Roles tables and create test users for each role (Admin, Leader, Employee). Perform initial manual tests of the login and vacation request flow.

##### **Week 2 / Sprint 2: Feature Expansion (Permissions and Certificates)**
**Goal:** Expand the system so users can request permissions and certificates. The main functionality of the application should be nearly complete by the end of the week.

*   **Scrum Master:** Lead Sprint Planning for Week 2. Ensure Week 1 blockers are resolved and facilitate communication between backend and frontend leads.
*   **Product Owner:** Detail User Stories for the **Permissions and Certificates Modules**. Update the Technical Document with new diagrams and features.
*   **Backend Lead:** Write the SQL script for **Permissions/Licenses** and **Certificate Requests** tables. Implement **full CRUD** for both modules in the backend (Service, Controller, Route).
*   **Frontend Lead:** Implement views and forms for **requesting Permissions** and **requesting Certificates**. Build the "My History" view where an employee can see a consolidated list of all their requests.
*   **DevOps/QA Lead:** Expand the Seeder with test data for permissions and certificates. Research and document the deployment process (environment variables in Netlify/Vercel). Perform E2E tests of the complete request flow.

##### **Week 3 / Sprint 3: Management Panels, Testing, and Deployment**
**Goal:** Finalize the application, including management panels for Leader and HR roles, and have the project fully deployed, tested, and documented. **No major new features are added this week.**

*   **Scrum Master:** Focus on team alignment for final delivery. Review progress of all mandatory deliverables (code, documents, etc.).
*   **Product Owner:** Finish and format the final Technical Document. Prepare the structure for the final presentation and elevator pitch.
*   **Backend Lead:** Implement **advanced queries** for the HR panel (filters, reports, etc.). Create endpoints to consume this data. Refactor and add comments to backend code.
*   **Frontend Lead:** Build views for the **HR and Leader Panels**, consuming report endpoints. Final polish of UI/UX (styles, responsiveness, visual feedback).
*   **DevOps/QA Lead:** **Perform final deployment** of the frontend on Netlify/Vercel (and backend if needed). Set up production environment variables. Lead the final E2E testing session with the complete checklist. Finalize the Postman collection and README.md.