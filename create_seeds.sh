#!/bin/bash

# =======================================================================
#               CSV SEED FILE GENERATOR FOR RIWI-NEXUS
# This script automatically creates all the necessary CSV files with test data.
# =======================================================================

# --- Configuration ---
# Directory where the CSV files will be created
DATA_DIR="backend/data"

# --- Colors for Output ---
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# --- Script Logic ---
echo -e "${YELLOW}🚀 Creating seed data directory: ${DATA_DIR}${NC}"
mkdir -p "$DATA_DIR" # The -p flag creates the directory only if it doesn't exist

# --- Function to create a CSV file ---
# $1: File name (e.g., "01_employee_statuses.csv")
# $2: CSV content (multiline string)
create_csv() {
    FILE_PATH="${DATA_DIR}/$1"
    CONTENT="$2"
    
    echo "$CONTENT" > "$FILE_PATH"
    echo -e "   ${GREEN}✅ Created ${FILE_PATH}${NC}"
}

# --- 1. Employee Statuses ---
create_csv "01_employee_statuses.csv" \
"id,name
c094831b-718b-4b92-aefc-6857257fdd5e,Active
bd6032ee-51d3-458a-abcd-d0e4cb87904f,Inactive
59ed91f7-f478-4ffd-8c9e-f21122c9d2dd,On Leave"

# --- 2. Genders ---
create_csv "02_genders.csv" \
"id,name
e0eb8e67-1f56-4e28-8956-edca7b2e6010,Male
c7c8e6d0-1b3f-4b9f-8b1e-9e7d6a5f4c3d,Female
a3b4c5d6-e7f8-9a0b-1c2d-3e4f5a6b7c8d,Non-binary"

# --- 3. Roles ---
create_csv "03_roles.csv" \
"id,name,description,area
13f328c0-9105-490b-8736-240baeba8a62,Employee,\"Standard employee access\",\"General\"
f2a3b4c5-d6e7-f89a-0b1c-2d3e4f5a6b7c,Manager,\"Team Manager with approval rights\",\"Management\"
d9ca189c-0ae7-48f7-a3ac-2a4c00d28770,Admin,\"System Administrator with full access\",\"Administration\"
b5c6d7e8-f9a0-b1c2-d3e4-f5a6b7c8d9e0,HR,\"Human Resources personnel\",\"HR\""

# --- 4. Headquarters ---
create_csv "04_headquarters.csv" \
"id,name
d4611413-2ee2-4930-a116-aad80cd83c75,\"Main Office\"
a0b1c2d3-e4f5-a6b7-c8d9-e0f1a2b3c4d5,\"Remote\"
f5a6b7c8-d9e0-f1a2-b3c4-d5e6f7a8b9c0,\"North Branch\""

# --- 5. Request Statuses ---
create_csv "05_request_statuses.csv" \
"id,name
b8a9c0d1-e2f3-a4b5-c6d7-e8f9a0b1c2d3,Pending
a7b8c9d0-e1f2-a3b4-c5d6-e7f8a9b0c1d2,Approved
c6d7e8f9-a0b1-c2d3-e4f5-a6b7c8d9e0f1,Rejected"

# --- 6. Leave Types ---
create_csv "06_leave_types.csv" \
"id,name,requires_attachment
c5d6e7f8-9a0b-1c2d-3e4f-5a6b7c8d9e0f,\"Medical\",true
b4c5d6e7-f89a-0b1c-2d3e-4f5a6b7c8d9e,\"Personal\",false
a3b4c5d6-e7f8-9a0b-1c2d-3e4f5a6b7c8d,\"Bereavement\",true"

# --- 7. Certificate Types ---
create_csv "07_certificate_types.csv" \
"id,name
f1a2b3c4-d5e6-f7a8-b9c0-d1e2f3a4b5c6,\"Proof of Employment\"
e0f1a2b3-c4d5-e6f7-a8b9-c0d1e2f3a4b5,\"Salary Certificate\""

# --- 8. Identification Types ---
create_csv "08_identification_types.csv" \
"id,name
a9b0c1d2-e3f4-a5b6-c7d8-e9f0a1b2c3d4,\"National ID\"
b8a9b0c1-d2e3-f4a5-b6c7-d8e9f0a1b2c3,\"Passport\"
c7d8e9f0-a1b2-c3d4-e5f6-a7b8c9d0e1f2,\"Foreign ID\""

# --- 9. Vacation Types ---
create_csv "09_vacation_types.csv" \
"id,name
d6e7f8a9-b0c1-d2e3-f4a5-b6c7d8e9f0a1,\"Statutory\"
c5d6e7f8-9a0b-1c2d-3e4f-5a6b7c8d9e0f,\"Compensatory\""

# --- 10. Access Levels ---
create_csv "10_access_levels.csv" \
"id,name,description
238eea1a-bd37-4d64-9505-44126f1dcdb3,\"User\",\"Basic user access\"
bc187d7c-8533-482e-a420-38d31262f6c8,\"Admin\",\"Full system access\""

# --- 11. Users to Create ---
create_csv "11_users_to_create.csv" \
"employee_code,first_name,last_name,email,password,hire_date,headquarters_name,status_name,access_level_name,role_name,salary_amount,effective_date
ADMIN-001,Admin,User,admin@nexus.com,password123,2022-01-10,\"Main Office\",Active,Admin,Admin,90000.00,2022-01-10
MAN-001,Moises,Pereira,moises@nexus.com,password123,2022-06-15,\"Main Office\",Active,User,Manager,75000.00,2022-06-15
EMP-001,Ana,Lopez,ana@nexus.com,password123,2023-02-20,\"Main Office\",Active,User,Employee,55000.00,2023-02-20
EMP-002,Carlos,Ruiz,carlos@nexus.com,password123,2023-03-01,\"Main Office\",Active,User,Employee,58000.00,2023-03-01
EMP-003,Sofia,Mendez,sofia@nexus.com,password123,2023-05-18,Remote,Active,User,Employee,62000.00,2023-05-18"

echo -e "\n${GREEN}🎉 All CSV seed files have been generated in the '${DATA_DIR}' directory.${NC}"