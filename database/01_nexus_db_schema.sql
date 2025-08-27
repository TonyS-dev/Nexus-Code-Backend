-- =======================================================================
--                DATABASE CREATION SCRIPT
--                      RIWI-NEXUS APPLICATION
-- =======================================================================

CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- ========= TRIGGER FUNCTION FOR TIMESTAMPS =========
CREATE OR REPLACE FUNCTION update_timestamp()
RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'INSERT' THEN
        NEW.created_at = CURRENT_TIMESTAMP;
        NEW.updated_at = NULL;
    ELSIF TG_OP = 'UPDATE' THEN
        NEW.updated_at = CURRENT_TIMESTAMP;
        -- Ensure created_at is never changed on update
        NEW.created_at = OLD.created_at;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- ========= SECTION 1: CATALOG TABLES =========

CREATE TABLE IF NOT EXISTS public.employee_statuses (
    id uuid NOT NULL DEFAULT uuid_generate_v4(),
    name character varying(100) NOT NULL UNIQUE,
    CONSTRAINT employee_statuses_pkey PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS public.genders (
    id uuid NOT NULL DEFAULT uuid_generate_v4(),
    name character varying(100) NOT NULL UNIQUE,
    CONSTRAINT genders_pkey PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS public.roles (
    id uuid NOT NULL DEFAULT uuid_generate_v4(),
    name character varying(40) NOT NULL UNIQUE,
    description text,
    area character varying(40),
    CONSTRAINT roles_pkey PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS public.headquarters (
    id uuid NOT NULL DEFAULT uuid_generate_v4(),
    name character varying(100) NOT NULL UNIQUE,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    CONSTRAINT headquarters_pkey PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS public.request_statuses (
    id uuid NOT NULL DEFAULT uuid_generate_v4(),
    name character varying(100) NOT NULL UNIQUE,
    CONSTRAINT request_statuses_pkey PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS public.leave_types (
    id uuid NOT NULL DEFAULT uuid_generate_v4(),
    name character varying(100) NOT NULL UNIQUE,
    requires_attachment boolean DEFAULT false,
    CONSTRAINT leave_types_pkey PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS public.certificate_types (
    id uuid NOT NULL DEFAULT uuid_generate_v4(),
    name character varying(100) NOT NULL UNIQUE,
    CONSTRAINT certificate_types_pkey PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS public.identification_types (
    id uuid NOT NULL DEFAULT uuid_generate_v4(),
    name character varying(100) NOT NULL UNIQUE,
    CONSTRAINT identification_types_pkey PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS public.vacation_types (
    id uuid NOT NULL DEFAULT uuid_generate_v4(),
    name character varying(100) NOT NULL UNIQUE,
    CONSTRAINT vacation_types_pkey PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS public.access_levels (
    id uuid NOT NULL DEFAULT uuid_generate_v4(),
    name character varying(100) NOT NULL UNIQUE,
    description text,
    CONSTRAINT access_levels_pkey PRIMARY KEY (id)
);

-- ========= SECTION 2: CORE TABLES =========

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
    hire_date date NOT NULL,
    identification_type_id uuid,
    identification_number character varying(50),
    manager_id uuid,
    headquarters_id uuid NOT NULL,
    gender_id uuid,
    status_id uuid NOT NULL,
    access_level_id uuid,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    is_deleted boolean DEFAULT false,
    CONSTRAINT employees_pkey PRIMARY KEY (id),
    CONSTRAINT employees_manager_id_fkey FOREIGN KEY (manager_id) REFERENCES public.employees(id) ON DELETE SET NULL,
    CONSTRAINT employees_headquarters_id_fkey FOREIGN KEY (headquarters_id) REFERENCES public.headquarters(id),
    CONSTRAINT employees_gender_id_fkey FOREIGN KEY (gender_id) REFERENCES public.genders(id) ON DELETE SET NULL,
    CONSTRAINT employees_status_id_fkey FOREIGN KEY (status_id) REFERENCES public.employee_statuses(id),
    CONSTRAINT employees_identification_type_id_fkey FOREIGN KEY (identification_type_id) REFERENCES public.identification_types(id) ON DELETE SET NULL,
    CONSTRAINT employees_access_level_id_fkey FOREIGN KEY (access_level_id) REFERENCES public.access_levels(id) ON DELETE SET NULL
);

CREATE TABLE IF NOT EXISTS public.employee_salaries (
    id uuid NOT NULL DEFAULT uuid_generate_v4(),
    employee_id uuid NOT NULL,
    salary_amount numeric(12, 2) NOT NULL,
    effective_date date NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    CONSTRAINT employee_salaries_pkey PRIMARY KEY (id),
    CONSTRAINT employee_salaries_employee_id_fkey FOREIGN KEY (employee_id) REFERENCES public.employees(id) ON DELETE CASCADE,
    CONSTRAINT employee_salaries_chk_salary_amount_positive CHECK (salary_amount > 0)
);

CREATE TABLE IF NOT EXISTS public.employee_roles (
    employee_id uuid NOT NULL,
    role_id uuid NOT NULL,
    CONSTRAINT employee_roles_pkey PRIMARY KEY (employee_id, role_id),
    CONSTRAINT employee_roles_employee_id_fkey FOREIGN KEY (employee_id) REFERENCES public.employees(id) ON DELETE CASCADE,
    CONSTRAINT employee_roles_role_id_fkey FOREIGN KEY (role_id) REFERENCES public.roles(id) ON DELETE CASCADE
);

-- ========= SECTION 3: REQUESTS & RELATED TABLES =========

CREATE TABLE IF NOT EXISTS public.requests (
    id uuid NOT NULL DEFAULT uuid_generate_v4(),
    employee_id uuid NOT NULL,
    request_type character varying(100) NOT NULL,
    status_id uuid NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    CONSTRAINT requests_pkey PRIMARY KEY (id),
    CONSTRAINT requests_employee_id_fkey FOREIGN KEY (employee_id) REFERENCES public.employees(id) ON DELETE CASCADE,
    CONSTRAINT requests_status_id_fkey FOREIGN KEY (status_id) REFERENCES public.request_statuses(id)
);

CREATE TABLE IF NOT EXISTS public.vacation_requests (
    id uuid NOT NULL,
    vacation_type_id uuid NOT NULL,
    start_date date NOT NULL,
    end_date date NOT NULL,
    days_requested integer NOT NULL,
    comments text,
    is_paid boolean DEFAULT false,
    payment_amount numeric(12, 2),
    CONSTRAINT vacation_requests_pkey PRIMARY KEY (id),
    CONSTRAINT vacation_requests_id_fkey FOREIGN KEY (id) REFERENCES public.requests(id) ON DELETE CASCADE,
    CONSTRAINT vacation_requests_vacation_type_id_fkey FOREIGN KEY (vacation_type_id) REFERENCES public.vacation_types(id),
    CONSTRAINT vacation_requests_chk_end_date_after_start CHECK (end_date >= start_date)
);

CREATE TABLE IF NOT EXISTS public.leave_requests (
    id uuid NOT NULL,
    leave_type_id uuid NOT NULL,
    start_date timestamp without time zone NOT NULL,
    end_date timestamp without time zone NOT NULL,
    reason text NOT NULL,
    is_paid boolean DEFAULT false,
    payment_amount numeric(12, 2),
    CONSTRAINT leave_requests_pkey PRIMARY KEY (id),
    CONSTRAINT leave_requests_id_fkey FOREIGN KEY (id) REFERENCES public.requests(id) ON DELETE CASCADE,
    CONSTRAINT leave_requests_leave_type_id_fkey FOREIGN KEY (leave_type_id) REFERENCES public.leave_types(id),
    CONSTRAINT leave_requests_chk_end_date_after_start CHECK (end_date >= start_date)
);

CREATE TABLE IF NOT EXISTS public.certificate_requests (
    id uuid NOT NULL,
    certificate_type_id uuid NOT NULL,
    comments text,
    CONSTRAINT certificate_requests_pkey PRIMARY KEY (id),
    CONSTRAINT certificate_requests_id_fkey FOREIGN KEY (id) REFERENCES public.requests(id) ON DELETE CASCADE,
    CONSTRAINT certificate_requests_certificate_type_id_fkey FOREIGN KEY (certificate_type_id) REFERENCES public.certificate_types(id)
);

-- ========= SECTION 4: DEPENDENT & AUDIT TABLES =========

CREATE TABLE IF NOT EXISTS public.approvals (
    id uuid NOT NULL DEFAULT uuid_generate_v4(),
    request_id uuid NOT NULL,
    approver_id uuid NOT NULL,
    status_id uuid NOT NULL,
    comments text,
    approval_date timestamp without time zone DEFAULT now(),
    CONSTRAINT approvals_pkey PRIMARY KEY (id),
    CONSTRAINT approvals_request_id_fkey FOREIGN KEY (request_id) REFERENCES public.requests(id) ON DELETE CASCADE,
    CONSTRAINT approvals_approver_id_fkey FOREIGN KEY (approver_id) REFERENCES public.employees(id) ON DELETE RESTRICT,
    CONSTRAINT approvals_status_id_fkey FOREIGN KEY (status_id) REFERENCES public.request_statuses(id)
);

CREATE TABLE IF NOT EXISTS public.attached_documents (
    id uuid NOT NULL DEFAULT uuid_generate_v4(),
    request_id uuid NOT NULL,
    file_name character varying(255) NOT NULL,
    file_url character varying(255) NOT NULL,
    file_type character varying(50),
    file_size_bytes integer,
    uploaded_by_id uuid NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    CONSTRAINT attached_documents_pkey PRIMARY KEY (id),
    CONSTRAINT attached_documents_request_id_fkey FOREIGN KEY (request_id) REFERENCES public.requests(id) ON DELETE CASCADE,
    CONSTRAINT attached_documents_uploaded_by_id_fkey FOREIGN KEY (uploaded_by_id) REFERENCES public.employees(id)
);

CREATE TABLE IF NOT EXISTS public.vacation_balances (
    id uuid NOT NULL DEFAULT uuid_generate_v4(),
    employee_id uuid NOT NULL,
    year integer NOT NULL,
    available_days integer NOT NULL,
    days_taken integer DEFAULT 0,
    CONSTRAINT vacation_balances_pkey PRIMARY KEY (id),
    CONSTRAINT vacation_balances_employee_id_fkey FOREIGN KEY (employee_id) REFERENCES public.employees(id) ON DELETE CASCADE,
    CONSTRAINT vacation_balances_ukey UNIQUE (employee_id, year)
);

CREATE TABLE IF NOT EXISTS public.employee_histories (
    id uuid NOT NULL DEFAULT uuid_generate_v4(),
    employee_id uuid NOT NULL,
    event character varying(255) NOT NULL,
    description text,
    performed_by_id uuid,
    event_date timestamp without time zone DEFAULT now(),
    CONSTRAINT employee_histories_pkey PRIMARY KEY (id),
    CONSTRAINT employee_histories_employee_id_fkey FOREIGN KEY (employee_id) REFERENCES public.employees(id) ON DELETE CASCADE,
    CONSTRAINT employee_histories_performed_by_id_fkey FOREIGN KEY (performed_by_id) REFERENCES public.employees(id) ON DELETE SET NULL
);

CREATE TABLE IF NOT EXISTS public.notifications (
    id uuid NOT NULL DEFAULT uuid_generate_v4(),
    recipient_id uuid NOT NULL,
    message text NOT NULL,
    is_read boolean DEFAULT false,
    related_url character varying(255),
    sent_date timestamp without time zone DEFAULT now(),
    CONSTRAINT notifications_pkey PRIMARY KEY (id),
    CONSTRAINT notifications_recipient_id_fkey FOREIGN KEY (recipient_id) REFERENCES public.employees(id) ON DELETE CASCADE
);

-- ========= SECTION 5: APPLY TRIGGERS =========
-- Drop the trigger first to avoid errors on re-running the script
DROP TRIGGER IF EXISTS set_employees_timestamp ON public.employees;
CREATE TRIGGER set_employees_timestamp
BEFORE INSERT OR UPDATE ON public.employees
FOR EACH ROW EXECUTE FUNCTION update_timestamp();

DROP TRIGGER IF EXISTS set_employee_salaries_timestamp ON public.employee_salaries;
CREATE TRIGGER set_employee_salaries_timestamp
BEFORE INSERT OR UPDATE ON public.employee_salaries
FOR EACH ROW EXECUTE FUNCTION update_timestamp();

DROP TRIGGER IF EXISTS set_headquarters_timestamp ON public.headquarters;
CREATE TRIGGER set_headquarters_timestamp
BEFORE INSERT OR UPDATE ON public.headquarters
FOR EACH ROW EXECUTE FUNCTION update_timestamp();

DROP TRIGGER IF EXISTS set_requests_timestamp ON public.requests;
CREATE TRIGGER set_requests_timestamp
BEFORE INSERT OR UPDATE ON public.requests
FOR EACH ROW EXECUTE FUNCTION update_timestamp();

DROP TRIGGER IF EXISTS set_attached_documents_timestamp ON public.attached_documents;
CREATE TRIGGER set_attached_documents_timestamp
BEFORE INSERT OR UPDATE ON public.attached_documents
FOR EACH ROW EXECUTE FUNCTION update_timestamp();

-- ========= END OF SCRIPT =========