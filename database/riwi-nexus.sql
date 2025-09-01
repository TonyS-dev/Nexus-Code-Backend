/*
 Navicat Premium Dump SQL

 Source Server         : Nexus Prod DB (Docker)
 Source Server Type    : PostgreSQL
 Source Server Version : 150013 (150013)
 Source Host           : localhost:5433
 Source Catalog        : riwi_nexus_db
 Source Schema         : public

 Target Server Type    : PostgreSQL
 Target Server Version : 150013 (150013)
 File Encoding         : 65001

 Date: 31/08/2025 21:55:26
*/


-- ----------------------------
-- Table structure for access_levels
-- ----------------------------
DROP TABLE IF EXISTS "public"."access_levels";
CREATE TABLE "public"."access_levels" (
  "id" uuid NOT NULL DEFAULT uuid_generate_v4(),
  "name" varchar(100) COLLATE "pg_catalog"."default" NOT NULL,
  "description" text COLLATE "pg_catalog"."default"
)
;
ALTER TABLE "public"."access_levels" OWNER TO "riwi_nexus_user";

-- ----------------------------
-- Records of access_levels
-- ----------------------------
BEGIN;
INSERT INTO "public"."access_levels" ("id", "name", "description") VALUES ('7cfa2e89-2590-4b44-a379-365e69b6ee9a', 'User', 'Basic user access');
INSERT INTO "public"."access_levels" ("id", "name", "description") VALUES ('29963268-444d-456d-9f6c-fd4f4f476b85', 'Admin', 'Full system access');
COMMIT;

-- ----------------------------
-- Table structure for approvals
-- ----------------------------
DROP TABLE IF EXISTS "public"."approvals";
CREATE TABLE "public"."approvals" (
  "id" uuid NOT NULL DEFAULT uuid_generate_v4(),
  "request_id" uuid NOT NULL,
  "approver_id" uuid NOT NULL,
  "status_id" uuid NOT NULL,
  "comments" text COLLATE "pg_catalog"."default",
  "approval_date" timestamp(6) DEFAULT now()
)
;
ALTER TABLE "public"."approvals" OWNER TO "riwi_nexus_user";

-- ----------------------------
-- Records of approvals
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for attached_documents
-- ----------------------------
DROP TABLE IF EXISTS "public"."attached_documents";
CREATE TABLE "public"."attached_documents" (
  "id" uuid NOT NULL DEFAULT uuid_generate_v4(),
  "request_id" uuid NOT NULL,
  "file_name" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "file_url" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "file_type" varchar(50) COLLATE "pg_catalog"."default",
  "file_size_bytes" int4,
  "uploaded_by_id" uuid NOT NULL,
  "created_at" timestamp(6),
  "updated_at" timestamp(6)
)
;
ALTER TABLE "public"."attached_documents" OWNER TO "riwi_nexus_user";

-- ----------------------------
-- Records of attached_documents
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for certificate_requests
-- ----------------------------
DROP TABLE IF EXISTS "public"."certificate_requests";
CREATE TABLE "public"."certificate_requests" (
  "id" uuid NOT NULL,
  "certificate_type_id" uuid NOT NULL,
  "comments" text COLLATE "pg_catalog"."default"
)
;
ALTER TABLE "public"."certificate_requests" OWNER TO "riwi_nexus_user";

-- ----------------------------
-- Records of certificate_requests
-- ----------------------------
BEGIN;
INSERT INTO "public"."certificate_requests" ("id", "certificate_type_id", "comments") VALUES ('665ffab0-8484-40ad-acdc-4bccb548b2a6', '8cfd8871-b9a3-4260-98a9-49fe738796ec', NULL);
INSERT INTO "public"."certificate_requests" ("id", "certificate_type_id", "comments") VALUES ('842d6f8e-6da5-4394-bd44-25b273c677d6', '1b072157-1102-4a12-8251-921959032528', 'asdas');
INSERT INTO "public"."certificate_requests" ("id", "certificate_type_id", "comments") VALUES ('f4d7d985-3c5e-42fc-ae63-052c6d6570a6', '23272257-374a-4ee9-99b8-4f5ba8784bbb', NULL);
INSERT INTO "public"."certificate_requests" ("id", "certificate_type_id", "comments") VALUES ('eda8a0e2-dd63-436f-8fe0-694f8e901e82', '1b072157-1102-4a12-8251-921959032528', 'lo necito');
INSERT INTO "public"."certificate_requests" ("id", "certificate_type_id", "comments") VALUES ('1f4669c4-43d9-4c42-94ff-8ca19f4b635f', '44e9d98b-3d23-4bf8-a001-10362be5f9a2', NULL);
INSERT INTO "public"."certificate_requests" ("id", "certificate_type_id", "comments") VALUES ('5f7a0f67-83cd-40a0-9f50-b83e8c0aed2f', '44e9d98b-3d23-4bf8-a001-10362be5f9a2', NULL);
COMMIT;

-- ----------------------------
-- Table structure for certificate_types
-- ----------------------------
DROP TABLE IF EXISTS "public"."certificate_types";
CREATE TABLE "public"."certificate_types" (
  "id" uuid NOT NULL DEFAULT uuid_generate_v4(),
  "name" varchar(100) COLLATE "pg_catalog"."default" NOT NULL
)
;
ALTER TABLE "public"."certificate_types" OWNER TO "riwi_nexus_user";

-- ----------------------------
-- Records of certificate_types
-- ----------------------------
BEGIN;
INSERT INTO "public"."certificate_types" ("id", "name") VALUES ('6f78c592-804c-4156-af48-d2b57a3c421e', 'Employment Certificate');
INSERT INTO "public"."certificate_types" ("id", "name") VALUES ('ada638ba-067f-4c9e-9b3c-90612f321dcd', 'Income and Withholdings Certificate');
INSERT INTO "public"."certificate_types" ("id", "name") VALUES ('8b9dd80d-8e71-4c72-9390-51ccc8b36089', 'Vacation Statement');
INSERT INTO "public"."certificate_types" ("id", "name") VALUES ('94356288-d8e7-4df6-99cc-a9d5dd6d92b8', 'Severance Certificate');
INSERT INTO "public"."certificate_types" ("id", "name") VALUES ('71b1941a-88de-4989-bf2a-98a3c79b5393', 'Service Time Certificate');
INSERT INTO "public"."certificate_types" ("id", "name") VALUES ('44e9d98b-3d23-4bf8-a001-10362be5f9a2', 'Clearance Certificate');
INSERT INTO "public"."certificate_types" ("id", "name") VALUES ('8cfd8871-b9a3-4260-98a9-49fe738796ec', 'EPS Affiliation Certificate');
INSERT INTO "public"."certificate_types" ("id", "name") VALUES ('23272257-374a-4ee9-99b8-4f5ba8784bbb', 'Pension Affiliation Certificate');
INSERT INTO "public"."certificate_types" ("id", "name") VALUES ('1b072157-1102-4a12-8251-921959032528', 'ARL Affiliation Certificate');
INSERT INTO "public"."certificate_types" ("id", "name") VALUES ('2e58a26d-058c-45cd-8e44-2b3d90586b6d', 'Position Certificate');
INSERT INTO "public"."certificate_types" ("id", "name") VALUES ('6e241312-bdec-4bec-a475-91528288882f', 'Salary Certificate');
INSERT INTO "public"."certificate_types" ("id", "name") VALUES ('9ceb0f70-2e23-4d04-9596-0d90b98ed6d3', 'Job Recommendation Letter');
COMMIT;

-- ----------------------------
-- Table structure for employee_histories
-- ----------------------------
DROP TABLE IF EXISTS "public"."employee_histories";
CREATE TABLE "public"."employee_histories" (
  "id" uuid NOT NULL DEFAULT uuid_generate_v4(),
  "employee_id" uuid NOT NULL,
  "event" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "description" text COLLATE "pg_catalog"."default",
  "performed_by_id" uuid,
  "event_date" timestamp(6) DEFAULT now()
)
;
ALTER TABLE "public"."employee_histories" OWNER TO "riwi_nexus_user";

-- ----------------------------
-- Records of employee_histories
-- ----------------------------
BEGIN;
INSERT INTO "public"."employee_histories" ("id", "employee_id", "event", "description", "performed_by_id", "event_date") VALUES ('7cacffee-730c-4368-8ce0-898964de6538', '52784b0d-6933-4717-acd7-46f940ab8579', 'HIRE', 'CEO hired and started position', NULL, '2022-01-10 09:00:00');
INSERT INTO "public"."employee_histories" ("id", "employee_id", "event", "description", "performed_by_id", "event_date") VALUES ('7696f353-5cdc-4a1c-ac39-7dadc5f80be6', '4a09ee7b-e188-4cfa-a50a-90c87d979566', 'HIRE', 'Learning Leader hired and started position', '52784b0d-6933-4717-acd7-46f940ab8579', '2022-06-15 09:00:00');
INSERT INTO "public"."employee_histories" ("id", "employee_id", "event", "description", "performed_by_id", "event_date") VALUES ('94cf0d79-3a5d-44e6-9533-9aa6181173b9', 'e383a839-60a3-4662-9e3f-1ff2c6c0a4d9', 'HIRE', 'Developer hired and started position', '52784b0d-6933-4717-acd7-46f940ab8579', '2024-02-01 09:00:00');
INSERT INTO "public"."employee_histories" ("id", "employee_id", "event", "description", "performed_by_id", "event_date") VALUES ('40078dae-797f-4ec9-b470-15096c735303', '99cbbd5d-c6b2-4a6d-ac0d-35d721f4ef6c', 'HIRE', 'Developer hired and started position', '52784b0d-6933-4717-acd7-46f940ab8579', '2023-03-01 09:00:00');
INSERT INTO "public"."employee_histories" ("id", "employee_id", "event", "description", "performed_by_id", "event_date") VALUES ('188fe2e8-62f1-428e-9aba-9cbe62998ce7', 'e383a839-60a3-4662-9e3f-1ff2c6c0a4d9', 'PROFILE_UPDATE', 'Employee profile information updated', '52784b0d-6933-4717-acd7-46f940ab8579', '2025-08-28 16:44:05');
INSERT INTO "public"."employee_histories" ("id", "employee_id", "event", "description", "performed_by_id", "event_date") VALUES ('5d02ab15-2385-459d-8524-44359f2bd5b7', '52784b0d-6933-4717-acd7-46f940ab8579', 'HIRE', 'CEO hired and started position', NULL, '2022-01-10 09:00:00');
INSERT INTO "public"."employee_histories" ("id", "employee_id", "event", "description", "performed_by_id", "event_date") VALUES ('30f00ebc-2ebe-4821-a57d-1466acc5daca', '4a09ee7b-e188-4cfa-a50a-90c87d979566', 'HIRE', 'Learning Leader hired and started position', '52784b0d-6933-4717-acd7-46f940ab8579', '2022-06-15 09:00:00');
INSERT INTO "public"."employee_histories" ("id", "employee_id", "event", "description", "performed_by_id", "event_date") VALUES ('b2bd9947-e9de-4dec-8957-a6036c807d0e', 'e383a839-60a3-4662-9e3f-1ff2c6c0a4d9', 'HIRE', 'Developer hired and started position', '52784b0d-6933-4717-acd7-46f940ab8579', '2024-02-01 09:00:00');
INSERT INTO "public"."employee_histories" ("id", "employee_id", "event", "description", "performed_by_id", "event_date") VALUES ('8c03a46a-0345-4ccb-a321-f231804b7076', '99cbbd5d-c6b2-4a6d-ac0d-35d721f4ef6c', 'HIRE', 'Developer hired and started position', '52784b0d-6933-4717-acd7-46f940ab8579', '2023-03-01 09:00:00');
INSERT INTO "public"."employee_histories" ("id", "employee_id", "event", "description", "performed_by_id", "event_date") VALUES ('f4430a0c-656e-4eeb-a8f9-024eacded95a', 'e383a839-60a3-4662-9e3f-1ff2c6c0a4d9', 'PROFILE_UPDATE', 'Employee profile information updated', '52784b0d-6933-4717-acd7-46f940ab8579', '2025-08-28 16:44:05');
INSERT INTO "public"."employee_histories" ("id", "employee_id", "event", "description", "performed_by_id", "event_date") VALUES ('0d0ad152-202a-4e36-bec6-6f8cb5b2bc47', '4a09ee7b-e188-4cfa-a50a-90c87d979566', 'SALARY_INCREASE', 'Annual salary review - performance increase', '52784b0d-6933-4717-acd7-46f940ab8579', '2024-01-01 10:00:00');
INSERT INTO "public"."employee_histories" ("id", "employee_id", "event", "description", "performed_by_id", "event_date") VALUES ('afe77f6f-b89b-4532-ba42-320651def310', 'e383a839-60a3-4662-9e3f-1ff2c6c0a4d9', 'SALARY_INCREASE', '6-month performance review - salary adjustment', '52784b0d-6933-4717-acd7-46f940ab8579', '2024-08-01 10:00:00');
INSERT INTO "public"."employee_histories" ("id", "employee_id", "event", "description", "performed_by_id", "event_date") VALUES ('4c24f747-d3ce-4d5b-8990-cb0a46883cef', '99cbbd5d-c6b2-4a6d-ac0d-35d721f4ef6c', 'SALARY_INCREASE', 'Annual salary review - performance increase', '52784b0d-6933-4717-acd7-46f940ab8579', '2024-01-01 10:00:00');
INSERT INTO "public"."employee_histories" ("id", "employee_id", "event", "description", "performed_by_id", "event_date") VALUES ('d7389316-3f5f-46cd-ace2-691c4b52e94e', '4a09ee7b-e188-4cfa-a50a-90c87d979566', 'SALARY_INCREASE', 'Annual salary review - performance increase', '52784b0d-6933-4717-acd7-46f940ab8579', '2024-01-01 10:00:00');
INSERT INTO "public"."employee_histories" ("id", "employee_id", "event", "description", "performed_by_id", "event_date") VALUES ('8d18b6fb-9376-4db2-be4d-0c201dc01ce0', 'e383a839-60a3-4662-9e3f-1ff2c6c0a4d9', 'SALARY_INCREASE', '6-month performance review - salary adjustment', '52784b0d-6933-4717-acd7-46f940ab8579', '2024-08-01 10:00:00');
INSERT INTO "public"."employee_histories" ("id", "employee_id", "event", "description", "performed_by_id", "event_date") VALUES ('e5a60946-a826-4ce2-9096-10096a82f4fc', '99cbbd5d-c6b2-4a6d-ac0d-35d721f4ef6c', 'SALARY_INCREASE', 'Annual salary review - performance increase', '52784b0d-6933-4717-acd7-46f940ab8579', '2024-01-01 10:00:00');
COMMIT;

