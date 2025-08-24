-- =======================================================================
--                DATABASE CREATION SCRIPT
--                      NEXUS-CODE APPLICATION
-- =======================================================================

-- =======================================================================
-- INSTRUCTIONS: Run this script ONLY AFTER you have manually created the 
-- 'nexus_db' database and are connected to it.
-- =======================================================================
--!TODO: Add the on delete and on update for the constraints
--!TODO: Add checks

-- Enable the uuid-ossp extension to generate UUIDs
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- ========= SECTION 1: GENERAL CATALOG TABLES =========
-- These tables store predefined values to standardize information across the application.

-- Stores employee statuses (e.g., 'Active', 'Inactive', 'On Leave').
CREATE TABLE IF NOT EXISTS public.employee_statuses (
id uuid NOT NULL DEFAULT uuid_generate_v4(),
status_name character varying(100) NOT NULL UNIQUE,
CONSTRAINT employee_statuses_pkey PRIMARY KEY (id)
);
-- A row in this table might look like:
-- (id: '...', status_name: 'Active')

-- Stores genders.
CREATE TABLE IF NOT EXISTS public.genders (
id uuid NOT NULL DEFAULT uuid_generate_v4(),
gender_name character varying(100) NOT NULL UNIQUE,
CONSTRAINT genders_pkey PRIMARY KEY (id)
);
-- A row in this table might look like:
-- (id: '...', gender_name: 'Female')

-- Stores system roles (e.g., 'Employee', 'Manager', 'HR Admin').
CREATE TABLE IF NOT EXISTS public.roles (
id uuid NOT NULL DEFAULT uuid_generate_v4(),
role_name character varying(40) NOT NULL UNIQUE,
description text,
role_area character varying(40) NOT NULL UNIQUE,
CONSTRAINT roles_pkey PRIMARY KEY (id)
);
-- A row in this table might look like:
-- (id: '...', role_name: 'Manager', description: 'Can approve requests for their team.', role_area: 'Engineering')

-- Stores company locations or headquarters.
CREATE TABLE IF NOT EXISTS public.headquarters (
id uuid NOT NULL DEFAULT uuid_generate_v4(),
name character varying(100) NOT NULL,
created_at timestamp without time zone DEFAULT now(),
updated_at timestamp without time zone,
CONSTRAINT headquarters_pkey PRIMARY KEY (id)
);
-- A row in this table might look like:
-- (id: '...', name: 'Main Office - Downtown')

-- Stores general request statuses (e.g., 'Pending', 'Approved', 'Rejected').
CREATE TABLE IF NOT EXISTS public.request_statuses (
id uuid NOT NULL DEFAULT uuid_generate_v4(),
status_name character varying(100) NOT NULL UNIQUE,
CONSTRAINT request_statuses_pkey PRIMARY KEY (id)
);
-- A row in this table might look like:
-- (id: '...', status_name: 'Approved')

-- Catalog for different types of leave (e.g., 'Medical', 'Personal', 'Bereavement').
CREATE TABLE IF NOT EXISTS public.leave_types (
id uuid NOT NULL DEFAULT uuid_generate_v4(),
name character varying(100) NOT NULL UNIQUE,
requires_attachment boolean DEFAULT false,
CONSTRAINT leave_types_pkey PRIMARY KEY (id)
);
-- A row in this table might look like:
-- (id: '...', name: 'Medical Leave', requires_attachment: true)

-- Catalog for different types of certificates (e.g., 'Proof of Employment').
CREATE TABLE IF NOT EXISTS public.certificate_types (
id uuid NOT NULL DEFAULT uuid_generate_v4(),
name character varying(100) NOT NULL UNIQUE,
CONSTRAINT certificate_types_pkey PRIMARY KEY (id)
);
-- A row in this table might look like:
-- (id: '...', name: 'Proof of Employment')

-- Catalog for identification types (e.g., 'National ID', 'Passport').
CREATE TABLE IF NOT EXISTS public.identification_types (
id uuid NOT NULL DEFAULT uuid_generate_v4(),
type_name character varying(100) NOT NULL UNIQUE,
CONSTRAINT identification_types_pkey PRIMARY KEY (id)
);
-- A row in this table might look like:
-- (id: '...', type_name: 'Passport')

