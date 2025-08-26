-- =======================================================================
--                SCRIPT DE CREACIÓN DE BASE DE DATOS
--                      APLICACIÓN NEXUS-CODE
-- =======================================================================

-- =======================================================================
-- INSTRUCCIONES: Ejecuta este script SÓLO DESPUÉS de haber creado manualmente 
-- la base de datos 'nexus_db' y estar conectado a ella.
-- =======================================================================

-- Habilita la extensión uuid-ossp para generar UUIDs
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- ========= FUNCIÓN DE DISPARADOR PARA MARCAS DE TIEMPO =========
-- Función para actualizar las columnas created_at y updated_at
CREATE OR REPLACE FUNCTION update_timestamp()
RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'INSERT' THEN
        NEW.created_at = CURRENT_TIMESTAMP;
        NEW.updated_at = NULL;
    ELSIF TG_OP = 'UPDATE' THEN
        NEW.updated_at = CURRENT_TIMESTAMP;
        IF NEW.created_at IS NULL THEN
            NEW.created_at = OLD.created_at;
        END IF;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- ========= SECCIÓN 1: TABLAS DE CATÁLOGO GENERAL =========
-- Estas tablas almacenan valores predefinidos para estandarizar la información en la aplicación.

-- Almacena los estados de los empleados (ej. 'Activo', 'Inactivo', 'En licencia').
CREATE TABLE IF NOT EXISTS public.employee_statuses (
    id uuid NOT NULL DEFAULT uuid_generate_v4(),
    status_name character varying(100) NOT NULL UNIQUE,
    CONSTRAINT employee_statuses_pkey PRIMARY KEY (id),
    CONSTRAINT chk_status_name_not_empty CHECK (status_name <> '')
);

-- Almacena géneros.
CREATE TABLE IF NOT EXISTS public.genders (
    id uuid NOT NULL DEFAULT uuid_generate_v4(),
    gender_name character varying(100) NOT NULL UNIQUE,
    CONSTRAINT genders_pkey PRIMARY KEY (id),
    CONSTRAINT chk_gender_name_not_empty CHECK (gender_name <> '')
);

-- Almacena roles del sistema (ej. 'Empleado', 'Gerente', 'Admin RH').
CREATE TABLE IF NOT EXISTS public.roles (
    id uuid NOT NULL DEFAULT uuid_generate_v4(),
    role_name character varying(40) NOT NULL UNIQUE,
    description text,
    role_area character varying(40) NOT NULL UNIQUE,
    CONSTRAINT roles_pkey PRIMARY KEY (id),
    CONSTRAINT chk_role_name_not_empty CHECK (role_name <> ''),
    CONSTRAINT chk_role_area_not_empty CHECK (role_area <> '')
);

-- Almacena ubicaciones o sedes de la empresa.
CREATE TABLE IF NOT EXISTS public.headquarters (
    id uuid NOT NULL DEFAULT uuid_generate_v4(),
    name character varying(100) NOT NULL,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone,
    CONSTRAINT headquarters_pkey PRIMARY KEY (id),
    CONSTRAINT chk_name_not_empty CHECK (name <> '')
);

-- Disparador para marcas de tiempo en headquarters
CREATE TRIGGER trigger_headquarters_timestamp
    BEFORE INSERT OR UPDATE ON public.headquarters
    FOR EACH ROW EXECUTE FUNCTION update_timestamp();

-- Almacena estados generales de solicitudes (ej. 'Pendiente', 'Aprobado', 'Rechazado').
CREATE TABLE IF NOT EXISTS public.request_statuses (
    id uuid NOT NULL DEFAULT uuid_generate_v4(),
    status_name character varying(100) NOT NULL UNIQUE,
    CONSTRAINT request_statuses_pkey PRIMARY KEY (id),
    CONSTRAINT chk_status_name_not_empty CHECK (status_name <> '')
);

-- Catálogo para tipos de licencias (ej. 'Médica', 'Personal', 'Duelo').
CREATE TABLE IF NOT EXISTS public.leave_types (
    id uuid NOT NULL DEFAULT uuid_generate_v4(),
    name character varying(100) NOT NULL UNIQUE,
    requires_attachment boolean DEFAULT false,
    CONSTRAINT leave_types_pkey PRIMARY KEY (id),
    CONSTRAINT chk_name_not_empty CHECK (name <> '')
);