-- ----------------------------
-- Table structure for employee_roles
-- ----------------------------
DROP TABLE IF EXISTS "public"."employee_roles";
CREATE TABLE "public"."employee_roles" (
  "employee_id" uuid NOT NULL,
  "role_id" uuid NOT NULL
)
;
ALTER TABLE "public"."employee_roles" OWNER TO "riwi_nexus_user";

-- ----------------------------
-- Records of employee_roles
-- ----------------------------
BEGIN;
INSERT INTO "public"."employee_roles" ("employee_id", "role_id") VALUES ('52784b0d-6933-4717-acd7-46f940ab8579', '7b3c4658-4ed4-454a-941a-84feb6943a7c');
INSERT INTO "public"."employee_roles" ("employee_id", "role_id") VALUES ('4a09ee7b-e188-4cfa-a50a-90c87d979566', '85c57857-5007-4144-a601-53278a4f96b6');
INSERT INTO "public"."employee_roles" ("employee_id", "role_id") VALUES ('e383a839-60a3-4662-9e3f-1ff2c6c0a4d9', '01896d9a-1bfe-4607-ae03-7b10eb24dfee');
INSERT INTO "public"."employee_roles" ("employee_id", "role_id") VALUES ('99cbbd5d-c6b2-4a6d-ac0d-35d721f4ef6c', '01896d9a-1bfe-4607-ae03-7b10eb24dfee');
INSERT INTO "public"."employee_roles" ("employee_id", "role_id") VALUES ('38962d4d-0315-4595-b047-953b72f5b39a', '01896d9a-1bfe-4607-ae03-7b10eb24dfee');
INSERT INTO "public"."employee_roles" ("employee_id", "role_id") VALUES ('0e4a5795-c4cb-474f-b06f-b8bc71bf52ba', '65fb5f91-a47d-4dd7-8f95-77c7831b56d0');
INSERT INTO "public"."employee_roles" ("employee_id", "role_id") VALUES ('fdb3c34c-676b-49d5-a5a6-bbcc4b62f9f8', '01896d9a-1bfe-4607-ae03-7b10eb24dfee');
INSERT INTO "public"."employee_roles" ("employee_id", "role_id") VALUES ('067422dc-9e4a-4e0a-a2db-8d251634c7ce', '01896d9a-1bfe-4607-ae03-7b10eb24dfee');
COMMIT;

-- ----------------------------
-- Table structure for employee_salaries
-- ----------------------------
DROP TABLE IF EXISTS "public"."employee_salaries";
CREATE TABLE "public"."employee_salaries" (
  "id" uuid NOT NULL DEFAULT uuid_generate_v4(),
  "employee_id" uuid NOT NULL,
  "salary_amount" numeric(12,2) NOT NULL,
  "effective_date" date NOT NULL,
  "created_at" timestamp(6),
  "updated_at" timestamp(6)
)
;
ALTER TABLE "public"."employee_salaries" OWNER TO "riwi_nexus_user";

-- ----------------------------
-- Records of employee_salaries
-- ----------------------------
BEGIN;
INSERT INTO "public"."employee_salaries" ("id", "employee_id", "salary_amount", "effective_date", "created_at", "updated_at") VALUES ('69794dcd-6106-49bf-a1f2-b7b2dc2dee9d', '52784b0d-6933-4717-acd7-46f940ab8579', 15000000.00, '2022-01-10', '2025-08-29 00:35:17.727497', NULL);
INSERT INTO "public"."employee_salaries" ("id", "employee_id", "salary_amount", "effective_date", "created_at", "updated_at") VALUES ('b390bf93-ccaa-442f-af4f-6deb2683d42c', '4a09ee7b-e188-4cfa-a50a-90c87d979566', 8000000.00, '2022-06-15', '2025-08-29 00:35:17.727497', NULL);
INSERT INTO "public"."employee_salaries" ("id", "employee_id", "salary_amount", "effective_date", "created_at", "updated_at") VALUES ('8a8c710b-6df3-4c29-a173-be8c154450e5', 'e383a839-60a3-4662-9e3f-1ff2c6c0a4d9', 4500000.00, '2024-02-01', '2025-08-29 00:35:17.727497', NULL);
INSERT INTO "public"."employee_salaries" ("id", "employee_id", "salary_amount", "effective_date", "created_at", "updated_at") VALUES ('8e8862b0-7b3f-401b-90b3-803141f59275', '99cbbd5d-c6b2-4a6d-ac0d-35d721f4ef6c', 4200000.00, '2023-03-01', '2025-08-29 00:35:17.727497', NULL);
INSERT INTO "public"."employee_salaries" ("id", "employee_id", "salary_amount", "effective_date", "created_at", "updated_at") VALUES ('adc35219-2ce9-40f0-9fa9-b2294cbcbdc7', '52784b0d-6933-4717-acd7-46f940ab8579', 15000000.00, '2022-01-10', '2025-08-29 00:39:21.217131', NULL);
INSERT INTO "public"."employee_salaries" ("id", "employee_id", "salary_amount", "effective_date", "created_at", "updated_at") VALUES ('860ee7ad-b099-40b9-89ff-14eeb19efd6b', '4a09ee7b-e188-4cfa-a50a-90c87d979566', 8000000.00, '2022-06-15', '2025-08-29 00:39:21.217131', NULL);
INSERT INTO "public"."employee_salaries" ("id", "employee_id", "salary_amount", "effective_date", "created_at", "updated_at") VALUES ('c70b73ae-8dc9-4b44-a004-ee84ce733a0e', 'e383a839-60a3-4662-9e3f-1ff2c6c0a4d9', 4500000.00, '2024-02-01', '2025-08-29 00:39:21.217131', NULL);
INSERT INTO "public"."employee_salaries" ("id", "employee_id", "salary_amount", "effective_date", "created_at", "updated_at") VALUES ('0ba088f2-24c1-4df6-bd6a-372cb2a13383', '99cbbd5d-c6b2-4a6d-ac0d-35d721f4ef6c', 4200000.00, '2023-03-01', '2025-08-29 00:39:21.217131', NULL);
INSERT INTO "public"."employee_salaries" ("id", "employee_id", "salary_amount", "effective_date", "created_at", "updated_at") VALUES ('7085cf84-703b-4b0c-a909-caf9c45829e7', '52784b0d-6933-4717-acd7-46f940ab8579', 15000000.00, '2022-01-10', '2025-08-29 00:40:43.442113', NULL);
INSERT INTO "public"."employee_salaries" ("id", "employee_id", "salary_amount", "effective_date", "created_at", "updated_at") VALUES ('d302658a-881e-48ef-b90e-870ae57c5f07', '4a09ee7b-e188-4cfa-a50a-90c87d979566', 8000000.00, '2022-06-15', '2025-08-29 00:40:43.442113', NULL);
INSERT INTO "public"."employee_salaries" ("id", "employee_id", "salary_amount", "effective_date", "created_at", "updated_at") VALUES ('24966016-de21-42c9-b9de-c6cefdfc0891', 'e383a839-60a3-4662-9e3f-1ff2c6c0a4d9', 4500000.00, '2024-02-01', '2025-08-29 00:40:43.442113', NULL);
INSERT INTO "public"."employee_salaries" ("id", "employee_id", "salary_amount", "effective_date", "created_at", "updated_at") VALUES ('f63304ac-378e-4c59-b898-6d1c78551553', '99cbbd5d-c6b2-4a6d-ac0d-35d721f4ef6c', 4200000.00, '2023-03-01', '2025-08-29 00:40:43.442113', NULL);
INSERT INTO "public"."employee_salaries" ("id", "employee_id", "salary_amount", "effective_date", "created_at", "updated_at") VALUES ('750d221a-c449-4ad0-acff-ad547cd256ff', '4a09ee7b-e188-4cfa-a50a-90c87d979566', 8500000.00, '2024-01-01', '2025-08-29 00:51:27.834528', NULL);
INSERT INTO "public"."employee_salaries" ("id", "employee_id", "salary_amount", "effective_date", "created_at", "updated_at") VALUES ('16991b30-74fa-4a08-bbca-b0d0a06c3bf5', 'e383a839-60a3-4662-9e3f-1ff2c6c0a4d9', 5000000.00, '2024-08-01', '2025-08-29 00:51:27.834528', NULL);
INSERT INTO "public"."employee_salaries" ("id", "employee_id", "salary_amount", "effective_date", "created_at", "updated_at") VALUES ('0520a8d9-65d4-4a89-864a-597c629d55b1', '99cbbd5d-c6b2-4a6d-ac0d-35d721f4ef6c', 4800000.00, '2024-01-01', '2025-08-29 00:51:27.834528', NULL);
INSERT INTO "public"."employee_salaries" ("id", "employee_id", "salary_amount", "effective_date", "created_at", "updated_at") VALUES ('bf7aa485-dfd3-4020-a239-97f1b4931f05', '4a09ee7b-e188-4cfa-a50a-90c87d979566', 8500000.00, '2024-01-01', '2025-08-29 00:53:04.267324', NULL);
INSERT INTO "public"."employee_salaries" ("id", "employee_id", "salary_amount", "effective_date", "created_at", "updated_at") VALUES ('231b0033-39ad-48c6-96ee-8b557021bc15', 'e383a839-60a3-4662-9e3f-1ff2c6c0a4d9', 5000000.00, '2024-08-01', '2025-08-29 00:53:04.267324', NULL);
INSERT INTO "public"."employee_salaries" ("id", "employee_id", "salary_amount", "effective_date", "created_at", "updated_at") VALUES ('e8ff480c-e730-495d-9301-7a2a6f342679', '99cbbd5d-c6b2-4a6d-ac0d-35d721f4ef6c', 4800000.00, '2024-01-01', '2025-08-29 00:53:04.267324', NULL);
INSERT INTO "public"."employee_salaries" ("id", "employee_id", "salary_amount", "effective_date", "created_at", "updated_at") VALUES ('3d65bb82-4f05-489d-be80-dc7938d1fe30', '0e4a5795-c4cb-474f-b06f-b8bc71bf52ba', 100000000.00, '2025-08-30', '2025-08-29 21:02:29.667612', NULL);
COMMIT;

