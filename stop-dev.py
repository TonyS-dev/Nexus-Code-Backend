# stop-dev.py
import subprocess
import sys
import os

# --- ANSI Color Codes for Output ---
YELLOW = '\033[93m'
BLUE = '\033[94m'
ENDC = '\033[0m'

def print_message(message, color=ENDC):
    """Prints a message in the specified color."""
    print(f"{color}{message}{ENDC}")

def run_command(command):
    """Executes a shell command, compatible with Windows."""
    try:
        print_message(f"▶️  Running: {' '.join(command)}", YELLOW)
        subprocess.run(command, check=True, shell=(os.name == 'nt'))
    except (subprocess.CalledProcessError, FileNotFoundError):
        print_message(f"⚠️  Could not execute command. Environment might already be down.", YELLOW)

def main():
    """Main script function."""
    print_message("=============================================", BLUE)
    print_message("🛑 Stopping Nexus Development Environment...", BLUE)
    print_message("=============================================", BLUE)

    compose_command = [
        "docker", "compose",
        "-f", "docker-compose.yml",
        "-f", "docker-compose.dev.yml",
        "down"
    ]
    
    run_command(compose_command)

    print_message("\n✅ Environment stopped.", YELLOW)

if __name__ == "__main__":
    main()