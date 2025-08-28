# /api_seeder.py
import requests
import csv
import sys

# --- Configuration ---
API_URL = "http://localhost:3000"
USERS_CSV_PATH = "backend/data/11_users_to_create.csv"

# --- ANSI Colors ---
GREEN = '\033[92m'
YELLOW = '\033[93m'
RED = '\033[91m'
ENDC = '\033[0m'

def fetch_catalog_ids():
    """Fetches all necessary catalog UUIDs from the running API."""
    print(f"{YELLOW}Fetching catalog IDs from the API...{ENDC}")
    try:
        # Make all requests in parallel
        catalogs = {
            "roles": {item['name']: item['id'] for item in requests.get(f"{API_URL}/roles").json()},
            "headquarters": {item['name']: item['id'] for item in requests.get(f"{API_URL}/headquarters").json()},
            "employee_statuses": {item['name']: item['id'] for item in requests.get(f"{API_URL}/employee-statuses").json()},
            "access_levels": {item['name']: item['id'] for item in requests.get(f"{API_URL}/access-levels").json()},
        }
        print(f"{GREEN}✅ Catalogs fetched successfully.{ENDC}")
        return catalogs
    except requests.exceptions.RequestException as e:
        print(f"{RED}❌ Could not connect to the API at {API_URL}. Is the backend container running?{ENDC}")
        print(f"{RED}   Error: {e}{ENDC}")
        sys.exit(1)

def create_user(user_data, catalog_ids):
    """Creates a single user via the API."""
    try:
        # Translate readable names to UUIDs
        payload = {
            "employee_code": user_data["employee_code"],
            "first_name": user_data["first_name"],
            "last_name": user_data["last_name"],
            "email": user_data["email"],
            "password": user_data["password"],
            "hire_date": user_data["hire_date"],
            "headquarters_id": catalog_ids["headquarters"].get(user_data["headquarters_name"]),
            "status_id": catalog_ids["employee_statuses"].get(user_data["status_name"]),
            "access_level_id": catalog_ids["access_levels"].get(user_data["access_level_name"]),
            "role_id": catalog_ids["roles"].get(user_data["role_name"])
        }
        
        # Call the registration endpoint (public)
        response = requests.post(f"{API_URL}/auth/register", json=payload)
        
        # Check the response
        if response.status_code == 201:
            print(f"   {GREEN}✅ Created user: {payload['email']}{ENDC}")
        else:
            print(f"   {RED}❌ Failed to create user {payload['email']}: {response.status_code} - {response.text}{ENDC}")

    except Exception as e:
        print(f"   {RED}❌ An unexpected error occurred for user {user_data['email']}: {e}{ENDC}")


def main():
    """Main execution function."""
    print(f"{YELLOW}--- Starting API Seeder ---{ENDC}")
    
    catalog_ids = fetch_catalog_ids()
    
    print(f"{YELLOW}Reading users from {USERS_CSV_PATH}...{ENDC}")
    with open(USERS_CSV_PATH, mode='r') as csvfile:
        reader = csv.DictReader(csvfile)
        for row in reader:
            create_user(row, catalog_ids)
            
    print(f"{YELLOW}--- API Seeder Finished ---{ENDC}")


if __name__ == "__main__":
    main()