-- ----------------------------
-- Table structure for employee_statuses
-- ----------------------------
DROP TABLE IF EXISTS "public"."employee_statuses";
CREATE TABLE "public"."employee_statuses" (
  "id" uuid NOT NULL DEFAULT uuid_generate_v4(),
  "name" varchar(100) COLLATE "pg_catalog"."default" NOT NULL
)
;
ALTER TABLE "public"."employee_statuses" OWNER TO "riwi_nexus_user";

-- ----------------------------
-- Records of employee_statuses
-- ----------------------------
BEGIN;
INSERT INTO "public"."employee_statuses" ("id", "name") VALUES ('f0f0c09c-6f18-44fd-a1c2-cd5116658a81', 'Active');
INSERT INTO "public"."employee_statuses" ("id", "name") VALUES ('b7a073fe-a356-4351-b4dd-6a17000432a8', 'Inactive');
INSERT INTO "public"."employee_statuses" ("id", "name") VALUES ('485ebce3-6006-4634-b60e-f4b1981517f2', 'On Vacation');
INSERT INTO "public"."employee_statuses" ("id", "name") VALUES ('2a842cc9-49ba-47a1-8708-26aa7a56b00d', 'On Leave');
INSERT INTO "public"."employee_statuses" ("id", "name") VALUES ('cc46522b-0731-46c1-9fd8-bf06dc0f8bd0', 'Suspended');
INSERT INTO "public"."employee_statuses" ("id", "name") VALUES ('5fc9a9c1-d4a4-4c0a-82b9-986a359e6065', 'Terminated');
COMMIT;

-- ----------------------------
-- Table structure for employees
-- ----------------------------
DROP TABLE IF EXISTS "public"."employees";
CREATE TABLE "public"."employees" (
  "id" uuid NOT NULL DEFAULT uuid_generate_v4(),
  "employee_code" varchar(20) COLLATE "pg_catalog"."default" NOT NULL,
  "first_name" varchar(40) COLLATE "pg_catalog"."default" NOT NULL,
  "middle_name" varchar(40) COLLATE "pg_catalog"."default",
  "last_name" varchar(40) COLLATE "pg_catalog"."default" NOT NULL,
  "second_last_name" varchar(40) COLLATE "pg_catalog"."default",
  "email" varchar(60) COLLATE "pg_catalog"."default" NOT NULL,
  "password_hash" varchar(80) COLLATE "pg_catalog"."default" NOT NULL,
  "phone" varchar(20) COLLATE "pg_catalog"."default" NOT NULL,
  "birth_date" date NOT NULL,
  "hire_date" date NOT NULL,
  "identification_type_id" uuid NOT NULL,
  "identification_number" varchar(50) COLLATE "pg_catalog"."default" NOT NULL,
  "manager_id" uuid,
  "headquarters_id" uuid NOT NULL,
  "gender_id" uuid NOT NULL,
  "status_id" uuid NOT NULL,
  "access_level_id" uuid NOT NULL,
  "created_at" timestamp(6),
  "updated_at" timestamp(6),
  "is_deleted" bool DEFAULT false
)
;
ALTER TABLE "public"."employees" OWNER TO "riwi_nexus_user";

-- ----------------------------
-- Records of employees
-- ----------------------------
BEGIN;
INSERT INTO "public"."employees" ("id", "employee_code", "first_name", "middle_name", "last_name", "second_last_name", "email", "password_hash", "phone", "birth_date", "hire_date", "identification_type_id", "identification_number", "manager_id", "headquarters_id", "gender_id", "status_id", "access_level_id", "created_at", "updated_at", "is_deleted") VALUES ('e383a839-60a3-4662-9e3f-1ff2c6c0a4d9', 'EMP-001', 'Ana', 'María', 'Lopez', 'Castro', 'ana@nexus.com', '$2b$10$T6a0Xu.EUTQww3S1aUT0Oute94zoD7ihhLVpM.y3u/zn/kHo1.Sme', '1112223334444', '1990-11-25', '2024-02-01', '6d65e299-1497-4aa8-9951-8fec24e1fc18', '1122233444', '52784b0d-6933-4717-acd7-46f940ab8579', 'a5208edf-dff8-4f77-8236-8c413ef6a638', '3b0cfae3-bf10-4e87-93e3-7fe5b213c5a8', 'f0f0c09c-6f18-44fd-a1c2-cd5116658a81', '7cfa2e89-2590-4b44-a379-365e69b6ee9a', '2025-08-28 16:18:33.949394', '2025-08-28 16:44:05.724367', 'f');
INSERT INTO "public"."employees" ("id", "employee_code", "first_name", "middle_name", "last_name", "second_last_name", "email", "password_hash", "phone", "birth_date", "hire_date", "identification_type_id", "identification_number", "manager_id", "headquarters_id", "gender_id", "status_id", "access_level_id", "created_at", "updated_at", "is_deleted") VALUES ('0e4a5795-c4cb-474f-b06f-b8bc71bf52ba', 'RIWI1123', 'Javier', NULL, 'Ariza', NULL, 'javier@nexus.com', '$2b$10$Wpn5XZ57QrZUhKGwH3Kq0.rdnNIfLiM2UvXfqxoHdLLYvJK1eT0Ki', '+57 3012669349', '2000-08-12', '2025-08-29', 'bcef37b7-05c4-4392-88b5-522487400f7d', '1233456863', NULL, 'a5208edf-dff8-4f77-8236-8c413ef6a638', 'a479f98b-7972-4f82-972e-5849d422e3c0', 'cc46522b-0731-46c1-9fd8-bf06dc0f8bd0', '29963268-444d-456d-9f6c-fd4f4f476b85', '2025-08-29 21:02:29.667612', '2025-08-31 19:10:19.194192', 'f');
INSERT INTO "public"."employees" ("id", "employee_code", "first_name", "middle_name", "last_name", "second_last_name", "email", "password_hash", "phone", "birth_date", "hire_date", "identification_type_id", "identification_number", "manager_id", "headquarters_id", "gender_id", "status_id", "access_level_id", "created_at", "updated_at", "is_deleted") VALUES ('067422dc-9e4a-4e0a-a2db-8d251634c7ce', 'ANTO-001', 'Antonio', 'Carlos', 'Santiago', 'Rodriguez', 'santiagor.acarlos@gmail.com', '$2b$10$891rCbepb0LX6en.yVpa5e0WjhKw4DfocAQuWr4JcBdT7ueljxVmi', '+57 311 861 2730', '2000-11-30', '2025-08-31', '6d65e299-1497-4aa8-9951-8fec24e1fc18', '1192796292', NULL, 'a5208edf-dff8-4f77-8236-8c413ef6a638', 'a479f98b-7972-4f82-972e-5849d422e3c0', 'f0f0c09c-6f18-44fd-a1c2-cd5116658a81', '29963268-444d-456d-9f6c-fd4f4f476b85', '2025-08-31 23:29:43.904', '2025-09-01 01:49:08.143989', 'f');
INSERT INTO "public"."employees" ("id", "employee_code", "first_name", "middle_name", "last_name", "second_last_name", "email", "password_hash", "phone", "birth_date", "hire_date", "identification_type_id", "identification_number", "manager_id", "headquarters_id", "gender_id", "status_id", "access_level_id", "created_at", "updated_at", "is_deleted") VALUES ('4a09ee7b-e188-4cfa-a50a-90c87d979566', 'MAN-001', 'Moises', NULL, 'Pereira', NULL, 'moises@nexus.com', '$2b$10$5HiUZhOyntv2W7aU7dg.WOlNq0nwC9931PtjEcTP1O3ohGi8VrqCG', '+57 301 234 5678', '1985-03-20', '2022-06-15', '6d65e299-1497-4aa8-9951-8fec24e1fc18', '23456789', '52784b0d-6933-4717-acd7-46f940ab8579', 'a5208edf-dff8-4f77-8236-8c413ef6a638', 'a479f98b-7972-4f82-972e-5849d422e3c0', 'f0f0c09c-6f18-44fd-a1c2-cd5116658a81', '7cfa2e89-2590-4b44-a379-365e69b6ee9a', '2025-08-28 16:16:39.37736', '2025-08-29 00:53:04.067944', 'f');
INSERT INTO "public"."employees" ("id", "employee_code", "first_name", "middle_name", "last_name", "second_last_name", "email", "password_hash", "phone", "birth_date", "hire_date", "identification_type_id", "identification_number", "manager_id", "headquarters_id", "gender_id", "status_id", "access_level_id", "created_at", "updated_at", "is_deleted") VALUES ('99cbbd5d-c6b2-4a6d-ac0d-35d721f4ef6c', 'EMP-002', 'Carlos', NULL, 'Ruiz', NULL, 'carlos@nexus.com', '$2b$10$DLbmh27lJ2w168V8TMqR5uhLURUMrRTJxHLK6r3iJ3qaftZijdKXq', '+57 302 345 6789', '1992-08-10', '2023-03-01', '6d65e299-1497-4aa8-9951-8fec24e1fc18', '34567890', '52784b0d-6933-4717-acd7-46f940ab8579', 'a5208edf-dff8-4f77-8236-8c413ef6a638', 'a479f98b-7972-4f82-972e-5849d422e3c0', 'f0f0c09c-6f18-44fd-a1c2-cd5116658a81', '7cfa2e89-2590-4b44-a379-365e69b6ee9a', '2025-08-28 17:00:38.125549', '2025-08-29 00:53:04.152051', 'f');
INSERT INTO "public"."employees" ("id", "employee_code", "first_name", "middle_name", "last_name", "second_last_name", "email", "password_hash", "phone", "birth_date", "hire_date", "identification_type_id", "identification_number", "manager_id", "headquarters_id", "gender_id", "status_id", "access_level_id", "created_at", "updated_at", "is_deleted") VALUES ('38962d4d-0315-4595-b047-953b72f5b39a', 'RIWI-NEXUS-001', 'Juan', 'Ernadez', 'Perez', 'Pacheco', 'juan@nexus.com', '$2b$10$wJuECIAiXOSnb0GyWEarVucTduLGfIsiO7FxDvHMofFB8XyMzjzU2', '+57 3018559386', '2000-08-12', '2025-08-29', 'bcef37b7-05c4-4392-88b5-522487400f7d', '12223553425', '52784b0d-6933-4717-acd7-46f940ab8579', 'a5208edf-dff8-4f77-8236-8c413ef6a638', 'a479f98b-7972-4f82-972e-5849d422e3c0', 'f0f0c09c-6f18-44fd-a1c2-cd5116658a81', '7cfa2e89-2590-4b44-a379-365e69b6ee9a', '2025-08-29 20:36:50.01251', NULL, 'f');
INSERT INTO "public"."employees" ("id", "employee_code", "first_name", "middle_name", "last_name", "second_last_name", "email", "password_hash", "phone", "birth_date", "hire_date", "identification_type_id", "identification_number", "manager_id", "headquarters_id", "gender_id", "status_id", "access_level_id", "created_at", "updated_at", "is_deleted") VALUES ('fdb3c34c-676b-49d5-a5a6-bbcc4b62f9f8', 'as', 'as First Name1', 'as Middle Name1', 'as Last Name1', 'as Second Last Name1', 'as@mail.com1', '$2b$10$zHNUYsBm6zzFqnCBMWNKDe.9Sm955OD6YGSbzM.eWm5ZgHxgAq892', '3123123121', '2025-08-10', '2025-10-02', 'bcef37b7-05c4-4392-88b5-522487400f7d', '213123121', '0e4a5795-c4cb-474f-b06f-b8bc71bf52ba', '0c682a62-95a4-4b8c-be1e-fbec4e9b5eba', 'b0bb8fc7-03ad-4fb1-bbd3-62930d8e9949', '485ebce3-6006-4634-b60e-f4b1981517f2', '7cfa2e89-2590-4b44-a379-365e69b6ee9a', '2025-08-31 00:53:49.52751', '2025-08-31 14:33:32.583572', 't');
INSERT INTO "public"."employees" ("id", "employee_code", "first_name", "middle_name", "last_name", "second_last_name", "email", "password_hash", "phone", "birth_date", "hire_date", "identification_type_id", "identification_number", "manager_id", "headquarters_id", "gender_id", "status_id", "access_level_id", "created_at", "updated_at", "is_deleted") VALUES ('52784b0d-6933-4717-acd7-46f940ab8579', 'CEO-001', 'Ceo', NULL, 'User', NULL, 'ceo@nexus.com', '$2b$10$fd4mZEr1ey0yHc27Cj8tSuzmH1U1ViieCeE.XWa1GKMd8BM5lgD.e', '+57 300 123 4567', '1975-05-15', '2022-01-10', '6d65e299-1497-4aa8-9951-8fec24e1fc18', '12345678', NULL, '0c682a62-95a4-4b8c-be1e-fbec4e9b5eba', 'a479f98b-7972-4f82-972e-5849d422e3c0', 'f0f0c09c-6f18-44fd-a1c2-cd5116658a81', '29963268-444d-456d-9f6c-fd4f4f476b85', '2025-08-28 16:10:59.174368', '2025-08-31 19:08:57.348757', 'f');
COMMIT;