-- Catálogo para tipos de certificados (ej. 'Constancia de Empleo').
CREATE TABLE IF NOT EXISTS public.certificate_types (
    id uuid NOT NULL DEFAULT uuid_generate_v4(),
    name character varying(100) NOT NULL UNIQUE,
    CONSTRAINT certificate_types_pkey PRIMARY KEY (id),
    CONSTRAINT chk_name_not_empty CHECK (name <> '')
);

-- Catálogo para tipos de identificación (ej. 'Cédula', 'Pasaporte').
CREATE TABLE IF NOT EXISTS public.identification_types (
    id uuid NOT NULL DEFAULT uuid_generate_v4(),
    type_name character varying(100) NOT NULL UNIQUE,
    CONSTRAINT identification_types_pkey PRIMARY KEY (id),
    CONSTRAINT chk_type_name_not_empty CHECK (type_name <> '')
);

-- Catálogo para tipos de vacaciones (ej. 'Estatutarias', 'Compensatorias').
CREATE TABLE IF NOT EXISTS public.vacation_types (
    id uuid NOT NULL DEFAULT uuid_generate_v4(),
    type_name character varying(100) NOT NULL UNIQUE,
    CONSTRAINT vacation_types_pkey PRIMARY KEY (id),
    CONSTRAINT chk_type_name_not_empty CHECK (type_name <> '')
);

-- Catálogo para niveles de acceso de usuarios en la aplicación.
CREATE TABLE IF NOT EXISTS public.access_levels (
    id uuid NOT NULL DEFAULT uuid_generate_v4(),
    level_name character varying(100) NOT NULL UNIQUE,
    description text,
    CONSTRAINT access_levels_pkey PRIMARY KEY (id),
    CONSTRAINT chk_level_name_not_empty CHECK (level_name <> '')
);

-- ========= SECCIÓN 2: TABLAS PRINCIPALES DE EMPLEADOS =========

-- Tabla para información de salarios de empleados
CREATE TABLE IF NOT EXISTS public.employee_salaries (
    id uuid NOT NULL DEFAULT uuid_generate_v4(),
    salary_amount numeric(12, 2) NOT NULL,
    effective_date date NOT NULL,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone,
    CONSTRAINT employee_salaries_pkey PRIMARY KEY (id),
    CONSTRAINT chk_salary_amount_positive CHECK (salary_amount > 0),
    CONSTRAINT chk_effective_date_not_future CHECK (effective_date <= CURRENT_DATE)
);

-- Disparador para marcas de tiempo en employee_salaries
CREATE TRIGGER trigger_employee_salaries_timestamp
    BEFORE INSERT OR UPDATE ON public.employee_salaries
    FOR EACH ROW EXECUTE FUNCTION update_timestamp();

