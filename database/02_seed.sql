-- =======================================================================
--                SEED SCRIPT FOR NEXUS-CODE DATABASE
-- This script populates ONLY non-user tables with test data.
-- Employee creation MUST be done via the API.
-- =======================================================================

DO $$
DECLARE
    hq_main_id uuid;
    req_status_pending_id uuid;
    req_status_approved_id uuid;
    req_status_rejected_id uuid;
BEGIN

    -- ========= SECTION 1: INSERT CATALOG DATA =========

    INSERT INTO public.employee_statuses (name) VALUES 
        ('Active'), 
        ('Inactive'), 
        ('On Leave');

    INSERT INTO public.genders (name) VALUES 
        ('Male'), 
        ('Female'), 
        ('Non-binary');

    INSERT INTO public.roles (name, description, area) VALUES 
        ('Employee', 'Standard employee access', 'General'), 
        ('Manager', 'Team Manager with approval rights', 'Management'), 
        ('Admin', 'System Administrator with full access', 'Administration'), 
        ('HR', 'Human Resources personnel', 'HR');

    INSERT INTO public.headquarters (name) VALUES 
        ('Main Office'),
        ('Remote');
    
    INSERT INTO public.request_statuses (name) VALUES 
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

    INSERT INTO public.identification_types (name) VALUES 
        ('National ID'), 
        ('Passport'),
        ('Foreign ID');

    INSERT INTO public.vacation_types (name) VALUES 
        ('Statutory'), 
        ('Compensatory');

    INSERT INTO public.access_levels (name, description) VALUES 
        ('User', 'Basic user access'), 
        ('Admin', 'Full system access');

END $$;