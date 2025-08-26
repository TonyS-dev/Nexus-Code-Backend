-- =======================================================================
--                SEED SCRIPT FOR NEXUS-CODE DATABASE
-- This script populates ONLY the catalog tables with initial data.
-- User creation should be handled via the API to ensure correct password hashing.
-- =======================================================================

DO $$
BEGIN

    -- ========= SECTION 1: INSERT CATALOG DATA =========

    INSERT INTO public.employee_statuses (status_name) VALUES 
        ('Active'), 
        ('Inactive'), 
        ('On Leave');

    INSERT INTO public.genders (gender_name) VALUES 
        ('Male'), 
        ('Female'), 
        ('Non-binary');

    INSERT INTO public.roles (role_name, description, role_area) VALUES 
        ('Employee', 'Standard employee access', 'General'), 
        ('Manager', 'Team Manager with approval rights', 'Management'), 
        ('Admin', 'System Administrator with full access', 'Administration'), 
        ('HR', 'Human Resources personnel', 'HR');

    INSERT INTO public.headquarters (name) VALUES 
        ('Main Office'),
        ('Remote');
    
    INSERT INTO public.request_statuses (status_name) VALUES 
        ('Pending'), 
        ('Approved'), 
        ('Rejected');

    INSERT INTO public.leave_types (name, requires_attachment) VALUES 
        ('Medical', true), 
        ('Personal', false), 
        ('Bereavement', true);

    INSERT INTO public.certificate_types (name) VALUES 
        ('Proof of Employment'), 
        ('Salary Certificate');

    INSERT INTO public.identification_types (type_name) VALUES 
        ('National ID'), 
        ('Passport'),
        ('Foreign ID');

    INSERT INTO public.vacation_types (type_name) VALUES 
        ('Statutory'), 
        ('Compensatory');

    INSERT INTO public.access_levels (level_name, description) VALUES 
        ('User', 'Basic user access'), 
        ('Admin', 'Full system access');

END $$;