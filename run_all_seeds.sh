#!/bin/bash

# =======================================================================
#               FULL DATABASE SEED ORCHESTRATOR
# This script runs both seeding phases in the correct order.
# =======================================================================

# --- Colors ---
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

# --- Helper function to check if a command exists ---
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

echo -e "${BLUE}--- Starting Full Seed Process ---${NC}"

# --- Prerequisite Check ---
if ! command_exists python3; then
    echo -e "${RED}❌ Prerequisite missing: 'python3' command not found.${NC}"
    echo -e "${YELLOW}   Please install Python 3 to run the API seeder.${NC}"
    exit 1
fi
if ! command_exists docker; then
    echo -e "${RED}❌ Prerequisite missing: 'docker' command not found.${NC}"
    exit 1
fi


# --- Phase 1: Foundational Seeding (Catalogs via Node.js) ---
echo -e "\n${YELLOW}PHASE 1: Seeding catalog tables...${NC}"
# 'docker compose exec' runs a command inside a running container
docker compose exec backend npm run seed
if [ $? -ne 0 ]; then
    echo -e "${RED}❌ Phase 1 (Catalog Seeding) failed. Aborting.${NC}"
    exit 1
fi
echo -e "${GREEN}✅ Phase 1 complete.${NC}"


# --- Phase 2: Application-Layer Seeding (Users via Python API Client) ---
echo -e "\n${YELLOW}PHASE 2: Seeding users via API...${NC}"
# Run the Python script that calls the API
python3 api_seeder.py
if [ $? -ne 0 ]; then
    echo -e "${RED}❌ Phase 2 (API Seeding) failed. Check logs above.${NC}"
    exit 1
fi
echo -e "${GREEN}✅ Phase 2 complete.${NC}"

echo -e "\n${BLUE}🎉 Full seed process finished successfully!${NC}"