-- ----------------------------
-- Table structure for genders
-- ----------------------------
DROP TABLE IF EXISTS "public"."genders";
CREATE TABLE "public"."genders" (
  "id" uuid NOT NULL DEFAULT uuid_generate_v4(),
  "name" varchar(100) COLLATE "pg_catalog"."default" NOT NULL
)
;
ALTER TABLE "public"."genders" OWNER TO "riwi_nexus_user";

-- ----------------------------
-- Records of genders
-- ----------------------------
BEGIN;
INSERT INTO "public"."genders" ("id", "name") VALUES ('a479f98b-7972-4f82-972e-5849d422e3c0', 'Male');
INSERT INTO "public"."genders" ("id", "name") VALUES ('3b0cfae3-bf10-4e87-93e3-7fe5b213c5a8', 'Female');
INSERT INTO "public"."genders" ("id", "name") VALUES ('b0bb8fc7-03ad-4fb1-bbd3-62930d8e9949', 'Not Specified');
COMMIT;

-- ----------------------------
-- Table structure for headquarters
-- ----------------------------
DROP TABLE IF EXISTS "public"."headquarters";
CREATE TABLE "public"."headquarters" (
  "id" uuid NOT NULL DEFAULT uuid_generate_v4(),
  "name" varchar(100) COLLATE "pg_catalog"."default" NOT NULL,
  "created_at" timestamp(6),
  "updated_at" timestamp(6)
)
;
ALTER TABLE "public"."headquarters" OWNER TO "riwi_nexus_user";

-- ----------------------------
-- Records of headquarters
-- ----------------------------
BEGIN;
INSERT INTO "public"."headquarters" ("id", "name", "created_at", "updated_at") VALUES ('0c682a62-95a4-4b8c-be1e-fbec4e9b5eba', 'Medellin', '2025-08-28 14:07:06.000329', NULL);
INSERT INTO "public"."headquarters" ("id", "name", "created_at", "updated_at") VALUES ('a5208edf-dff8-4f77-8236-8c413ef6a638', 'Barranquilla', '2025-08-28 14:07:06.000329', NULL);
COMMIT;

-- ----------------------------
-- Table structure for identification_types
-- ----------------------------
DROP TABLE IF EXISTS "public"."identification_types";
CREATE TABLE "public"."identification_types" (
  "id" uuid NOT NULL DEFAULT uuid_generate_v4(),
  "name" varchar(100) COLLATE "pg_catalog"."default" NOT NULL
)
;
ALTER TABLE "public"."identification_types" OWNER TO "riwi_nexus_user";

-- ----------------------------
-- Records of identification_types
-- ----------------------------
BEGIN;
INSERT INTO "public"."identification_types" ("id", "name") VALUES ('6d65e299-1497-4aa8-9951-8fec24e1fc18', 'National ID');
INSERT INTO "public"."identification_types" ("id", "name") VALUES ('7b35df1b-9d16-429a-b821-7a2109e889d0', 'Foreigner ID');
INSERT INTO "public"."identification_types" ("id", "name") VALUES ('b4edcebf-4ddf-4869-a796-e053fc97f4c3', 'Passport');
INSERT INTO "public"."identification_types" ("id", "name") VALUES ('004fca85-0a9a-4143-a84b-fc341365fad1', 'Identity Card');
INSERT INTO "public"."identification_types" ("id", "name") VALUES ('bcef37b7-05c4-4392-88b5-522487400f7d', 'NIT');
INSERT INTO "public"."identification_types" ("id", "name") VALUES ('5b0c0769-8920-470a-a94a-f4fc08ffe37d', 'Birth Certificate');
INSERT INTO "public"."identification_types" ("id", "name") VALUES ('2db11540-41f3-44df-9543-04671286c601', 'Driver License');
INSERT INTO "public"."identification_types" ("id", "name") VALUES ('83eea81a-28f6-424a-8a0c-84c8f1a9cb2d', 'Military Card');
INSERT INTO "public"."identification_types" ("id", "name") VALUES ('b704e5e2-e89d-49a2-98ff-9cd0282557e2', 'Professional Card');
COMMIT;

-- ----------------------------
-- Table structure for leave_requests
-- ----------------------------
DROP TABLE IF EXISTS "public"."leave_requests";
CREATE TABLE "public"."leave_requests" (
  "id" uuid NOT NULL,
  "leave_type_id" uuid NOT NULL,
  "start_date" timestamp(6) NOT NULL,
  "end_date" timestamp(6) NOT NULL,
  "reason" text COLLATE "pg_catalog"."default" NOT NULL,
  "is_paid" bool DEFAULT false,
  "payment_amount" numeric(12,2)
)
;
ALTER TABLE "public"."leave_requests" OWNER TO "riwi_nexus_user";

-- ----------------------------
-- Records of leave_requests
-- ----------------------------
BEGIN;
INSERT INTO "public"."leave_requests" ("id", "leave_type_id", "start_date", "end_date", "reason", "is_paid", "payment_amount") VALUES ('150fd993-f4a2-4d0e-841d-fc924931ae94', '8782a144-8f9a-4c0b-b07a-94ec24795c70', '2025-08-29 08:00:00', '2025-09-30 08:00:00', 'asdas', 'f', NULL);
COMMIT;

-- ----------------------------
-- Table structure for leave_types
-- ----------------------------
DROP TABLE IF EXISTS "public"."leave_types";
CREATE TABLE "public"."leave_types" (
  "id" uuid NOT NULL DEFAULT uuid_generate_v4(),
  "name" varchar(100) COLLATE "pg_catalog"."default" NOT NULL,
  "requires_attachment" bool DEFAULT false
)
;
ALTER TABLE "public"."leave_types" OWNER TO "riwi_nexus_user";

-- ----------------------------
-- Records of leave_types
-- ----------------------------
BEGIN;
INSERT INTO "public"."leave_types" ("id", "name", "requires_attachment") VALUES ('182c3f92-0709-4b48-9805-96b96b038e7b', 'Personal Leave', 'f');
INSERT INTO "public"."leave_types" ("id", "name", "requires_attachment") VALUES ('efb91474-a8fa-4b63-86fc-9cfdb9c2150f', 'Medical Appointment', 't');
INSERT INTO "public"."leave_types" ("id", "name", "requires_attachment") VALUES ('5278d982-6efe-43e5-8a77-e015623c80ff', 'Family Emergency', 't');
INSERT INTO "public"."leave_types" ("id", "name", "requires_attachment") VALUES ('ecfdaf57-d9d0-4bc2-8621-2f4790729909', 'Maternity Leave', 't');
INSERT INTO "public"."leave_types" ("id", "name", "requires_attachment") VALUES ('f310d4ea-cc05-42d0-802f-7fdc8c2f67f3', 'Paternity Leave', 't');
INSERT INTO "public"."leave_types" ("id", "name", "requires_attachment") VALUES ('7089200f-2015-465c-947a-f3dbbd4a7735', 'Unpaid Leave', 'f');
INSERT INTO "public"."leave_types" ("id", "name", "requires_attachment") VALUES ('a46e031a-ada3-4fd1-8c05-32994e5e9de6', 'Medical Leave', 't');
INSERT INTO "public"."leave_types" ("id", "name", "requires_attachment") VALUES ('8782a144-8f9a-4c0b-b07a-94ec24795c70', 'Compensatory Day', 'f');
INSERT INTO "public"."leave_types" ("id", "name", "requires_attachment") VALUES ('a13ec824-225f-43d4-8467-5ce1e4d7617c', 'Breastfeeding Leave', 't');
INSERT INTO "public"."leave_types" ("id", "name", "requires_attachment") VALUES ('9bedac4c-a43a-45e3-b3f4-9710016be483', 'Bereavement Leave', 't');
INSERT INTO "public"."leave_types" ("id", "name", "requires_attachment") VALUES ('98582b15-0fb5-4fbd-910d-684852110455', 'Union Leave', 'f');
INSERT INTO "public"."leave_types" ("id", "name", "requires_attachment") VALUES ('7c4a3886-5e37-476f-901d-fc102e6f9088', 'Study Leave', 't');
INSERT INTO "public"."leave_types" ("id", "name", "requires_attachment") VALUES ('3a4eb6c0-5f11-49b4-8348-b357cdd0366e', 'Sports Leave', 't');
INSERT INTO "public"."leave_types" ("id", "name", "requires_attachment") VALUES ('90e7f6f4-e3d7-4625-8fc0-a3c10549a126', 'Family Medical Leave', 't');
INSERT INTO "public"."leave_types" ("id", "name", "requires_attachment") VALUES ('72e98cde-363c-4abc-b9cd-9583ba7ac454', 'Justified Absence', 't');
COMMIT;

-- ----------------------------
-- Table structure for notifications
-- ----------------------------
DROP TABLE IF EXISTS "public"."notifications";
CREATE TABLE "public"."notifications" (
  "id" uuid NOT NULL DEFAULT uuid_generate_v4(),
  "recipient_id" uuid NOT NULL,
  "message" text COLLATE "pg_catalog"."default" NOT NULL,
  "is_read" bool DEFAULT false,
  "related_url" varchar(255) COLLATE "pg_catalog"."default",
  "sent_date" timestamp(6) DEFAULT now()
)
;
ALTER TABLE "public"."notifications" OWNER TO "riwi_nexus_user";