-- Catalog for vacation types (e.g., 'Statutory', 'Compensatory Time Off').
CREATE TABLE IF NOT EXISTS public.vacation_types (
id uuid NOT NULL DEFAULT uuid_generate_v4(),
type_name character varying(100) NOT NULL UNIQUE,
CONSTRAINT vacation_types_pkey PRIMARY KEY (id)
);
-- A row in this table might look like:
-- (id: '...', type_name: 'Statutory Annual Leave')

-- Catalog for user access levels within the application.
CREATE TABLE IF NOT EXISTS public.access_levels (
id uuid NOT NULL DEFAULT uuid_generate_v4(),
level_name character varying(100) NOT NULL UNIQUE,
description text,
CONSTRAINT access_levels_pkey PRIMARY KEY (id)
);
-- A row in this table might look like:
-- (id: '...', level_name: 'Admin', description: 'Full access to all system features.')

-- ========= SECTION 2: CORE EMPLOYEE TABLES =========

-- Main table for employees, consolidating personal and user data.
CREATE TABLE IF NOT EXISTS public.employees (
id uuid NOT NULL DEFAULT uuid_generate_v4(),
employee_code character varying(20) NOT NULL UNIQUE,
first_name character varying(40) NOT NULL,
middle_name character varying(40),
last_name character varying(40) NOT NULL,
second_last_name character varying(40),
email character varying(60) NOT NULL UNIQUE,
password_hash character varying(80) NOT NULL,
phone character varying(20),
birth_date date,
hire_date timestamp without time zone NOT NULL,
identification_type_id uuid,
identification_number character varying(50),
manager_id uuid, -- Self-referencing FK to another employee
headquarters_id uuid NOT NULL,
gender_id uuid,
status_id uuid NOT NULL,
access_level_id uuid,
created_at timestamp without time zone DEFAULT now(),
updated_at timestamp without time zone,
is_deleted boolean DEFAULT false,
CONSTRAINT employees_pkey PRIMARY KEY (id),
CONSTRAINT fk_employees_manager FOREIGN KEY (manager_id) REFERENCES public.employees(id),
CONSTRAINT fk_employees_headquarters FOREIGN KEY (headquarters_id) REFERENCES public.headquarters(id),
CONSTRAINT fk_employees_gender FOREIGN KEY (gender_id) REFERENCES public.genders(id),
CONSTRAINT fk_employees_status FOREIGN KEY (status_id) REFERENCES public.employee_statuses(id),
CONSTRAINT fk_employees_identification_type FOREIGN KEY (identification_type_id) REFERENCES public.identification_types(id),
CONSTRAINT fk_employees_access_level FOREIGN KEY (access_level_id) REFERENCES public.access_levels(id)
);
-- A row in this table might look like:
-- (id: '...', employee_code: 'EMP-001', first_name: 'John', last_name: 'Doe', email: 'j.doe@example.com', password_hash: '...', hire_date: '2022-01-10', status_id: '...')

-- Pivot table for the employee-role relationship (allows an employee to have multiple roles).
CREATE TABLE IF NOT EXISTS public.employee_roles (
id uuid NOT NULL DEFAULT uuid_generate_v4(),
employee_id uuid NOT NULL,
role_id uuid NOT NULL,
CONSTRAINT employee_roles_pkey PRIMARY KEY (id),
CONSTRAINT fk_employee FOREIGN KEY (employee_id) REFERENCES public.employees(id),
CONSTRAINT fk_role FOREIGN KEY (role_id) REFERENCES public.roles(id),
UNIQUE (employee_id, role_id)
);
-- A row in this table might look like:
-- (id: '...', employee_id: 'uuid-of-john-doe', role_id: 'uuid-of-manager-role')

-- ========= SECTION 3: REQUESTS STRUCTURE (SUPERTYPE/SUBTYPE) =========

