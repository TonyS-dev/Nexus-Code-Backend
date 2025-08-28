#!/bin/bash

# --- Colors for Output ---
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${BLUE}====================================================${NC}"
echo -e "${BLUE}🚀 Restarting and Repopulating the Database... 🚀${NC}"
echo -e "${BLUE}====================================================${NC}"

# --- Step 1: Stop and Clean EVERYTHING ---
echo -e "\n${YELLOW}🛑 1/4: Stopping and removing old containers, networks, and volumes...${NC}"
# The -v flag is CRUCIAL. It deletes the database volume.
docker compose down -v
if [ $? -ne 0 ]; then
    echo -e "${RED}❌ Failed to stop the environment. Aborting.${NC}"
    exit 1
fi
echo -e "${GREEN}✅ Environment cleaned.${NC}"


# --- Step 2: Rebuild and Start Again ---
echo -e "\n${YELLOW}🏗️  2/4: Building and starting new containers...${NC}"
docker compose -f docker-compose.yml -f docker-compose.dev.yml up --build -d
if [ $? -ne 0 ]; then
    echo -e "${RED}❌ Failed to start containers. Check Docker logs.${NC}"
    exit 1
fi
echo -e "${GREEN}✅ Containers started.${NC}"


# --- Step 3: Wait for the API to be healthy ---
echo -e "\n${YELLOW}⏳ 3/4: Waiting for the API to be ready to accept connections...${NC}"
sleep 15 # Increased wait to ensure everything is initialized.


# --- Step 4: (Optional) Run an API Seeder if needed ---
#
# echo -e "\n${YELLOW}🌱 4/4: Running the API seeder (creating users)...${NC}"
# python3 api_seeder.py
# if [ $? -ne 0 ]; then
#     echo -e "${RED}❌ API seeder failed. Check its logs.${NC}"
#     exit 1
# fi
# echo -e "${GREEN}✅ API seeder completed.${NC}"


echo -e "\n${GREEN}🎉 Process completed! The database has been restarted and repopulated.${NC}"
echo -e "${BLUE}   Backend available at: http://localhost:3001${NC}"
echo -e "${BLUE}   Database available at: localhost:5435${NC}"