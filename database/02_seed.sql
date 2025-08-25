-- =======================================================================
--                SEED SCRIPT FOR NEXUS-CODE DATABASE
-- This script populates the database with initial data for development and testing.
-- It should be run AFTER the main database creation script.
-- =======================================================================

-- Wrap the entire seed process in a transaction for atomicity.
-- DO-END block allows variable declarations.
DO $$
DECLARE
    -- Catalog UUIDs
    status_active_id uuid;
    gender_male_id uuid;
    gender_female_id uuid;
    role_employee_id uuid;
    role_manager_id uuid;
    role_admin_id uuid;
    role_hr_id uuid;
    hq_main_id uuid;
    req_status_pending_id uuid;
    req_status_approved_id uuid;
    req_status_rejected_id uuid;
    leave_type_medical_id uuid;
    cert_type_employment_id uuid;
    id_type_national_id uuid;
    vacation_type_statutory_id uuid;
    access_level_user_id uuid;
    access_level_admin_id uuid;
    
    -- Employee UUIDs
    admin_hr_id uuid;
    moises_id uuid;
    emp_ana_id uuid;
    emp_carlos_id uuid;
    emp_sofia_id uuid;

    -- Request UUIDs
    vacation_req_id uuid;
    leave_req_id uuid;
    cert_req_id uuid;