-- ----------------------------
-- Records of notifications
-- ----------------------------
BEGIN;
INSERT INTO "public"."notifications" ("id", "recipient_id", "message", "is_read", "related_url", "sent_date") VALUES ('b3aefd95-0525-48b5-a21f-fb048f04d09b', '99cbbd5d-c6b2-4a6d-ac0d-35d721f4ef6c', 'Your certificate request is under review', 'f', '/requests/b2c3d4e5-f6a7-4901-bcde-f23456789012', '2025-08-26 09:35:00');
INSERT INTO "public"."notifications" ("id", "recipient_id", "message", "is_read", "related_url", "sent_date") VALUES ('2422d352-615b-4ad0-97a5-5b0aef6563fc', 'e383a839-60a3-4662-9e3f-1ff2c6c0a4d9', 'Your leave request has been approved', 't', '/requests/c3d4e5f6-a7b8-4012-cdef-345678901234', '2025-08-16 11:25:00');
INSERT INTO "public"."notifications" ("id", "recipient_id", "message", "is_read", "related_url", "sent_date") VALUES ('e59ed59a-2268-472c-ad7f-26d8bfd83181', '4a09ee7b-e188-4cfa-a50a-90c87d979566', 'Your vacation request has been completed', 't', '/requests/d4e5f6a7-b8c9-4123-def0-456789012345', '2025-07-12 10:05:00');
INSERT INTO "public"."notifications" ("id", "recipient_id", "message", "is_read", "related_url", "sent_date") VALUES ('7c37d741-6f03-4ba5-a0de-4c40e84125df', '52784b0d-6933-4717-acd7-46f940ab8579', 'New vacation request from Ana López requires approval', 'f', '/approvals/pending', '2025-08-20 10:00:00');
INSERT INTO "public"."notifications" ("id", "recipient_id", "message", "is_read", "related_url", "sent_date") VALUES ('de549d8f-83b5-49fb-829b-a73ffd8ae788', '52784b0d-6933-4717-acd7-46f940ab8579', 'New certificate request from Carlos Ruiz requires review', 'f', '/approvals/pending', '2025-08-25 14:30:00');
INSERT INTO "public"."notifications" ("id", "recipient_id", "message", "is_read", "related_url", "sent_date") VALUES ('1a299d3c-fc04-4aff-b2b8-a8e2a2f55fd2', 'e383a839-60a3-4662-9e3f-1ff2c6c0a4d9', 'Your vacation request has been submitted and is pending approval', 't', '/requests/a1b2c3d4-e5f6-4890-abcd-ef1234567890', '2025-08-20 10:05:00');
COMMIT;

-- ----------------------------
-- Table structure for password_reset_tokens
-- ----------------------------
DROP TABLE IF EXISTS "public"."password_reset_tokens";
CREATE TABLE "public"."password_reset_tokens" (
  "id" uuid NOT NULL DEFAULT uuid_generate_v4(),
  "user_id" uuid NOT NULL,
  "email" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "token" text COLLATE "pg_catalog"."default" NOT NULL,
  "expires_at" timestamp(6) NOT NULL,
  "created_at" timestamp(6) DEFAULT CURRENT_TIMESTAMP
)
;
ALTER TABLE "public"."password_reset_tokens" OWNER TO "riwi_nexus_user";