-- 3.1: PARENT TABLE (SUPERTYPE)
-- Contains data common to all types of requests.
CREATE TABLE IF NOT EXISTS public.requests (
id uuid NOT NULL DEFAULT uuid_generate_v4(),
employee_id uuid NOT NULL,
request_type character varying(100) NOT NULL, -- e.g., 'vacation', 'leave', 'certificate'
status_id uuid NOT NULL,
created_at timestamp without time zone DEFAULT now(),
updated_at timestamp without time zone,
CONSTRAINT requests_pkey PRIMARY KEY (id),
CONSTRAINT fk_requests_employee FOREIGN KEY (employee_id) REFERENCES public.employees(id),
CONSTRAINT fk_requests_status FOREIGN KEY (status_id) REFERENCES public.request_statuses(id)
);
-- A row in this table might look like:
-- (id: '...', employee_id: '...', request_type: 'vacation', status_id: '...')

-- 3.2: CHILD TABLES (SUBTYPES)
-- Contain data specific to each request type.

CREATE TABLE IF NOT EXISTS public.vacation_requests (
id uuid NOT NULL, -- PK and FK, inheriting from 'requests'
vacation_type_id uuid NOT NULL,
start_date date NOT NULL,
end_date date NOT NULL,
days_requested integer NOT NULL,
comments text,
is_paid boolean DEFAULT false,
payment_amount numeric(12, 2),
CONSTRAINT vacation_requests_pkey PRIMARY KEY (id),
CONSTRAINT fk_vacation_requests_id FOREIGN KEY (id) REFERENCES public.requests(id) ON DELETE CASCADE,
CONSTRAINT fk_vacation_requests_type FOREIGN KEY (vacation_type_id) REFERENCES public.vacation_types(id)
);
-- A row in this table might look like:
-- (id: 'id-from-requests-table', vacation_type_id: '...', start_date: '2025-12-20', end_date: '2025-12-30', days_requested: 7, is_paid: true, payment_amount: 500.00)

CREATE TABLE IF NOT EXISTS public.leave_requests (
id uuid NOT NULL,
leave_type_id uuid NOT NULL,
start_date timestamp without time zone NOT NULL,
end_date timestamp without time zone NOT NULL,
reason text NOT NULL,
is_paid boolean DEFAULT false,
payment_amount numeric(12, 2),
CONSTRAINT leave_requests_pkey PRIMARY KEY (id),
CONSTRAINT fk_leave_requests_id FOREIGN KEY (id) REFERENCES public.requests(id) ON DELETE CASCADE,
CONSTRAINT fk_leave_requests_type FOREIGN KEY (leave_type_id) REFERENCES public.leave_types(id)
);
-- A row in this table might look like:
-- (id: 'id-from-requests-table', leave_type_id: '...', start_date: '2025-11-05 09:00', end_date: '2025-11-05 17:00', reason: 'Doctor appointment')

CREATE TABLE IF NOT EXISTS public.certificate_requests (
id uuid NOT NULL,
certificate_type_id uuid NOT NULL,
comments text,
CONSTRAINT certificate_requests_pkey PRIMARY KEY (id),
CONSTRAINT fk_certificate_requests_id FOREIGN KEY (id) REFERENCES public.requests(id) ON DELETE CASCADE,
CONSTRAINT fk_certificate_requests_type FOREIGN KEY (certificate_type_id) REFERENCES public.certificate_types(id)
);
-- A row in this table might look like:
-- (id: 'id-from-requests-table', certificate_type_id: '...', comments: 'Please send to my personal email.')

-- ========= SECTION 4: DEPENDENT TABLES WITH REFERENTIAL INTEGRITY =========