-- Tabla principal para empleados, consolidando datos personales y de usuario.
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
    manager_id uuid, -- Clave foránea autorreferencial a otro empleado
    headquarters_id uuid NOT NULL,
    gender_id uuid,
    status_id uuid NOT NULL,
    access_level_id uuid,
    salary_id uuid, -- Nueva clave foránea que referencia employee_salaries
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone,
    is_deleted boolean DEFAULT false,
    CONSTRAINT employees_pkey PRIMARY KEY (id),
    CONSTRAINT fk_employees_manager FOREIGN KEY (manager_id) REFERENCES public.employees(id) ON DELETE SET NULL ON UPDATE CASCADE,
    CONSTRAINT fk_employees_headquarters FOREIGN KEY (headquarters_id) REFERENCES public.headquarters(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_employees_gender FOREIGN KEY (gender_id) REFERENCES public.genders(id) ON DELETE SET NULL ON UPDATE CASCADE,
    CONSTRAINT fk_employees_status FOREIGN KEY (status_id) REFERENCES public.employee_statuses(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_employees_identification_type FOREIGN KEY (identification_type_id) REFERENCES public.identification_types(id) ON DELETE SET NULL ON UPDATE CASCADE,
    CONSTRAINT fk_employees_access_level FOREIGN KEY (access_level_id) REFERENCES public.access_levels(id) ON DELETE SET NULL ON UPDATE CASCADE,
    CONSTRAINT fk_employees_salary FOREIGN KEY (salary_id) REFERENCES public.employee_salaries(id) ON DELETE SET NULL ON UPDATE CASCADE,
    CONSTRAINT chk_employee_code_not_empty CHECK (employee_code <> ''),
    CONSTRAINT chk_first_name_not_empty CHECK (first_name <> ''),
    CONSTRAINT chk_last_name_not_empty CHECK (last_name <> ''),
    CONSTRAINT chk_email_not_empty CHECK (email <> ''),
    CONSTRAINT chk_password_hash_not_empty CHECK (password_hash <> '')
);

-- Disparador para marcas de tiempo en employees
CREATE TRIGGER trigger_employees_timestamp
    BEFORE INSERT OR UPDATE ON public.employees
    FOR EACH ROW EXECUTE FUNCTION update_timestamp();

-- Tabla pivote para la relación empleado-rol (permite que un empleado tenga múltiples roles).
CREATE TABLE IF NOT EXISTS public.employee_roles (
    id uuid NOT NULL DEFAULT uuid_generate_v4(),
    employee_id uuid NOT NULL,
    role_id uuid NOT NULL,
    CONSTRAINT employee_roles_pkey PRIMARY KEY (id),
    CONSTRAINT fk_employee FOREIGN KEY (employee_id) REFERENCES public.employees(id) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_role FOREIGN KEY (role_id) REFERENCES public.roles(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    UNIQUE (employee_id, role_id)
);

-- ========= SECCIÓN 3: ESTRUCTURA DE SOLICITUDES (SUPERTIPO/SUBTIPO) =========

-- 3.1: TABLA PADRE (SUPERTIPO)
-- Contiene datos comunes a todos los tipos de solicitudes.
CREATE TABLE IF NOT EXISTS public.requests (
    id uuid NOT NULL DEFAULT uuid_generate_v4(),
    employee_id uuid NOT NULL,
    request_type character varying(100) NOT NULL,
    status_id uuid NOT NULL,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone,
    CONSTRAINT requests_pkey PRIMARY KEY (id),
    CONSTRAINT fk_requests_employee FOREIGN KEY (employee_id) REFERENCES public.employees(id) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_requests_status FOREIGN KEY (status_id) REFERENCES public.request_statuses(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT chk_request_type_not_empty CHECK (request_type <> '')
);

-- Disparador para marcas de tiempo en requests
CREATE TRIGGER trigger_requests_timestamp
    BEFORE INSERT OR UPDATE ON public.requests
    FOR EACH ROW EXECUTE FUNCTION update_timestamp();

-- 3.2: TABLAS HIJAS (SUBTIPOS)
-- Contienen datos específicos para cada tipo de solicitud.

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
    CONSTRAINT fk_vacation_requests_id FOREIGN KEY (id) REFERENCES public.requests(id) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_vacation_requests_type FOREIGN KEY (vacation_type_id) REFERENCES public.vacation_types(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT chk_days_requested_positive CHECK (days_requested > 0),
    CONSTRAINT chk_end_date_after_start CHECK (end_date >= start_date),
    CONSTRAINT chk_payment_amount_non_negative CHECK (payment_amount >= 0 OR payment_amount IS NULL)
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
    CONSTRAINT fk_leave_requests_id FOREIGN KEY (id) REFERENCES public.requests(id) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_leave_requests_type FOREIGN KEY (leave_type_id) REFERENCES public.leave_types(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT chk_reason_not_empty CHECK (reason <> ''),
    CONSTRAINT chk_end_date_after_start CHECK (end_date >= start_date),
    CONSTRAINT chk_payment_amount_non_negative CHECK (payment_amount >= 0 OR payment_amount IS NULL)
);

CREATE TABLE IF NOT EXISTS public.certificate_requests (
    id uuid NOT NULL,
    certificate_type_id uuid NOT NULL,
    comments text,
    CONSTRAINT certificate_requests_pkey PRIMARY KEY (id),
    CONSTRAINT fk_certificate_requests_id FOREIGN KEY (id) REFERENCES public.requests(id) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_certificate_requests_type FOREIGN KEY (certificate_type_id) REFERENCES public.certificate_types(id) ON DELETE RESTRICT ON UPDATE CASCADE
);

-- ========= SECCIÓN 4: TABLAS DEPENDIENTES CON INTEGRIDAD REFERENCIAL =========

-- Almacena registros de aprobación, vinculados a la tabla padre 'requests'.
CREATE TABLE IF NOT EXISTS public.approvals (
    id uuid NOT NULL DEFAULT uuid_generate_v4(),
    request_id uuid NOT NULL,
    approver_id uuid NOT NULL,
    status_id uuid NOT NULL,
    comments text,
    approval_date timestamp without time zone DEFAULT now(),
    CONSTRAINT approvals_pkey PRIMARY KEY (id),
    CONSTRAINT fk_approvals_request FOREIGN KEY (request_id) REFERENCES public.requests(id) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_approvals_approver FOREIGN KEY (approver_id) REFERENCES public.employees(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_approvals_status FOREIGN KEY (status_id) REFERENCES public.request_statuses(id) ON DELETE RESTRICT ON UPDATE CASCADE
);

-- Almacena información sobre documentos adjuntos a cualquier solicitud.
CREATE TABLE IF NOT EXISTS public.attached_documents (
    id uuid NOT NULL DEFAULT uuid_generate_v4(),
    request_id uuid NOT NULL,
    file_name character varying(255) NOT NULL,
    file_url character varying(255) NOT NULL,
    file_type character varying(50),
    file_size integer,
    uploaded_by uuid NOT NULL,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone,
    CONSTRAINT attached_documents_pkey PRIMARY KEY (id),
    CONSTRAINT fk_attached_documents_request FOREIGN KEY (request_id) REFERENCES public.requests(id) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_attached_documents_uploader FOREIGN KEY (uploaded_by) REFERENCES public.employees(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT chk_file_name_not_empty CHECK (file_name <> ''),
    CONSTRAINT chk_file_url_not_empty CHECK (file_url <> ''),
    CONSTRAINT chk_file_size_non_negative CHECK (file_size >= 0 OR file_size IS NULL)
);

-- Disparador para marcas de tiempo en attached_documents
CREATE TRIGGER trigger_attached_documents_timestamp
    BEFORE INSERT OR UPDATE ON public.attached_documents
    FOR EACH ROW EXECUTE FUNCTION update_timestamp();

-- ========= SECCIÓN 5: TABLAS AUXILIARES Y DE AUDITORÍA =========

-- Gestiona el balance anual de días de vacaciones para cada empleado.
CREATE TABLE IF NOT EXISTS public.vacation_balances (
    id uuid NOT NULL DEFAULT uuid_generate_v4(),
    employee_id uuid NOT NULL,
    year integer NOT NULL,
    available_days integer NOT NULL,
    days_taken integer DEFAULT 0,
    CONSTRAINT vacation_balances_pkey PRIMARY KEY (id),
    CONSTRAINT fk_vacation_balances_employee FOREIGN KEY (employee_id) REFERENCES public.employees(id) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT chk_year_positive CHECK (year > 0),
    CONSTRAINT chk_available_days_non_negative CHECK (available_days >= 0),
    CONSTRAINT chk_days_taken_non_negative CHECK (days_taken >= 0),
    UNIQUE (employee_id, year)
);

-- Almacena el historial de auditoría de eventos importantes para cada empleado.
CREATE TABLE IF NOT EXISTS public.employee_history (
    id uuid NOT NULL DEFAULT uuid_generate_v4(),
    employee_id uuid NOT NULL,
    event character varying(255) NOT NULL,
    description text,
    performed_by uuid,
    event_date timestamp without time zone DEFAULT now(),
    CONSTRAINT employee_history_pkey PRIMARY KEY (id),
    CONSTRAINT fk_employee_history_employee FOREIGN KEY (employee_id) REFERENCES public.employees(id) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_employee_history_performed_by FOREIGN KEY (performed_by) REFERENCES public.employees(id) ON DELETE SET NULL ON UPDATE CASCADE,
    CONSTRAINT chk_event_not_empty CHECK (event <> '')
);

-- Almacena notificaciones dentro de la aplicación para los usuarios.
CREATE TABLE IF NOT EXISTS public.notifications (
    id uuid NOT NULL DEFAULT uuid_generate_v4(),
    recipient_id uuid NOT NULL,
    message text NOT NULL,
    is_read boolean DEFAULT false,
    related_url character varying(255),
    sent_date timestamp without time zone DEFAULT now(),
    is_deleted boolean DEFAULT false,
    CONSTRAINT notifications_pkey PRIMARY KEY (id),
    CONSTRAINT fk_notifications_recipient FOREIGN KEY (recipient_id) REFERENCES public.employees(id) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT chk_message_not_empty CHECK (message <> '')
);

-- ========= FIN DEL SCRIPT =========