-- ----------------------------
-- Records of password_reset_tokens
-- ----------------------------
BEGIN;
INSERT INTO "public"."password_reset_tokens" ("id", "user_id", "email", "token", "expires_at", "created_at") VALUES ('81c99516-36b8-4ab6-8e46-85e7199ccb14', 'e383a839-60a3-4662-9e3f-1ff2c6c0a4d9', 'ana@nexus.com', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiJlMzgzYTgzOS02MGEzLTQ2NjItOWUzZi0xZmYyYzZjMGE0ZDkiLCJlbWFpbCI6ImFuYUBuZXh1cy5jb20iLCJ0eXBlIjoicGFzc3dvcmRfcmVzZXQiLCJpYXQiOjE3NTY2ODkxMDgsImV4cCI6MTc1NjY5MjcwOH0.pN1kmMQOjX484rZFZja6OhH6HmRrke9VbCcc_5ayphE', '2025-09-01 02:11:48.215236', '2025-09-01 01:11:48.215236');
COMMIT;

-- ----------------------------
-- Table structure for request_statuses
-- ----------------------------
DROP TABLE IF EXISTS "public"."request_statuses";
CREATE TABLE "public"."request_statuses" (
  "id" uuid NOT NULL DEFAULT uuid_generate_v4(),
  "name" varchar(100) COLLATE "pg_catalog"."default" NOT NULL
)
;
ALTER TABLE "public"."request_statuses" OWNER TO "riwi_nexus_user";

-- ----------------------------
-- Records of request_statuses
-- ----------------------------
BEGIN;
INSERT INTO "public"."request_statuses" ("id", "name") VALUES ('394938e8-032f-4c7d-9ed5-04d1f15c8824', 'Pending');
INSERT INTO "public"."request_statuses" ("id", "name") VALUES ('17197433-8315-448f-8109-06445ea5029a', 'Under Review');
INSERT INTO "public"."request_statuses" ("id", "name") VALUES ('d7512f89-e7f5-46ab-9bd9-cf6fd86e628e', 'Approved by Leader');
INSERT INTO "public"."request_statuses" ("id", "name") VALUES ('65dd7eda-9322-4564-b76a-52b6fd8ba73a', 'Approved by HR');
INSERT INTO "public"."request_statuses" ("id", "name") VALUES ('c0ff36f5-68cb-49fc-87cc-6a21a6f07d90', 'Approved');
INSERT INTO "public"."request_statuses" ("id", "name") VALUES ('c669d605-5d7a-4dc9-ae9c-f7ecc50592e5', 'Rejected');
INSERT INTO "public"."request_statuses" ("id", "name") VALUES ('384d3696-d2ee-403b-b5ca-21af08884b3f', 'Cancelled');
INSERT INTO "public"."request_statuses" ("id", "name") VALUES ('d539819a-9837-4262-b25b-57a224fc1e62', 'Expired');
INSERT INTO "public"."request_statuses" ("id", "name") VALUES ('032b6775-c183-4ef6-924a-29b85da3a935', 'In Process');
INSERT INTO "public"."request_statuses" ("id", "name") VALUES ('f8d5cdb7-ef2f-4736-99b7-091892275009', 'Completed');
COMMIT;

-- ----------------------------
-- Table structure for requests
-- ----------------------------
DROP TABLE IF EXISTS "public"."requests";
CREATE TABLE "public"."requests" (
  "id" uuid NOT NULL DEFAULT uuid_generate_v4(),
  "employee_id" uuid NOT NULL,
  "request_type" varchar(100) COLLATE "pg_catalog"."default" NOT NULL,
  "status_id" uuid NOT NULL,
  "created_at" timestamp(6),
  "updated_at" timestamp(6)
)
;
ALTER TABLE "public"."requests" OWNER TO "riwi_nexus_user";

-- ----------------------------
-- Records of requests
-- ----------------------------
BEGIN;
INSERT INTO "public"."requests" ("id", "employee_id", "request_type", "status_id", "created_at", "updated_at") VALUES ('798e2c3f-532b-4d5d-933f-7cf8f64474bd', 'e383a839-60a3-4662-9e3f-1ff2c6c0a4d9', 'vacation', '394938e8-032f-4c7d-9ed5-04d1f15c8824', '2025-08-29 17:08:10.714242', NULL);
INSERT INTO "public"."requests" ("id", "employee_id", "request_type", "status_id", "created_at", "updated_at") VALUES ('e5bc7159-dc11-47a6-ab02-9a98918afa99', 'e383a839-60a3-4662-9e3f-1ff2c6c0a4d9', 'vacation', '394938e8-032f-4c7d-9ed5-04d1f15c8824', '2025-08-29 17:10:52.250876', NULL);
INSERT INTO "public"."requests" ("id", "employee_id", "request_type", "status_id", "created_at", "updated_at") VALUES ('2ff66a64-c513-44b6-abfb-a0dff863c89e', 'e383a839-60a3-4662-9e3f-1ff2c6c0a4d9', 'vacation', '394938e8-032f-4c7d-9ed5-04d1f15c8824', '2025-08-29 17:18:19.03292', NULL);
INSERT INTO "public"."requests" ("id", "employee_id", "request_type", "status_id", "created_at", "updated_at") VALUES ('4596c50f-cdfa-4d49-91ef-365c0e777d74', 'e383a839-60a3-4662-9e3f-1ff2c6c0a4d9', 'vacation', '394938e8-032f-4c7d-9ed5-04d1f15c8824', '2025-08-29 17:23:49.795717', NULL);
INSERT INTO "public"."requests" ("id", "employee_id", "request_type", "status_id", "created_at", "updated_at") VALUES ('b674d96f-6efc-4260-8d05-fdb57dfbf324', 'e383a839-60a3-4662-9e3f-1ff2c6c0a4d9', 'vacation', '394938e8-032f-4c7d-9ed5-04d1f15c8824', '2025-08-29 17:32:50.930382', NULL);
INSERT INTO "public"."requests" ("id", "employee_id", "request_type", "status_id", "created_at", "updated_at") VALUES ('665ffab0-8484-40ad-acdc-4bccb548b2a6', 'e383a839-60a3-4662-9e3f-1ff2c6c0a4d9', 'certificate', '394938e8-032f-4c7d-9ed5-04d1f15c8824', '2025-08-29 17:33:38.002723', NULL);
INSERT INTO "public"."requests" ("id", "employee_id", "request_type", "status_id", "created_at", "updated_at") VALUES ('65456014-8e21-43a9-a5bd-eebcff10d324', 'e383a839-60a3-4662-9e3f-1ff2c6c0a4d9', 'vacation', '394938e8-032f-4c7d-9ed5-04d1f15c8824', '2025-08-29 17:47:56.175254', NULL);
INSERT INTO "public"."requests" ("id", "employee_id", "request_type", "status_id", "created_at", "updated_at") VALUES ('721cbc34-74d1-4101-be46-94ba29ef5293', '4a09ee7b-e188-4cfa-a50a-90c87d979566', 'vacation', '394938e8-032f-4c7d-9ed5-04d1f15c8824', '2025-08-29 17:56:43.872415', NULL);
INSERT INTO "public"."requests" ("id", "employee_id", "request_type", "status_id", "created_at", "updated_at") VALUES ('842d6f8e-6da5-4394-bd44-25b273c677d6', 'e383a839-60a3-4662-9e3f-1ff2c6c0a4d9', 'certificate', '394938e8-032f-4c7d-9ed5-04d1f15c8824', '2025-08-29 21:26:43.858555', NULL);
INSERT INTO "public"."requests" ("id", "employee_id", "request_type", "status_id", "created_at", "updated_at") VALUES ('2eefbc6c-88da-427a-8d2d-ce7cb6ef728c', 'e383a839-60a3-4662-9e3f-1ff2c6c0a4d9', 'vacation', '394938e8-032f-4c7d-9ed5-04d1f15c8824', '2025-08-29 21:27:04.953475', NULL);
INSERT INTO "public"."requests" ("id", "employee_id", "request_type", "status_id", "created_at", "updated_at") VALUES ('6e769cd0-725b-4808-95de-b382f81abcb0', 'e383a839-60a3-4662-9e3f-1ff2c6c0a4d9', 'vacation', '394938e8-032f-4c7d-9ed5-04d1f15c8824', '2025-08-29 22:07:12.941021', NULL);
INSERT INTO "public"."requests" ("id", "employee_id", "request_type", "status_id", "created_at", "updated_at") VALUES ('150fd993-f4a2-4d0e-841d-fc924931ae94', 'e383a839-60a3-4662-9e3f-1ff2c6c0a4d9', 'leave', '394938e8-032f-4c7d-9ed5-04d1f15c8824', '2025-08-29 22:26:02.721316', NULL);
INSERT INTO "public"."requests" ("id", "employee_id", "request_type", "status_id", "created_at", "updated_at") VALUES ('f4d7d985-3c5e-42fc-ae63-052c6d6570a6', 'e383a839-60a3-4662-9e3f-1ff2c6c0a4d9', 'certificate', '394938e8-032f-4c7d-9ed5-04d1f15c8824', '2025-08-30 00:34:54.742224', NULL);
INSERT INTO "public"."requests" ("id", "employee_id", "request_type", "status_id", "created_at", "updated_at") VALUES ('eda8a0e2-dd63-436f-8fe0-694f8e901e82', '0e4a5795-c4cb-474f-b06f-b8bc71bf52ba', 'certificate', '394938e8-032f-4c7d-9ed5-04d1f15c8824', '2025-08-30 20:30:10.87588', NULL);
INSERT INTO "public"."requests" ("id", "employee_id", "request_type", "status_id", "created_at", "updated_at") VALUES ('1f4669c4-43d9-4c42-94ff-8ca19f4b635f', '52784b0d-6933-4717-acd7-46f940ab8579', 'certificate', '394938e8-032f-4c7d-9ed5-04d1f15c8824', '2025-08-30 20:37:20.050693', NULL);
INSERT INTO "public"."requests" ("id", "employee_id", "request_type", "status_id", "created_at", "updated_at") VALUES ('5f7a0f67-83cd-40a0-9f50-b83e8c0aed2f', '4a09ee7b-e188-4cfa-a50a-90c87d979566', 'certificate', '394938e8-032f-4c7d-9ed5-04d1f15c8824', '2025-08-30 20:44:38.410927', NULL);
INSERT INTO "public"."requests" ("id", "employee_id", "request_type", "status_id", "created_at", "updated_at") VALUES ('9d88903c-a6a0-4583-ba81-f22f933017b3', '52784b0d-6933-4717-acd7-46f940ab8579', 'vacation', '394938e8-032f-4c7d-9ed5-04d1f15c8824', '2025-08-31 19:36:16.323921', NULL);
COMMIT;

-- ----------------------------
-- Table structure for roles
-- ----------------------------
DROP TABLE IF EXISTS "public"."roles";
CREATE TABLE "public"."roles" (
  "id" uuid NOT NULL DEFAULT uuid_generate_v4(),
  "name" varchar(40) COLLATE "pg_catalog"."default" NOT NULL,
  "description" text COLLATE "pg_catalog"."default",
  "area" varchar(40) COLLATE "pg_catalog"."default"
)
;
ALTER TABLE "public"."roles" OWNER TO "riwi_nexus_user";

-- ----------------------------
-- Records of roles
-- ----------------------------
BEGIN;
INSERT INTO "public"."roles" ("id", "name", "description", "area") VALUES ('7b3c4658-4ed4-454a-941a-84feb6943a7c', 'CEO', 'Chief Executive Officer responsible for overall company strategy and leadership', 'Executive');
INSERT INTO "public"."roles" ("id", "name", "description", "area") VALUES ('557b992c-35d0-4527-aa31-d69ac95b80f3', 'Operations Director', 'Director overseeing all operational activities and processes', 'Operations');
INSERT INTO "public"."roles" ("id", "name", "description", "area") VALUES ('4af370ba-5a1b-4557-8c65-72fea7f2c4e9', 'Employability Director', 'Director managing talent acquisition, development and employee relations', 'HR');
INSERT INTO "public"."roles" ("id", "name", "description", "area") VALUES ('9771c825-4085-4167-af0e-a2ada003df75', 'Production Leader', 'Leader responsible for production planning, quality control and delivery', 'Production');
INSERT INTO "public"."roles" ("id", "name", "description", "area") VALUES ('13220d2d-e8ca-4dcb-9fbb-13773a9a152a', 'Technical Leader', 'Leader overseeing technical architecture, development standards and innovation', 'Technology');
INSERT INTO "public"."roles" ("id", "name", "description", "area") VALUES ('85c57857-5007-4144-a601-53278a4f96b6', 'Learning Leader', 'Leader managing educational programs, training curricula and learning outcomes', 'Learning');
INSERT INTO "public"."roles" ("id", "name", "description", "area") VALUES ('5d2b3db8-9c46-41af-a521-955644b122e8', 'Business Development', 'Professional focused on identifying growth opportunities and strategic partnerships', 'Business');
INSERT INTO "public"."roles" ("id", "name", "description", "area") VALUES ('cef2003e-238c-432f-8789-2b8694b4fc76', 'Market Leader', 'Leader responsible for market analysis, positioning and competitive strategy', 'Marketing');
INSERT INTO "public"."roles" ("id", "name", "description", "area") VALUES ('288f6e67-8b51-46a3-8f6c-52a1465327d2', 'Administrative Leader', 'Leader overseeing administrative operations, facilities and support services', 'Administration');
INSERT INTO "public"."roles" ("id", "name", "description", "area") VALUES ('65fb5f91-a47d-4dd7-8f95-77c7831b56d0', 'HR Talent Leader', 'Leader managing recruitment, performance management and employee development', 'HR');
INSERT INTO "public"."roles" ("id", "name", "description", "area") VALUES ('2c21ba80-9e68-4b3e-a260-84db85e34e08', 'Product Owner', 'Professional defining product vision, managing backlog and stakeholder requirements', 'Product');
INSERT INTO "public"."roles" ("id", "name", "description", "area") VALUES ('01896d9a-1bfe-4607-ae03-7b10eb24dfee', 'Developer', 'Software engineer responsible for coding, testing and maintaining applications', 'Technology');
INSERT INTO "public"."roles" ("id", "name", "description", "area") VALUES ('833bc51f-50f2-4768-93f6-081cb9f014c6', 'English and German Teacher', 'Educator providing language instruction in English and German', 'Learning');
INSERT INTO "public"."roles" ("id", "name", "description", "area") VALUES ('b848847c-8abd-4c4b-904a-9e2bdd8d1255', 'B2B Sales', 'Sales professional focused on business-to-business client acquisition and relationships', 'Sales');
INSERT INTO "public"."roles" ("id", "name", "description", "area") VALUES ('abde86c1-e251-4ff8-8ff9-105d789f54dd', 'B2C Sales', 'Sales professional focused on direct consumer sales and customer experience', 'Sales');
INSERT INTO "public"."roles" ("id", "name", "description", "area") VALUES ('a9825678-d1d8-4a49-a597-aa4eb6930740', 'Administrative Assistant', 'Support professional handling administrative tasks and office coordination', 'Administration');
INSERT INTO "public"."roles" ("id", "name", "description", "area") VALUES ('d1faf0c7-8226-40d8-818c-0ecdd6a3b13e', 'Receptionist', 'Front desk professional managing visitor reception and communication support', 'Administration');
COMMIT;

-- ----------------------------
-- Table structure for vacation_balances
-- ----------------------------
DROP TABLE IF EXISTS "public"."vacation_balances";
CREATE TABLE "public"."vacation_balances" (
  "id" uuid NOT NULL DEFAULT uuid_generate_v4(),
  "employee_id" uuid NOT NULL,
  "year" int4 NOT NULL,
  "available_days" int4 NOT NULL,
  "days_taken" int4 DEFAULT 0
)
;
ALTER TABLE "public"."vacation_balances" OWNER TO "riwi_nexus_user";

-- ----------------------------
-- Records of vacation_balances
-- ----------------------------
BEGIN;
INSERT INTO "public"."vacation_balances" ("id", "employee_id", "year", "available_days", "days_taken") VALUES ('b488a2dc-bcd4-4f23-bae6-399b14fd2edc', '52784b0d-6933-4717-acd7-46f940ab8579', 2024, 30, 10);
INSERT INTO "public"."vacation_balances" ("id", "employee_id", "year", "available_days", "days_taken") VALUES ('d8b106c1-629d-4e1e-bd2a-82d2d8bd08bd', '52784b0d-6933-4717-acd7-46f940ab8579', 2025, 30, 5);
INSERT INTO "public"."vacation_balances" ("id", "employee_id", "year", "available_days", "days_taken") VALUES ('8535c490-7957-4f6b-9ed2-118130da134f', '4a09ee7b-e188-4cfa-a50a-90c87d979566', 2024, 25, 8);
INSERT INTO "public"."vacation_balances" ("id", "employee_id", "year", "available_days", "days_taken") VALUES ('f653174c-ecdb-45d7-aed8-533fbbf40fe1', '4a09ee7b-e188-4cfa-a50a-90c87d979566', 2025, 25, 3);
INSERT INTO "public"."vacation_balances" ("id", "employee_id", "year", "available_days", "days_taken") VALUES ('789f2ac6-3611-4a51-a808-27d89d41003c', 'e383a839-60a3-4662-9e3f-1ff2c6c0a4d9', 2024, 15, 0);
INSERT INTO "public"."vacation_balances" ("id", "employee_id", "year", "available_days", "days_taken") VALUES ('7da5dade-f101-4e3c-9c5a-325adf294999', 'e383a839-60a3-4662-9e3f-1ff2c6c0a4d9', 2025, 20, 2);
INSERT INTO "public"."vacation_balances" ("id", "employee_id", "year", "available_days", "days_taken") VALUES ('9dd11923-eba2-43f3-80b9-d3ef44337dd5', '99cbbd5d-c6b2-4a6d-ac0d-35d721f4ef6c', 2024, 20, 5);
INSERT INTO "public"."vacation_balances" ("id", "employee_id", "year", "available_days", "days_taken") VALUES ('10b18657-5f45-41a8-af5d-374f72fc394f', '99cbbd5d-c6b2-4a6d-ac0d-35d721f4ef6c', 2025, 20, 0);
COMMIT;

-- ----------------------------
-- Table structure for vacation_requests
-- ----------------------------
DROP TABLE IF EXISTS "public"."vacation_requests";
CREATE TABLE "public"."vacation_requests" (
  "id" uuid NOT NULL,
  "vacation_type_id" uuid NOT NULL,
  "start_date" date NOT NULL,
  "end_date" date NOT NULL,
  "days_requested" int4 NOT NULL,
  "comments" text COLLATE "pg_catalog"."default",
  "is_paid" bool DEFAULT false,
  "payment_amount" numeric(12,2)
)
;
ALTER TABLE "public"."vacation_requests" OWNER TO "riwi_nexus_user";

-- ----------------------------
-- Records of vacation_requests
-- ----------------------------
BEGIN;
INSERT INTO "public"."vacation_requests" ("id", "vacation_type_id", "start_date", "end_date", "days_requested", "comments", "is_paid", "payment_amount") VALUES ('798e2c3f-532b-4d5d-933f-7cf8f64474bd', 'f74e4557-beb5-4eb0-adeb-9f6962df7560', '2025-08-30', '2025-08-31', 2, NULL, 'f', NULL);
INSERT INTO "public"."vacation_requests" ("id", "vacation_type_id", "start_date", "end_date", "days_requested", "comments", "is_paid", "payment_amount") VALUES ('e5bc7159-dc11-47a6-ab02-9a98918afa99', 'f74e4557-beb5-4eb0-adeb-9f6962df7560', '2025-08-30', '2025-08-31', 2, NULL, 'f', NULL);
INSERT INTO "public"."vacation_requests" ("id", "vacation_type_id", "start_date", "end_date", "days_requested", "comments", "is_paid", "payment_amount") VALUES ('2ff66a64-c513-44b6-abfb-a0dff863c89e', 'f74e4557-beb5-4eb0-adeb-9f6962df7560', '2025-08-30', '2025-08-31', 2, NULL, 'f', NULL);
INSERT INTO "public"."vacation_requests" ("id", "vacation_type_id", "start_date", "end_date", "days_requested", "comments", "is_paid", "payment_amount") VALUES ('4596c50f-cdfa-4d49-91ef-365c0e777d74', 'f74e4557-beb5-4eb0-adeb-9f6962df7560', '2025-08-30', '2025-08-31', 2, 'Test request', 'f', NULL);
INSERT INTO "public"."vacation_requests" ("id", "vacation_type_id", "start_date", "end_date", "days_requested", "comments", "is_paid", "payment_amount") VALUES ('b674d96f-6efc-4260-8d05-fdb57dfbf324', 'f74e4557-beb5-4eb0-adeb-9f6962df7560', '2025-08-30', '2025-08-31', 2, 'Test request', 'f', NULL);
INSERT INTO "public"."vacation_requests" ("id", "vacation_type_id", "start_date", "end_date", "days_requested", "comments", "is_paid", "payment_amount") VALUES ('65456014-8e21-43a9-a5bd-eebcff10d324', '655f2100-dafb-4fbc-8ea0-9dfaf9f32a03', '2025-08-30', '2025-09-05', 7, NULL, 'f', NULL);
INSERT INTO "public"."vacation_requests" ("id", "vacation_type_id", "start_date", "end_date", "days_requested", "comments", "is_paid", "payment_amount") VALUES ('721cbc34-74d1-4101-be46-94ba29ef5293', 'f74e4557-beb5-4eb0-adeb-9f6962df7560', '2025-08-28', '2025-08-31', 4, 'quiero salirrrrrrr', 'f', NULL);
INSERT INTO "public"."vacation_requests" ("id", "vacation_type_id", "start_date", "end_date", "days_requested", "comments", "is_paid", "payment_amount") VALUES ('2eefbc6c-88da-427a-8d2d-ce7cb6ef728c', 'e2367a84-0a1c-4174-9449-b94c4b3c9589', '2025-09-03', '2025-09-06', 4, NULL, 'f', NULL);
INSERT INTO "public"."vacation_requests" ("id", "vacation_type_id", "start_date", "end_date", "days_requested", "comments", "is_paid", "payment_amount") VALUES ('6e769cd0-725b-4808-95de-b382f81abcb0', 'e2367a84-0a1c-4174-9449-b94c4b3c9589', '2025-08-30', '2025-08-31', 2, 'dasdas', 'f', NULL);
INSERT INTO "public"."vacation_requests" ("id", "vacation_type_id", "start_date", "end_date", "days_requested", "comments", "is_paid", "payment_amount") VALUES ('9d88903c-a6a0-4583-ba81-f22f933017b3', '655f2100-dafb-4fbc-8ea0-9dfaf9f32a03', '2025-08-19', '2025-08-29', 11, NULL, 'f', NULL);
COMMIT;

-- ----------------------------
-- Table structure for vacation_types
-- ----------------------------
DROP TABLE IF EXISTS "public"."vacation_types";
CREATE TABLE "public"."vacation_types" (
  "id" uuid NOT NULL DEFAULT uuid_generate_v4(),
  "name" varchar(100) COLLATE "pg_catalog"."default" NOT NULL
)
;
ALTER TABLE "public"."vacation_types" OWNER TO "riwi_nexus_user";

-- ----------------------------
-- Records of vacation_types
-- ----------------------------
BEGIN;
INSERT INTO "public"."vacation_types" ("id", "name") VALUES ('f74e4557-beb5-4eb0-adeb-9f6962df7560', 'Annual Vacation');
INSERT INTO "public"."vacation_types" ("id", "name") VALUES ('655f2100-dafb-4fbc-8ea0-9dfaf9f32a03', 'Accumulated Vacation');
INSERT INTO "public"."vacation_types" ("id", "name") VALUES ('abf5f51e-f0ef-4ade-ac11-32fac35fdc4e', 'Advance Vacation');
INSERT INTO "public"."vacation_types" ("id", "name") VALUES ('e2367a84-0a1c-4174-9449-b94c4b3c9589', 'Collective Vacation');
INSERT INTO "public"."vacation_types" ("id", "name") VALUES ('3dc278ff-6ffd-438e-85a4-f7c3e36f15fd', 'Compensated Vacation');
COMMIT;

-- ----------------------------
-- Function structure for update_timestamp
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."update_timestamp"();
CREATE FUNCTION "public"."update_timestamp"()
  RETURNS "pg_catalog"."trigger" AS $BODY$
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
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION "public"."update_timestamp"() OWNER TO "riwi_nexus_user";

-- ----------------------------
-- Function structure for uuid_generate_v1
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."uuid_generate_v1"();
CREATE FUNCTION "public"."uuid_generate_v1"()
  RETURNS "pg_catalog"."uuid" AS '$libdir/uuid-ossp', 'uuid_generate_v1'
  LANGUAGE c VOLATILE STRICT
  COST 1;
ALTER FUNCTION "public"."uuid_generate_v1"() OWNER TO "riwi_nexus_user";

-- ----------------------------
-- Function structure for uuid_generate_v1mc
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."uuid_generate_v1mc"();
CREATE FUNCTION "public"."uuid_generate_v1mc"()
  RETURNS "pg_catalog"."uuid" AS '$libdir/uuid-ossp', 'uuid_generate_v1mc'
  LANGUAGE c VOLATILE STRICT
  COST 1;
ALTER FUNCTION "public"."uuid_generate_v1mc"() OWNER TO "riwi_nexus_user";

-- ----------------------------
-- Function structure for uuid_generate_v3
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."uuid_generate_v3"("namespace" uuid, "name" text);
CREATE FUNCTION "public"."uuid_generate_v3"("namespace" uuid, "name" text)
  RETURNS "pg_catalog"."uuid" AS '$libdir/uuid-ossp', 'uuid_generate_v3'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;
ALTER FUNCTION "public"."uuid_generate_v3"("namespace" uuid, "name" text) OWNER TO "riwi_nexus_user";

-- ----------------------------
-- Function structure for uuid_generate_v4
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."uuid_generate_v4"();
CREATE FUNCTION "public"."uuid_generate_v4"()
  RETURNS "pg_catalog"."uuid" AS '$libdir/uuid-ossp', 'uuid_generate_v4'
  LANGUAGE c VOLATILE STRICT
  COST 1;
ALTER FUNCTION "public"."uuid_generate_v4"() OWNER TO "riwi_nexus_user";

-- ----------------------------
-- Function structure for uuid_generate_v5
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."uuid_generate_v5"("namespace" uuid, "name" text);
CREATE FUNCTION "public"."uuid_generate_v5"("namespace" uuid, "name" text)
  RETURNS "pg_catalog"."uuid" AS '$libdir/uuid-ossp', 'uuid_generate_v5'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;
ALTER FUNCTION "public"."uuid_generate_v5"("namespace" uuid, "name" text) OWNER TO "riwi_nexus_user";

-- ----------------------------
-- Function structure for uuid_nil
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."uuid_nil"();
CREATE FUNCTION "public"."uuid_nil"()
  RETURNS "pg_catalog"."uuid" AS '$libdir/uuid-ossp', 'uuid_nil'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;
ALTER FUNCTION "public"."uuid_nil"() OWNER TO "riwi_nexus_user";

-- ----------------------------
-- Function structure for uuid_ns_dns
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."uuid_ns_dns"();
CREATE FUNCTION "public"."uuid_ns_dns"()
  RETURNS "pg_catalog"."uuid" AS '$libdir/uuid-ossp', 'uuid_ns_dns'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;
ALTER FUNCTION "public"."uuid_ns_dns"() OWNER TO "riwi_nexus_user";

-- ----------------------------
-- Function structure for uuid_ns_oid
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."uuid_ns_oid"();
CREATE FUNCTION "public"."uuid_ns_oid"()
  RETURNS "pg_catalog"."uuid" AS '$libdir/uuid-ossp', 'uuid_ns_oid'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;
ALTER FUNCTION "public"."uuid_ns_oid"() OWNER TO "riwi_nexus_user";

-- ----------------------------
-- Function structure for uuid_ns_url
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."uuid_ns_url"();
CREATE FUNCTION "public"."uuid_ns_url"()
  RETURNS "pg_catalog"."uuid" AS '$libdir/uuid-ossp', 'uuid_ns_url'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;
ALTER FUNCTION "public"."uuid_ns_url"() OWNER TO "riwi_nexus_user";

-- ----------------------------
-- Function structure for uuid_ns_x500
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."uuid_ns_x500"();
CREATE FUNCTION "public"."uuid_ns_x500"()
  RETURNS "pg_catalog"."uuid" AS '$libdir/uuid-ossp', 'uuid_ns_x500'
  LANGUAGE c IMMUTABLE STRICT
  COST 1;
ALTER FUNCTION "public"."uuid_ns_x500"() OWNER TO "riwi_nexus_user";

-- ----------------------------
-- Uniques structure for table access_levels
-- ----------------------------
ALTER TABLE "public"."access_levels" ADD CONSTRAINT "access_levels_name_key" UNIQUE ("name");

-- ----------------------------
-- Primary Key structure for table access_levels
-- ----------------------------
ALTER TABLE "public"."access_levels" ADD CONSTRAINT "access_levels_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table approvals
-- ----------------------------
ALTER TABLE "public"."approvals" ADD CONSTRAINT "approvals_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Triggers structure for table attached_documents
-- ----------------------------
CREATE TRIGGER "set_attached_documents_timestamp" BEFORE INSERT OR UPDATE ON "public"."attached_documents"
FOR EACH ROW
EXECUTE PROCEDURE "public"."update_timestamp"();

-- ----------------------------
-- Primary Key structure for table attached_documents
-- ----------------------------
ALTER TABLE "public"."attached_documents" ADD CONSTRAINT "attached_documents_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table certificate_requests
-- ----------------------------
ALTER TABLE "public"."certificate_requests" ADD CONSTRAINT "certificate_requests_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Uniques structure for table certificate_types
-- ----------------------------
ALTER TABLE "public"."certificate_types" ADD CONSTRAINT "certificate_types_name_key" UNIQUE ("name");

-- ----------------------------
-- Primary Key structure for table certificate_types
-- ----------------------------
ALTER TABLE "public"."certificate_types" ADD CONSTRAINT "certificate_types_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table employee_histories
-- ----------------------------
ALTER TABLE "public"."employee_histories" ADD CONSTRAINT "employee_histories_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table employee_roles
-- ----------------------------
ALTER TABLE "public"."employee_roles" ADD CONSTRAINT "employee_roles_pkey" PRIMARY KEY ("employee_id", "role_id");

-- ----------------------------
-- Triggers structure for table employee_salaries
-- ----------------------------
CREATE TRIGGER "set_employee_salaries_timestamp" BEFORE INSERT OR UPDATE ON "public"."employee_salaries"
FOR EACH ROW
EXECUTE PROCEDURE "public"."update_timestamp"();

-- ----------------------------
-- Checks structure for table employee_salaries
-- ----------------------------
ALTER TABLE "public"."employee_salaries" ADD CONSTRAINT "employee_salaries_chk_salary_amount_positive" CHECK (salary_amount > 0::numeric);

-- ----------------------------
-- Primary Key structure for table employee_salaries
-- ----------------------------
ALTER TABLE "public"."employee_salaries" ADD CONSTRAINT "employee_salaries_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Uniques structure for table employee_statuses
-- ----------------------------
ALTER TABLE "public"."employee_statuses" ADD CONSTRAINT "employee_statuses_name_key" UNIQUE ("name");

-- ----------------------------
-- Primary Key structure for table employee_statuses
-- ----------------------------
ALTER TABLE "public"."employee_statuses" ADD CONSTRAINT "employee_statuses_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Triggers structure for table employees
-- ----------------------------
CREATE TRIGGER "set_employees_timestamp" BEFORE INSERT OR UPDATE ON "public"."employees"
FOR EACH ROW
EXECUTE PROCEDURE "public"."update_timestamp"();

-- ----------------------------
-- Uniques structure for table employees
-- ----------------------------
ALTER TABLE "public"."employees" ADD CONSTRAINT "employees_employee_code_key" UNIQUE ("employee_code");
ALTER TABLE "public"."employees" ADD CONSTRAINT "employees_email_key" UNIQUE ("email");

-- ----------------------------
-- Primary Key structure for table employees
-- ----------------------------
ALTER TABLE "public"."employees" ADD CONSTRAINT "employees_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Uniques structure for table genders
-- ----------------------------
ALTER TABLE "public"."genders" ADD CONSTRAINT "genders_name_key" UNIQUE ("name");

-- ----------------------------
-- Primary Key structure for table genders
-- ----------------------------
ALTER TABLE "public"."genders" ADD CONSTRAINT "genders_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Triggers structure for table headquarters
-- ----------------------------
CREATE TRIGGER "set_headquarters_timestamp" BEFORE INSERT OR UPDATE ON "public"."headquarters"
FOR EACH ROW
EXECUTE PROCEDURE "public"."update_timestamp"();

-- ----------------------------
-- Uniques structure for table headquarters
-- ----------------------------
ALTER TABLE "public"."headquarters" ADD CONSTRAINT "headquarters_name_key" UNIQUE ("name");

-- ----------------------------
-- Primary Key structure for table headquarters
-- ----------------------------
ALTER TABLE "public"."headquarters" ADD CONSTRAINT "headquarters_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Uniques structure for table identification_types
-- ----------------------------
ALTER TABLE "public"."identification_types" ADD CONSTRAINT "identification_types_name_key" UNIQUE ("name");

-- ----------------------------
-- Primary Key structure for table identification_types
-- ----------------------------
ALTER TABLE "public"."identification_types" ADD CONSTRAINT "identification_types_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Checks structure for table leave_requests
-- ----------------------------
ALTER TABLE "public"."leave_requests" ADD CONSTRAINT "leave_requests_chk_end_date_after_start" CHECK (end_date >= start_date);

-- ----------------------------
-- Primary Key structure for table leave_requests
-- ----------------------------
ALTER TABLE "public"."leave_requests" ADD CONSTRAINT "leave_requests_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Uniques structure for table leave_types
-- ----------------------------
ALTER TABLE "public"."leave_types" ADD CONSTRAINT "leave_types_name_key" UNIQUE ("name");

-- ----------------------------
-- Primary Key structure for table leave_types
-- ----------------------------
ALTER TABLE "public"."leave_types" ADD CONSTRAINT "leave_types_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table notifications
-- ----------------------------
ALTER TABLE "public"."notifications" ADD CONSTRAINT "notifications_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Indexes structure for table password_reset_tokens
-- ----------------------------
CREATE INDEX "idx_password_reset_email" ON "public"."password_reset_tokens" USING btree (
  "email" COLLATE "pg_catalog"."default" "pg_catalog"."text_ops" ASC NULLS LAST
);
CREATE INDEX "idx_password_reset_expires" ON "public"."password_reset_tokens" USING btree (
  "expires_at" "pg_catalog"."timestamp_ops" ASC NULLS LAST
);

-- ----------------------------
-- Uniques structure for table password_reset_tokens
-- ----------------------------
ALTER TABLE "public"."password_reset_tokens" ADD CONSTRAINT "unique_user_token" UNIQUE ("user_id");

-- ----------------------------
-- Uniques structure for table request_statuses
-- ----------------------------
ALTER TABLE "public"."request_statuses" ADD CONSTRAINT "request_statuses_name_key" UNIQUE ("name");

-- ----------------------------
-- Primary Key structure for table request_statuses
-- ----------------------------
ALTER TABLE "public"."request_statuses" ADD CONSTRAINT "request_statuses_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Triggers structure for table requests
-- ----------------------------
CREATE TRIGGER "set_requests_timestamp" BEFORE INSERT OR UPDATE ON "public"."requests"
FOR EACH ROW
EXECUTE PROCEDURE "public"."update_timestamp"();

-- ----------------------------
-- Primary Key structure for table requests
-- ----------------------------
ALTER TABLE "public"."requests" ADD CONSTRAINT "requests_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Uniques structure for table roles
-- ----------------------------
ALTER TABLE "public"."roles" ADD CONSTRAINT "roles_name_key" UNIQUE ("name");

-- ----------------------------
-- Primary Key structure for table roles
-- ----------------------------
ALTER TABLE "public"."roles" ADD CONSTRAINT "roles_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Uniques structure for table vacation_balances
-- ----------------------------
ALTER TABLE "public"."vacation_balances" ADD CONSTRAINT "vacation_balances_ukey" UNIQUE ("employee_id", "year");

-- ----------------------------
-- Primary Key structure for table vacation_balances
-- ----------------------------
ALTER TABLE "public"."vacation_balances" ADD CONSTRAINT "vacation_balances_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Checks structure for table vacation_requests
-- ----------------------------
ALTER TABLE "public"."vacation_requests" ADD CONSTRAINT "vacation_requests_chk_end_date_after_start" CHECK (end_date >= start_date);

-- ----------------------------
-- Primary Key structure for table vacation_requests
-- ----------------------------
ALTER TABLE "public"."vacation_requests" ADD CONSTRAINT "vacation_requests_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Uniques structure for table vacation_types
-- ----------------------------
ALTER TABLE "public"."vacation_types" ADD CONSTRAINT "vacation_types_name_key" UNIQUE ("name");

-- ----------------------------
-- Primary Key structure for table vacation_types
-- ----------------------------
ALTER TABLE "public"."vacation_types" ADD CONSTRAINT "vacation_types_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Foreign Keys structure for table approvals
-- ----------------------------
ALTER TABLE "public"."approvals" ADD CONSTRAINT "approvals_approver_id_fkey" FOREIGN KEY ("approver_id") REFERENCES "public"."employees" ("id") ON DELETE RESTRICT ON UPDATE NO ACTION;
ALTER TABLE "public"."approvals" ADD CONSTRAINT "approvals_request_id_fkey" FOREIGN KEY ("request_id") REFERENCES "public"."requests" ("id") ON DELETE CASCADE ON UPDATE NO ACTION;
ALTER TABLE "public"."approvals" ADD CONSTRAINT "approvals_status_id_fkey" FOREIGN KEY ("status_id") REFERENCES "public"."request_statuses" ("id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- ----------------------------
-- Foreign Keys structure for table attached_documents
-- ----------------------------
ALTER TABLE "public"."attached_documents" ADD CONSTRAINT "attached_documents_request_id_fkey" FOREIGN KEY ("request_id") REFERENCES "public"."requests" ("id") ON DELETE CASCADE ON UPDATE NO ACTION;
ALTER TABLE "public"."attached_documents" ADD CONSTRAINT "attached_documents_uploaded_by_id_fkey" FOREIGN KEY ("uploaded_by_id") REFERENCES "public"."employees" ("id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- ----------------------------
-- Foreign Keys structure for table certificate_requests
-- ----------------------------
ALTER TABLE "public"."certificate_requests" ADD CONSTRAINT "certificate_requests_certificate_type_id_fkey" FOREIGN KEY ("certificate_type_id") REFERENCES "public"."certificate_types" ("id") ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "public"."certificate_requests" ADD CONSTRAINT "certificate_requests_id_fkey" FOREIGN KEY ("id") REFERENCES "public"."requests" ("id") ON DELETE CASCADE ON UPDATE NO ACTION;

-- ----------------------------
-- Foreign Keys structure for table employee_histories
-- ----------------------------
ALTER TABLE "public"."employee_histories" ADD CONSTRAINT "employee_histories_employee_id_fkey" FOREIGN KEY ("employee_id") REFERENCES "public"."employees" ("id") ON DELETE CASCADE ON UPDATE NO ACTION;
ALTER TABLE "public"."employee_histories" ADD CONSTRAINT "employee_histories_performed_by_id_fkey" FOREIGN KEY ("performed_by_id") REFERENCES "public"."employees" ("id") ON DELETE SET NULL ON UPDATE NO ACTION;

-- ----------------------------
-- Foreign Keys structure for table employee_roles
-- ----------------------------
ALTER TABLE "public"."employee_roles" ADD CONSTRAINT "employee_roles_employee_id_fkey" FOREIGN KEY ("employee_id") REFERENCES "public"."employees" ("id") ON DELETE CASCADE ON UPDATE NO ACTION;
ALTER TABLE "public"."employee_roles" ADD CONSTRAINT "employee_roles_role_id_fkey" FOREIGN KEY ("role_id") REFERENCES "public"."roles" ("id") ON DELETE CASCADE ON UPDATE NO ACTION;

-- ----------------------------
-- Foreign Keys structure for table employee_salaries
-- ----------------------------
ALTER TABLE "public"."employee_salaries" ADD CONSTRAINT "employee_salaries_employee_id_fkey" FOREIGN KEY ("employee_id") REFERENCES "public"."employees" ("id") ON DELETE CASCADE ON UPDATE NO ACTION;

-- ----------------------------
-- Foreign Keys structure for table employees
-- ----------------------------
ALTER TABLE "public"."employees" ADD CONSTRAINT "employees_access_level_id_fkey" FOREIGN KEY ("access_level_id") REFERENCES "public"."access_levels" ("id") ON DELETE SET NULL ON UPDATE NO ACTION;
ALTER TABLE "public"."employees" ADD CONSTRAINT "employees_gender_id_fkey" FOREIGN KEY ("gender_id") REFERENCES "public"."genders" ("id") ON DELETE SET NULL ON UPDATE NO ACTION;
ALTER TABLE "public"."employees" ADD CONSTRAINT "employees_headquarters_id_fkey" FOREIGN KEY ("headquarters_id") REFERENCES "public"."headquarters" ("id") ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE "public"."employees" ADD CONSTRAINT "employees_identification_type_id_fkey" FOREIGN KEY ("identification_type_id") REFERENCES "public"."identification_types" ("id") ON DELETE SET NULL ON UPDATE NO ACTION;
ALTER TABLE "public"."employees" ADD CONSTRAINT "employees_manager_id_fkey" FOREIGN KEY ("manager_id") REFERENCES "public"."employees" ("id") ON DELETE SET NULL ON UPDATE NO ACTION;
ALTER TABLE "public"."employees" ADD CONSTRAINT "employees_status_id_fkey" FOREIGN KEY ("status_id") REFERENCES "public"."employee_statuses" ("id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- ----------------------------
-- Foreign Keys structure for table leave_requests
-- ----------------------------
ALTER TABLE "public"."leave_requests" ADD CONSTRAINT "leave_requests_id_fkey" FOREIGN KEY ("id") REFERENCES "public"."requests" ("id") ON DELETE CASCADE ON UPDATE NO ACTION;
ALTER TABLE "public"."leave_requests" ADD CONSTRAINT "leave_requests_leave_type_id_fkey" FOREIGN KEY ("leave_type_id") REFERENCES "public"."leave_types" ("id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- ----------------------------
-- Foreign Keys structure for table notifications
-- ----------------------------
ALTER TABLE "public"."notifications" ADD CONSTRAINT "notifications_recipient_id_fkey" FOREIGN KEY ("recipient_id") REFERENCES "public"."employees" ("id") ON DELETE CASCADE ON UPDATE NO ACTION;

-- ----------------------------
-- Foreign Keys structure for table password_reset_tokens
-- ----------------------------
ALTER TABLE "public"."password_reset_tokens" ADD CONSTRAINT "fk_password_reset_user" FOREIGN KEY ("user_id") REFERENCES "public"."employees" ("id") ON DELETE CASCADE ON UPDATE NO ACTION;

-- ----------------------------
-- Foreign Keys structure for table requests
-- ----------------------------
ALTER TABLE "public"."requests" ADD CONSTRAINT "requests_employee_id_fkey" FOREIGN KEY ("employee_id") REFERENCES "public"."employees" ("id") ON DELETE CASCADE ON UPDATE NO ACTION;
ALTER TABLE "public"."requests" ADD CONSTRAINT "requests_status_id_fkey" FOREIGN KEY ("status_id") REFERENCES "public"."request_statuses" ("id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- ----------------------------
-- Foreign Keys structure for table vacation_balances
-- ----------------------------
ALTER TABLE "public"."vacation_balances" ADD CONSTRAINT "vacation_balances_employee_id_fkey" FOREIGN KEY ("employee_id") REFERENCES "public"."employees" ("id") ON DELETE CASCADE ON UPDATE NO ACTION;

-- ----------------------------
-- Foreign Keys structure for table vacation_requests
-- ----------------------------
ALTER TABLE "public"."vacation_requests" ADD CONSTRAINT "vacation_requests_id_fkey" FOREIGN KEY ("id") REFERENCES "public"."requests" ("id") ON DELETE CASCADE ON UPDATE NO ACTION;
ALTER TABLE "public"."vacation_requests" ADD CONSTRAINT "vacation_requests_vacation_type_id_fkey" FOREIGN KEY ("vacation_type_id") REFERENCES "public"."vacation_types" ("id") ON DELETE NO ACTION ON UPDATE NO ACTION;