BEGIN

    -- ========= SECTION 1: INSERT CATALOG DATA =========

    -- Inserting and capturing UUIDs for later use.
    INSERT INTO public.employee_statuses (status_name) VALUES ('Active') RETURNING id INTO status_active_id;
    INSERT INTO public.employee_statuses (status_name) VALUES ('Inactive'), ('On Leave');

    INSERT INTO public.genders (gender_name) VALUES ('Male') RETURNING id INTO gender_male_id;
    INSERT INTO public.genders (gender_name) VALUES ('Female') RETURNING id INTO gender_female_id;
    INSERT INTO public.genders (gender_name) VALUES ('Non-binary');

    INSERT INTO public.roles (role_name, description, role_area) VALUES ('Employee', 'Standard employee access', 'General') RETURNING id INTO role_employee_id;
    INSERT INTO public.roles (role_name, description, role_area) VALUES ('Manager', 'Team Manager with approval rights', 'Management') RETURNING id INTO role_manager_id;
    INSERT INTO public.roles (role_name, description, role_area) VALUES ('Admin', 'System Administrator with full access', 'Administration') RETURNING id INTO role_admin_id;
    INSERT INTO public.roles (role_name, description, role_area) VALUES ('HR', 'Human Resources personnel', 'HR') RETURNING id INTO role_hr_id;

    INSERT INTO public.headquarters (name) VALUES ('Main Office') RETURNING id INTO hq_main_id;
    
    INSERT INTO public.request_statuses (status_name) VALUES ('Pending') RETURNING id INTO req_status_pending_id;
    INSERT INTO public.request_statuses (status_name) VALUES ('Approved') RETURNING id INTO req_status_approved_id;
    INSERT INTO public.request_statuses (status_name) VALUES ('Rejected') RETURNING id INTO req_status_rejected_id;

    INSERT INTO public.leave_types (name, requires_attachment) VALUES ('Medical', true) RETURNING id INTO leave_type_medical_id;
    INSERT INTO public.leave_types (name, requires_attachment) VALUES ('Personal', false), ('Bereavement', true);

    INSERT INTO public.certificate_types (name) VALUES ('Proof of Employment') RETURNING id INTO cert_type_employment_id;
    INSERT INTO public.certificate_types (name) VALUES ('Salary Certificate');

    INSERT INTO public.identification_types (type_name) VALUES ('National ID') RETURNING id INTO id_type_national_id;
    INSERT INTO public.identification_types (type_name) VALUES ('Passport');

    INSERT INTO public.vacation_types (type_name) VALUES ('Statutory') RETURNING id INTO vacation_type_statutory_id;
    INSERT INTO public.vacation_types (type_name) VALUES ('Compensatory');

    INSERT INTO public.access_levels (level_name, description) VALUES ('User', 'Basic user access') RETURNING id INTO access_level_user_id;
    INSERT INTO public.access_levels (level_name, description) VALUES ('Admin', 'Full system access') RETURNING id INTO access_level_admin_id;


    -- ========= SECTION 2: INSERT EMPLOYEES AND SET HIERARCHY =========

    -- The password for ALL users is "password123"
    -- The bcrypt hash is: $2b$10$E9pP.y6vCxJ2aDu9r/y/e.iX5fQf/3.yBwQJ.3t7uF.yBwQJ.3

    -- Create the top-level Admin/HR user (no manager)
    -- ADDED hire_date column
    INSERT INTO public.employees (employee_code, first_name, last_name, email, password_hash, headquarters_id, status_id, access_level_id, gender_id, hire_date) VALUES 
    ('ADMIN-001', 'Admin', 'User', 'admin@nexus.com', '$2b$10$E9pP.y6vCxJ2aDu9r/y/e.iX5fQf/3.yBwQJ.3t7uF.yBwQJ.3', hq_main_id, status_active_id, access_level_admin_id, gender_male_id, CURRENT_DATE) 
    RETURNING id INTO admin_hr_id;

    -- Create Moises as a Manager who reports to the Admin
    -- ADDED hire_date column
    INSERT INTO public.employees (employee_code, first_name, last_name, email, password_hash, headquarters_id, status_id, access_level_id, gender_id, manager_id, hire_date) VALUES 
    ('MAN-001', 'Moises', 'Pereira', 'moises@nexus.com', '$2b$10$E9pP.y6vCxJ2aDu9r/y/e.iX5fQf/3.yBwQJ.3t7uF.yBwQJ.3', hq_main_id, status_active_id, access_level_user_id, gender_male_id, admin_hr_id, CURRENT_DATE)
    RETURNING id INTO moises_id;

    -- Create 3 employees who report to Moises
    -- ADDED hire_date column
    INSERT INTO public.employees (employee_code, first_name, last_name, email, password_hash, headquarters_id, status_id, access_level_id, gender_id, manager_id, hire_date) VALUES 
    ('EMP-001', 'Ana', 'Lopez', 'ana@nexus.com', '$2b$10$E9pP.y6vCxJ2aDu9r/y/e.iX5fQf/3.yBwQJ.3t7uF.yBwQJ.3', hq_main_id, status_active_id, access_level_user_id, gender_female_id, moises_id, CURRENT_DATE) RETURNING id INTO emp_ana_id;
    INSERT INTO public.employees (employee_code, first_name, last_name, email, password_hash, headquarters_id, status_id, access_level_id, gender_id, manager_id, hire_date) VALUES 
    ('EMP-002', 'Carlos', 'Ruiz', 'carlos@nexus.com', '$2b$10$E9pP.y6vCxJ2aDu9r/y/e.iX5fQf/3.yBwQJ.3t7uF.yBwQJ.3', hq_main_id, status_active_id, access_level_user_id, gender_male_id, moises_id, CURRENT_DATE) RETURNING id INTO emp_carlos_id;
    INSERT INTO public.employees (employee_code, first_name, last_name, email, password_hash, headquarters_id, status_id, access_level_id, gender_id, manager_id, hire_date) VALUES 
    ('EMP-003', 'Sofia', 'Mendez', 'sofia@nexus.com', '$2b$10$E9pP.y6vCxJ2aDu9r/y/e.iX5fQf/3.yBwQJ.3t7uF.yBwQJ.3', hq_main_id, status_active_id, access_level_user_id, gender_female_id, moises_id, CURRENT_DATE) RETURNING id INTO emp_sofia_id;

    -- Assign roles to employees
    INSERT INTO public.employee_roles (employee_id, role_id) VALUES
        (admin_hr_id, role_admin_id), (admin_hr_id, role_hr_id),
        (moises_id, role_manager_id), (moises_id, role_employee_id),
        (emp_ana_id, role_employee_id),
        (emp_carlos_id, role_employee_id),
        (emp_sofia_id, role_employee_id);


    -- ========= SECTION 3: INSERT SAMPLE REQUESTS FOR A USER =========

    -- Create a PENDING vacation request for Ana (to be approved by Moises)
    INSERT INTO public.requests (employee_id, request_type, status_id) VALUES
    (emp_ana_id, 'vacation', req_status_pending_id) RETURNING id INTO vacation_req_id;
    INSERT INTO public.vacation_requests (id, vacation_type_id, start_date, end_date, days_requested, comments) VALUES
    (vacation_req_id, vacation_type_statutory_id, '2025-12-20', '2025-12-30', 7, 'Christmas vacation');
    
    -- Create an APPROVED leave request for Carlos (approved by Moises)
    INSERT INTO public.requests (employee_id, request_type, status_id) VALUES
    (emp_carlos_id, 'leave', req_status_approved_id) RETURNING id INTO leave_req_id;
    INSERT INTO public.leave_requests (id, leave_type_id, start_date, end_date, reason, is_paid) VALUES
    (leave_req_id, leave_type_medical_id, '2025-09-01 09:00:00', '2025-09-01 17:00:00', 'Doctor''s appointment', false);
    
    -- Create a record for the approval of Carlos's leave (approved by Moises)
    INSERT INTO public.approvals (request_id, approver_id, status_id, comments) VALUES
    (leave_req_id, moises_id, req_status_approved_id, 'Approved. Hope you feel better.');
    
    -- Create a REJECTED certificate request for Sofia (rejected by Moises)
    INSERT INTO public.requests (employee_id, request_type, status_id) VALUES
    (emp_sofia_id, 'certificate', req_status_rejected_id) RETURNING id INTO cert_req_id;
    INSERT INTO public.certificate_requests (id, certificate_type_id, comments) VALUES
    (cert_req_id, cert_type_employment_id, 'Needed for a visa application.');


    -- ========= SECTION 4: INSERT AUXILIARY DATA =========

    -- Vacation balance for Moises
    INSERT INTO public.vacation_balances (employee_id, year, available_days) VALUES (moises_id, 2025, 20);

    -- Notification for Moises about Ana's pending request
    INSERT INTO public.notifications (recipient_id, message, is_read, related_url) VALUES
    (moises_id, 'You have a new vacation request from Ana Lopez to approve.', false, '/requests/' || vacation_req_id);

END $$;