-- Stores approval records, linked to the parent 'requests' table.
CREATE TABLE IF NOT EXISTS public.approvals (
id uuid NOT NULL DEFAULT uuid_generate_v4(),
request_id uuid NOT NULL, -- FK to the parent table
approver_id uuid NOT NULL, -- FK to the employees table
status_id uuid NOT NULL, -- The status of this specific approval (Approved/Rejected)
comments text,
approval_date timestamp without time zone DEFAULT now(),
CONSTRAINT approvals_pkey PRIMARY KEY (id),
CONSTRAINT fk_approvals_request FOREIGN KEY (request_id) REFERENCES public.requests(id),
CONSTRAINT fk_approvals_approver FOREIGN KEY (approver_id) REFERENCES public.employees(id),
CONSTRAINT fk_approvals_status FOREIGN KEY (status_id) REFERENCES public.request_statuses(id)
);
-- A row in this table might look like:
-- (id: '...', request_id: '...', approver_id: 'uuid-of-manager', status_id: 'uuid-of-approved', comments: 'Enjoy your vacation.')

-- Stores information about documents attached to any request.
CREATE TABLE IF NOT EXISTS public.attached_documents (
id uuid NOT NULL DEFAULT uuid_generate_v4(),
request_id uuid NOT NULL, -- FK to the parent table
file_name character varying(255) NOT NULL,
file_url character varying(255) NOT NULL,
file_type character varying(50),
file_size integer,
uploaded_by uuid NOT NULL,
created_at timestamp without time zone DEFAULT now(),
CONSTRAINT attached_documents_pkey PRIMARY KEY (id),
CONSTRAINT fk_attached_documents_request FOREIGN KEY (request_id) REFERENCES public.requests(id),
CONSTRAINT fk_attached_documents_uploader FOREIGN KEY (uploaded_by) REFERENCES public.employees(id)
);
-- A row in this table might look like:
-- (id: '...', request_id: '...', file_name: 'doctors_note.pdf', file_url: '/uploads/...', uploaded_by: 'uuid-of-employee')

-- ========= SECTION 5: AUXILIARY AND AUDIT TABLES =========

-- Manages the annual vacation day balance for each employee.
CREATE TABLE IF NOT EXISTS public.vacation_balances (
id uuid NOT NULL DEFAULT uuid_generate_v4(),
employee_id uuid NOT NULL,
year integer NOT NULL,
available_days integer NOT NULL,
days_taken integer DEFAULT 0,
CONSTRAINT vacation_balances_pkey PRIMARY KEY (id),
CONSTRAINT fk_vacation_balances_employee FOREIGN KEY (employee_id) REFERENCES public.employees(id),
UNIQUE (employee_id, year)
);
-- A row in this table might look like:
-- (id: '...', employee_id: '...', year: 2025, available_days: 20, days_taken: 5)

-- Stores the audit trail of important events for each employee.
CREATE TABLE IF NOT EXISTS public.employee_history (
id uuid NOT NULL DEFAULT uuid_generate_v4(),
employee_id uuid NOT NULL,
event character varying(255) NOT NULL,
description text,
performed_by uuid, -- Who performed the action
event_date timestamp without time zone DEFAULT now(),
CONSTRAINT employee_history_pkey PRIMARY KEY (id),
CONSTRAINT fk_employee_history_employee FOREIGN KEY (employee_id) REFERENCES public.employees(id),
CONSTRAINT fk_employee_history_performed_by FOREIGN KEY (performed_by) REFERENCES public.employees(id)
);
-- A row in this table might look like:
-- (id: '...', employee_id: '...', event: 'PROMOTION', description: 'Promoted to Senior Developer', performed_by: 'uuid-of-hr-admin', event_date: '...')

-- Stores in-app notifications for users.
CREATE TABLE IF NOT EXISTS public.notifications (
id uuid NOT NULL DEFAULT uuid_generate_v4(),
recipient_id uuid NOT NULL,
message text NOT NULL,
is_read boolean DEFAULT false,
related_url character varying(255), -- A URL to navigate to when the notification is clicked
sent_date timestamp without time zone DEFAULT now(),
CONSTRAINT notifications_pkey PRIMARY KEY (id),
CONSTRAINT fk_notifications_recipient FOREIGN KEY (recipient_id) REFERENCES public.employees(id)
);
-- A row in this table might look like:
-- (id: '...', recipient_id: '...', message: 'Your leave request has been approved.', is_read: false, related_url: '/requests/uuid-of-request')

-- ========= END OF SCRIPT =========