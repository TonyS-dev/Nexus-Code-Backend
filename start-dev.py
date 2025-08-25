# start-dev.py
import subprocess
import sys
import os

# --- ANSI Color Codes for Output ---
GREEN = '\033[92m'
YELLOW = '\033[93m'
BLUE = '\033[94m'
RED = '\033[91m'
ENDC = '\033[0m'

def print_message(message, color=ENDC):
    """Prints a message in the specified color."""
    print(f"{color}{message}{ENDC}")

def run_command(command, capture_output=False):
    """Executes a shell command and exits on failure."""
    try:
        print_message(f"▶️  Running: {' '.join(command)}", YELLOW)
        subprocess.run(command, check=True, capture_output=capture_output, text=True)
    except subprocess.CalledProcessError as e:
        print_message(f"❌ Error executing command: {e}", RED)
        sys.exit(1)
    except FileNotFoundError:
        print_message(f"❌ Command not found: {command[0]}. Is Docker installed and in your PATH?", RED)
        sys.exit(1)

def main():
    """Main script function."""
    print_message("===========================================", BLUE)
    print_message("🚀 Starting Nexus Development Environment...", BLUE)
    print_message("===========================================", BLUE)

    # Define the Docker Compose command for development
    compose_command = [
        "docker", "compose",
        "-f", "docker-compose.yml",
        "-f", "docker-compose.dev.yml",
        "up",
        "--build",
        "-d"
    ]
    
    run_command(compose_command)

    print_message("\n✅ Development environment started successfully!", GREEN)
    
    db_port = os.getenv('DB_PORT', '5432')
    backend_port = os.getenv('BACKEND_PORT', '3000')

    print_message("\n--- Service Access ---", BLUE)
    print_message(f"📦 Database (PostgreSQL) available at: {YELLOW}localhost:{db_port}{ENDC}")
    print_message(f"⚙️  Backend API available at: {YELLOW}http://localhost:{backend_port}{ENDC}")

    print_message("\n--- Useful Commands ---", BLUE)
    print_message(f"📋 View real-time logs: {YELLOW}docker compose logs -f{ENDC}")
    print_message(f"🛑 Stop the environment: {YELLOW}python stop-dev.py{ENDC}")

if __name__ == "__main__":
    main()