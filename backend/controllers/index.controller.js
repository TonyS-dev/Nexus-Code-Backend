// backend/controllers/index.controller.js
import packageJson from '../package.json' with { type: 'json' };

export const getApiInfo = (req, res, next) => {
    // Helper function to build the full URL
    const buildUrl = (path) => `${req.protocol}://${req.get('host')}${path}`;

    const apiInfo = {
        name: 'Riwi-Nexus API',
        version: packageJson.version,
        description:
            'API for managing internal HR processes like employee data, roles, and leave requests.',
        documentation: 
            'https://github.com/username/repo/blob/main/README.md', // WIP maybe a link to a postman collection
        endpoints: [
            // --- Authentication ---
            {
                path: '/login',
                method: 'POST',
                description: 'Authenticates a user and returns a JWT.',
                body: {
                    email: 'user@example.com',
                    password: 'password123',
                },
            },

            // --- Employees (Protected) ---
            {
                path: '/employees',
                method: 'GET',
                description:
                    'Retrieves a list of all employees. Requires Bearer Token.',
            },
            {
                path: '/employees',
                method: 'POST',
                description: 'Creates a new employee. Requires Bearer Token.',
            },
            {
                path: '/employees/:id',
                method: 'GET',
                description:
                    'Retrieves a single employee by their UUID. Requires Bearer Token.',
            },
            {
                path: '/employees/:id',
                method: 'PUT',
                description:
                    'Updates a single employee by their UUID. Requires Bearer Token.',
            },
            {
                path: '/employees/:id',
                method: 'PATCH',
                description:
                    'Soft deletes a single employee by their UUID. Requires Bearer Token.',
            },

            // --- Catalog Management (Protected) ---
            {
                path: '/roles',
                method: 'GET/POST',
                description:
                    'Get a list of all roles or create a new one. Requires Bearer Token.',
            },
            {
                path: '/roles/:id',
                method: 'GET/PUT',
                description:
                    'Get or update a single role by UUID. Requires Bearer Token.',
            },
            {
                path: '/headquarters',
                method: 'GET/POST',
                description:
                    'Get a list of all headquarters or create a new one. Requires Bearer Token.',
            },
            {
                path: '/headquarters/:id',
                method: 'GET/PUT',
                description:
                    'Get or update a single headquarter by UUID. Requires Bearer Token.',
            },
            {
                path: '/genders',
                method: 'GET/POST',
                description:
                    'Get a list of all genders or create a new one. Requires Bearer Token.',
            },
            {
                path: '/genders/:id',
                method: 'GET/PUT',
                description:
                    'Get or update a single gender by UUID. Requires Bearer Token.',
            },
            {
                path: '/employee-statuses',
                method: 'GET/POST',
                description:
                    'Get a list of all employee statuses or create a new one. Requires Bearer Token.',
            },
            {
                path: '/employee-statuses/:id',
                method: 'GET/PUT',
                description:
                    'Get or update a single employee status by UUID. Requires Bearer Token.',
            },
            {
                path: '/access-levels',
                method: 'GET/POST',
                description:
                    'Get a list of all access levels or create a new one. Requires Bearer Token.',
            },
            {
                path: '/access-levels/:id',
                method: 'GET/PUT',
                description:
                    'Get or update a single access level by UUID. Requires Bearer Token.',
            },
            {
                path: '/identification-type',
                method: 'GET/POST',
                description:
                    'Get a list of all identification types or create a new one. Requires Bearer Token.',
            },
            {
                path: '/identification-type/:id',
                method: 'GET/PUT',
                description:
                    'Get or update a single identification type by UUID. Requires Bearer Token.',
            },
        ],
    };

    res.status(200).json(apiInfo);
};
