# /api_seeder.py
import requests
import csv
import sys
import os

# --- Configuration ---
API_URL = os.getenv("API_URL", "http://localhost:3000")
USERS_CSV_PATH = "backend/data/11_users_to_create.csv"

# --- ANSI Colors ---
GREEN = '\033[92m'
YELLOW = '\033[93m'
RED = '\033[91m'
BLUE = '\033[94m'
ENDC = '\033[0m'

class ApiClient:
    """A simple client to interact with the API, handling authentication."""
    def __init__(self, base_url):
        self.base_url = base_url
        self.token = None
        self.user = None

    def _get_headers(self):
        headers = {'Content-Type': 'application/json'}
        if self.token:
            headers['Authorization'] = f'Bearer {self.token}'
        return headers

    def post(self, endpoint, payload):
        response = requests.post(f"{self.base_url}{endpoint}", json=payload, headers=self._get_headers())
        response.raise_for_status()
        return response.json()

    def get(self, endpoint):
        response = requests.get(f"{self.base_url}{endpoint}", headers=self._get_headers())
        response.raise_for_status()
        return response.json()

    def login(self, email, password):
        print(f"   -> Logging in as {email}...")
        data = self.post("/auth/login", {"email": email, "password": password})
        self.token = data.get("token")
        self.user = data.get("user")
        if self.token:
            print(f"   {GREEN}✅ Login successful.{ENDC}")
        else:
            print(f"   {RED}❌ Login failed.{ENDC}")

def fetch_catalog_ids(client):
    """Fetches all necessary catalog UUIDs from the running API."""
    print(f"{YELLOW}Fetching catalog IDs...{ENDC}")
    try:
        catalogs = {
            "roles": {item['name']: item['id'] for item in client.get("/roles")},
            "headquarters": {item['name']: item['id'] for item in client.get("/headquarters")},
            "employee_statuses": {item['name']: item['id'] for item in client.get("/employee-statuses")},
            "access_levels": {item['name']: item['id'] for item in client.get("/access-levels")},
            "vacation_types": {item['name']: item['id'] for item in client.get("/vacation-types")},
        }
        print(f"{GREEN}✅ Catalogs fetched successfully.{ENDC}")
        return catalogs
    except requests.exceptions.RequestException as e:
        print(f"{RED}❌ Could not fetch catalogs. Is the API running and are routes public? Error: {e}{ENDC}")
        sys.exit(1)

def main():
    """Main execution function."""
    print(f"{BLUE}--- Starting API Seeder ---{ENDC}")
    
    api = ApiClient(API_URL)
    catalog_ids = fetch_catalog_ids(api)
    
    print(f"{YELLOW}Creating initial users from {USERS_CSV_PATH}...{ENDC}")
    users_to_seed = []
    try:
        with open(USERS_CSV_PATH, mode='r', encoding='utf-8') as csvfile:
            reader = csv.DictReader(csvfile)
            users_to_seed = list(reader)
    except FileNotFoundError:
        print(f"{RED}❌ Error: CSV file not found at {USERS_CSV_PATH}.{ENDC}")
        sys.exit(1)

    # Create users
    created_users = {}
    for user_data in users_to_seed:
        try:
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
                "role_id": catalog_ids["roles"].get(user_data["role_name"]),
                "salary_amount": user_data.get("salary_amount"),
                "effective_date": user_data.get("effective_date"),
            }
            response = api.post("/auth/register", payload)
            created_users[payload['email']] = response['user']
            print(f"   {GREEN}✅ Created user: {payload['email']}{ENDC}")
        except requests.exceptions.HTTPError as e:
            print(f"   {RED}❌ Failed to create user {user_data['email']}: {e.response.text}{ENDC}")
            
    # --- Create Activity Data via API ---
    print(f"\n{YELLOW}Creating activity data (requests, balances, etc.) via API...{ENDC}")
    
    try:
        # Login as Ana to create a request
        api.login("ana@nexus.com", "password123")
        if api.token:
            request_payload = {
                "request_type": "vacation",
                "status_id": "uuid-of-pending-status", # Get from the catalogs
                "vacation_type_id": catalog_ids["vacation_types"].get("Statutory"),
                "start_date": "2025-12-20",
                "end_date": "2025-12-30",
                "days_requested": 7,
                "comments": "Christmas vacation"
            }
            api.post(f"/requests", request_payload) # Using the POST /requests endpoint
            print(f"   {GREEN}✅ Created vacation request for Ana.{ENDC}")

        # Login as Moises to approve a request (simulated)
        api.login("moises@nexus.com", "password123")
        if api.token:
            # Fetch Ana's requests to approve
            print(f"   {GREEN}✅ Logged in as Moises to perform manager actions.{ENDC}")

    except Exception as e:
        print(f"{RED}❌ Error creating activity data: {e}{ENDC}")

    print(f"{BLUE}--- API Seeder Finished ---{ENDC}")

if __name__ == "__main__":
    main()