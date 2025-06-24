#!/bin/bash

# Load colors...
if [[ -t 1 ]]; then
    C_CYAN=$'\033[1;36m'
    C_YELLOW=$'\033[1;33m'
    C_GREEN=$'\033[1;32m'
    C_BLUE=$'\033[1;34m'
    C_RED=$'\033[1;31m'
    C_RESET=$'\033[0m'
else
    C_CYAN=''
    C_YELLOW=''
    C_GREEN=''
    C_BLUE=''
    C_RED=''
    C_RESET=''
fi
# Help doc example:
function help() {
    cat <<EOF
${C_CYAN}new.sh:${C_RESET} Create directories and files with a new path prefix

${C_YELLOW}Usage:${C_RESET}
  ${C_GREEN}new.sh${C_RESET} [${C_BLUE}-d dir${C_RESET}]... [${C_BLUE}-f file [content]${C_RESET}]... [${C_BLUE}path ["file content"]${C_RESET}]...

${C_YELLOW}Options:${C_RESET}
  ${C_BLUE}-d dir${C_RESET}        Create a new directory with the specified path
  ${C_BLUE}-f file${C_RESET}       Create a new file (with optional content)
  ${C_BLUE}path${C_RESET}          Create file or directory under \$HOME/new/
  ${C_BLUE}-h, --help${C_RESET}    Show this help message and exit
  ${C_BLUE}--usage${C_RESET}       Show usage summary and exit

${C_YELLOW}Quoted string content:${C_RESET}
  - Use "\\n" for newlines
  - Use "\\t" for tabs
  - Use "\\\`" to escape backticks

${C_YELLOW}Examples:${C_RESET}
  ${C_GREEN}new.sh -d foo -f bar/baz.txt${C_RESET}
  ${C_GREEN}new.sh foo/bar/baz.txt${C_RESET}
  ${C_GREEN}new.sh notes/todo.md "- [ ] Call mom\\n- [ ] Buy eggs"${C_RESET}
  ${C_GREEN}new.sh taku/todo/test.md "# Tests\\n\\n1. Run \`yarn test\`."${C_RESET}
EOF
}



# Pseudocode
# This script initializes a new project with a structured setup including frontend, backend, and CLI components.
# It prompts the user for various configurations and sets up the project structure accordingly.
# This script is intended to be run in a terminal environment with bash or zsh.

# initialize git
# prompt user for name of project (defaults to name of directory — like U.P.D.A.T.E.)
# Other prompts...
#   - frontend framework (ie. react)
#     - dependencies (npm, yarn, etc.)
#   - backend framework (ie. rust)
#     - dependencies (cargo, etc.)
#   - cli framework (ie. shellscript, javascript, etc.)
#     - dependencies (brew, apt, apt-get, etc.)

# Initialize .gitattributes

# .gitattributes for Git LFS tracking of non-code large files

cat <<EOF > .gitattributes

# Images
*.jpg filter=lfs diff=lfs merge=lfs -text
*.jpeg filter=lfs diff=lfs merge=lfs -text
*.png filter=lfs diff=lfs merge=lfs -text
*.tiff filter=lfs diff=lfs merge=lfs -text
*.tif filter=lfs diff=lfs merge=lfs -text
*.bmp filter=lfs diff=lfs merge=lfs -text
*.gif filter=lfs diff=lfs merge=lfs -text
*.webp filter=lfs diff=lfs merge=lfs -text
*.heic filter=lfs diff=lfs merge=lfs -text
*.ico filter=lfs diff=lfs merge=lfs -text
*.raw filter=lfs diff=lfs merge=lfs -text
*.svg filter=lfs diff=lfs merge=lfs -text

# Videos
*.mp4 filter=lfs diff=lfs merge=lfs -text
*.mov filter=lfs diff=lfs merge=lfs -text
*.avi filter=lfs diff=lfs merge=lfs -text
*.mkv filter=lfs diff=lfs merge=lfs -text
*.webm filter=lfs diff=lfs merge=lfs -text
*.flv filter=lfs diff=lfs merge=lfs -text
*.wmv filter=lfs diff=lfs merge=lfs -text
*.m4v filter=lfs diff=lfs merge=lfs -text

# Audio
*.mp3 filter=lfs diff=lfs merge=lfs -text
*.wav filter=lfs diff=lfs merge=lfs -text
*.ogg filter=lfs diff=lfs merge=lfs -text
*.flac filter=lfs diff=lfs merge=lfs -text
*.m4a filter=lfs diff=lfs merge=lfs -text
*.aiff filter=lfs diff=lfs merge=lfs -text
*.aac filter=lfs diff=lfs merge=lfs -text
*.opus filter=lfs diff=lfs merge=lfs -text
*.mid filter=lfs diff=lfs merge=lfs -text
*.midi filter=lfs diff=lfs merge=lfs -text

# Documents
*.pdf filter=lfs diff=lfs merge=lfs -text
*.doc filter=lfs diff=lfs merge=lfs -text
*.docx filter=lfs diff=lfs merge=lfs -text
*.ppt filter=lfs diff=lfs merge=lfs -text
*.pptx filter=lfs diff=lfs merge=lfs -text
*.odt filter=lfs diff=lfs merge=lfs -text
*.ods filter=lfs diff=lfs merge=lfs -text
*.odp filter=lfs diff=lfs merge=lfs -text

# Archives / Bundles
*.zip filter=lfs diff=lfs merge=lfs -text
*.rar filter=lfs diff=lfs merge=lfs -text
*.7z filter=lfs diff=lfs merge=lfs -text
*.tar filter=lfs diff=lfs merge=lfs -text
*.gz filter=lfs diff=lfs merge=lfs -text
*.xz filter=lfs diff=lfs merge=lfs -text
*.bz2 filter=lfs diff=lfs merge=lfs -text
*.tgz filter=lfs diff=lfs merge=lfs -text
*.lz filter=lfs diff=lfs merge=lfs -text
*.lzma filter=lfs diff=lfs merge=lfs -text
*.zst filter=lfs diff=lfs merge=lfs -text

# 3D / Design / Fonts
*.psd filter=lfs diff=lfs merge=lfs -text
*.ai filter=lfs diff=lfs merge=lfs -text
*.eps filter=lfs diff=lfs merge=lfs -text
*.xd filter=lfs diff=lfs merge=lfs -text
*.sketch filter=lfs diff=lfs merge=lfs -text
*.blend filter=lfs diff=lfs merge=lfs -text
*.fbx filter=lfs diff=lfs merge=lfs -text
*.obj filter=lfs diff=lfs merge=lfs -text
*.stl filter=lfs diff=lfs merge=lfs -text
*.3ds filter=lfs diff=lfs merge=lfs -text
*.ttf filter=lfs diff=lfs merge=lfs -text
*.otf filter=lfs diff=lfs merge=lfs -text
*.woff filter=lfs diff=lfs merge=lfs -text
*.woff2 filter=lfs diff=lfs merge=lfs -text

# Game / Binary Assets
*.unity filter=lfs diff=lfs merge=lfs -text
*.uasset filter=lfs diff=lfs merge=lfs -text
*.pak filter=lfs diff=lfs merge=lfs -text
*.gltf filter=lfs diff=lfs merge=lfs -text
*.glb filter=lfs diff=lfs merge=lfs -text
*.dat filter=lfs diff=lfs merge=lfs -text
*.bin filter=lfs diff=lfs merge=lfs -text
*.iso filter=lfs diff=lfs merge=lfs -text
*.img filter=lfs diff=lfs merge=lfs -text

# App Assets
*.icns filter=lfs diff=lfs merge=lfs -text
*.dmg filter=lfs diff=lfs merge=lfs -text
*.apk filter=lfs diff=lfs merge=lfs -text
*.ipa filter=lfs diff=lfs merge=lfs -text
*.exe filter=lfs diff=lfs merge=lfs -text
*.msi filter=lfs diff=lfs merge=lfs -text
EOF

# Get project name (default to current directory name)
PROJECT_NAME=$(basename "$(pwd)")
echo "${C_CYAN}Project name:${C_RESET} ${PROJECT_NAME}"

# For existing projects, offer to update/enhance structure
if [[ "$EXISTING_PROJECT" == "true" ]]; then
    echo "${C_YELLOW}Would you like to enhance the existing project structure? (y/n)${C_RESET}"
    read -p "Continue? [y/N]: " enhance_existing
    if [[ ! "$enhance_existing" =~ ^[Yy]$ ]]; then
        echo "Exiting without changes."
        exit 0
    fi
    echo "${C_GREEN}Enhancing existing project...${C_RESET}"
fi

# Check if we're in an existing project
EXISTING_PROJECT=false
if [[ -d "src" || -f "main.sh" || -d "dist" ]]; then
    EXISTING_PROJECT=true
    echo "${C_YELLOW}Existing project detected!${C_RESET}"
    echo "Found existing structure. Will apply changes without overwriting existing files."
    echo ""
fi

# Function to safely create file (only if it doesn't exist)
safe_create_file() {
    local filepath="$1"
    local content="$2"
    
    if [[ -f "$filepath" ]]; then
        echo "${C_YELLOW}Skipping $filepath (already exists)${C_RESET}"
        return 1
    else
        echo "$content" > "$filepath"
        echo "${C_GREEN}Created $filepath${C_RESET}"
        return 0
    fi
}

# Function to safely append to file
safe_append_file() {
    local filepath="$1"
    local content="$2"
    local marker="$3"
    
    if [[ -f "$filepath" ]] && grep -q "$marker" "$filepath"; then
        echo "${C_YELLOW}Skipping append to $filepath (marker already exists)${C_RESET}"
        return 1
    else
        echo "$content" >> "$filepath"
        echo "${C_GREEN}Appended to $filepath${C_RESET}"
        return 0
    fi
}

# Function to merge package.json dependencies
merge_package_json() {
    local new_deps="$1"
    
    if [[ -f "package.json" ]]; then
        echo "${C_YELLOW}Merging dependencies into existing package.json${C_RESET}"
        # Use a simple approach - just notify user of what should be added
        echo "${C_CYAN}Please manually add these devDependencies to package.json:${C_RESET}"
        echo "$new_deps"
    else
        return 1  # File doesn't exist, caller will create it
    fi
}

# Prompt user for frontend framework
echo "${C_YELLOW}Choose frontend framework:${C_RESET}"
echo "1) React (default)"
echo "2) Vue"
echo "3) Svelte"
echo "4) None"
read -p "Enter choice [1-4]: " frontend_choice
case $frontend_choice in
    2) FRONTEND="vue" ;;
    3) FRONTEND="svelte" ;;
    4) FRONTEND="none" ;;
    *) FRONTEND="react" ;;
esac

# Prompt user for backend framework
echo "${C_YELLOW}Choose backend framework:${C_RESET}"
echo "1) Rust (default)"
echo "2) Node.js"
echo "3) Python"
echo "4) None"
read -p "Enter choice [1-4]: " backend_choice
case $backend_choice in
    2) BACKEND="nodejs" ;;
    3) BACKEND="python" ;;
    4) BACKEND="none" ;;
    *) BACKEND="rust" ;;
esac

# Prompt user for CLI framework
echo "${C_YELLOW}Choose CLI framework:${C_RESET}"
echo "1) Shell script (default)"
echo "2) JavaScript/Node.js"
echo "3) Rust"
echo "4) None"
read -p "Enter choice [1-4]: " cli_choice
case $cli_choice in
    2) CLI="javascript" ;;
    3) CLI="rust" ;;
    4) CLI="none" ;;
    *) CLI="shell" ;;
esac

# Initialize frontend
if [[ "$FRONTEND" != "none" ]]; then
    echo "${C_GREEN}Setting up frontend ($FRONTEND)...${C_RESET}"
    
    # For existing projects, check if frontend already exists
    if [[ "$EXISTING_PROJECT" == "true" && (-d "frontend" || -d "src/frontend") ]]; then
        echo "${C_YELLOW}Frontend directory already exists. Enhancing configuration...${C_RESET}"
        FRONTEND_DIR=$([ -d "frontend" ] && echo "frontend" || echo "src/frontend")
    else
        mkdir -p frontend
        FRONTEND_DIR="frontend"
    fi
    
    cd "$FRONTEND_DIR" || exit 1
    
    # Only run setup if package.json doesn't exist
    if [[ ! -f "package.json" ]]; then
        case $FRONTEND in
            "react")
                npm create react-app . --template typescript
                npm install -D tailwindcss postcss autoprefixer
                npx tailwindcss init -p
                ;;
            "vue")
                npm create vue@latest . -- --typescript --pwa --router --pinia
                npm install -D tailwindcss postcss autoprefixer
                npx tailwindcss init -p
                ;;
            "svelte")
                npm create svelte@latest .
                npm install -D tailwindcss postcss autoprefixer @tailwindcss/typography
                npx tailwindcss init -p
                ;;
        esac
    else
        echo "${C_YELLOW}Frontend package.json exists. Install Tailwind manually if needed:${C_RESET}"
        echo "npm install -D tailwindcss postcss autoprefixer"
    fi
    cd .. || exit 1
fi

# Initialize backend
if [[ "$BACKEND" != "none" ]]; then
    echo "${C_GREEN}Setting up backend ($BACKEND)...${C_RESET}"
    
    # For existing projects, check if backend already exists
    if [[ "$EXISTING_PROJECT" == "true" && (-d "backend" || -d "src/backend") ]]; then
        echo "${C_YELLOW}Backend directory already exists. Enhancing configuration...${C_RESET}"
        BACKEND_DIR=$([ -d "backend" ] && echo "backend" || echo "src/backend")
    else
        mkdir -p backend
        BACKEND_DIR="backend"
    fi
    
    cd "$BACKEND_DIR" || exit 1
    
    case $BACKEND in
        "rust")
            if [[ ! -f "Cargo.toml" ]]; then
                cargo init --name "${PROJECT_NAME}-backend"
            fi
            # Add common dependencies to Cargo.toml if they don't exist
            if ! grep -q "tokio" Cargo.toml 2>/dev/null; then
                cat >> Cargo.toml << 'CARGO_EOF'

[dependencies]
tokio = { version = "1.0", features = ["full"] }
serde = { version = "1.0", features = ["derive"] }
serde_json = "1.0"
CARGO_EOF
            fi
            ;;
        "nodejs")
            if [[ ! -f "package.json" ]]; then
                npm init -y
                npm install express cors helmet morgan
                npm install -D @types/node @types/express typescript ts-node nodemon
            else
                echo "${C_YELLOW}Backend package.json exists. Install dependencies manually if needed:${C_RESET}"
                echo "npm install express cors helmet morgan"
            fi
            ;;
        "python")
            if [[ ! -f "requirements.txt" ]]; then
                python -m venv venv
                source venv/bin/activate
                echo "fastapi[all]\nuvicorn[standard]\npydantic\nsqlalchemy" > requirements.txt
                pip install -r requirements.txt
            else
                echo "${C_YELLOW}Backend requirements.txt exists. Consider adding:${C_RESET}"
                echo "fastapi[all], uvicorn[standard], pydantic, sqlalchemy"
            fi
            ;;
    esac
    cd .. || exit 1
fi

# Initialize CLI
if [[ "$CLI" != "none" ]]; then
    echo "${C_GREEN}Setting up CLI ($CLI)...${C_RESET}"
    
    # For existing projects, check if CLI already exists
    if [[ "$EXISTING_PROJECT" == "true" && (-d "cli" || -d "src/cli") ]]; then
        echo "${C_YELLOW}CLI directory already exists. Enhancing configuration...${C_RESET}"
        CLI_DIR=$([ -d "cli" ] && echo "cli" || echo "src/cli")
        mkdir -p "$CLI_DIR"  # Ensure it exists
    else
        mkdir -p cli
        CLI_DIR="cli"
    fi
    
    case $CLI in
        "shell")
            safe_create_file "$CLI_DIR/main.sh" '#!/bin/bash

# CLI for '"${PROJECT_NAME}"'
# Add your CLI logic here

echo "CLI initialized"'
            if [[ -f "$CLI_DIR/main.sh" ]]; then
                chmod +x "$CLI_DIR/main.sh"
            fi
            ;;
        "javascript")
            cd "$CLI_DIR" || exit 1
            if [[ ! -f "package.json" ]]; then
                npm init -y
                npm install commander inquirer chalk
            fi
            safe_create_file "main.js" '#!/usr/bin/env node

const { Command } = require('\''commander'\'');
const program = new Command();

program
  .name('\'''"${PROJECT_NAME}"''\'')
  .description('\''CLI for '"${PROJECT_NAME}"''\'')
  .version('\''1.0.0'\'');

program.parse();'
            if [[ -f "main.js" ]]; then
                chmod +x main.js
            fi
            cd .. || exit 1
            ;;
        "rust")
            cd "$CLI_DIR" || exit 1
            if [[ ! -f "Cargo.toml" ]]; then
                cargo init --name "${PROJECT_NAME}-cli"
                # Add clap dependency
                cat >> Cargo.toml << 'CARGO_EOF'

[dependencies]
clap = { version = "4.0", features = ["derive"] }
CARGO_EOF
            fi
            cd .. || exit 1
            ;;
    esac
fi

# Create main.sh in root (only if it doesn't exist or is different)
echo "${C_GREEN}Creating main entry point...${C_RESET}"
MAIN_CONTENT='#!/bin/bash

# Main entry point for '"${PROJECT_NAME}"'

# Source CLI if it exists
if [[ -f "cli/main.sh" ]]; then
    source cli/main.sh "$@"
elif [[ -f "src/cli/main.sh" ]]; then
    source src/cli/main.sh "$@"
elif [[ -f "cli/main.js" ]]; then
    node cli/main.js "$@"
elif [[ -f "src/cli/main.js" ]]; then
    node src/cli/main.js "$@"
else
    echo "No CLI found"
    exit 1
fi'

if ! safe_create_file "main.sh" "$MAIN_CONTENT"; then
    echo "${C_YELLOW}Checking if main.sh needs updates...${C_RESET}"
    # Check if existing main.sh has the new CLI paths
    if ! grep -q "src/cli/main" main.sh 2>/dev/null; then
        echo "${C_CYAN}Consider updating main.sh to include src/cli/ paths${C_RESET}"
    fi
fi
chmod +x main.sh 2>/dev/null

# Create .gitignore
echo "${C_GREEN}Creating .gitignore...${C_RESET}"
GITIGNORE_CONTENT='# Dependencies
node_modules/
npm-debug.log*
yarn-debug.log*
yarn-error.log*

# Build outputs
dist/
build/
target/

# Environment files
.env
.env.local
.env.development.local
.env.test.local
.env.production.local

# IDE files
.vscode/
.idea/
*.swp
*.swo

# OS files
.DS_Store
Thumbs.db

# Logs
logs
*.log

# Runtime data
pids
*.pid
*.seed
*.pid.lock

# Python
__pycache__/
*.py[cod]
*$py.class
venv/
env/

# Rust
target/
Cargo.lock'

if ! safe_create_file ".gitignore" "$GITIGNORE_CONTENT"; then
    # Append missing patterns to existing .gitignore
    safe_append_file ".gitignore" "

# Added by project setup script
dist/
target/
.env*
node_modules/" "# Added by project setup script"
fi

# Create README.md with KaTeX Big O notation
echo "${C_GREEN}Creating README.md...${C_RESET}"
README_CONTENT='# '"${PROJECT_NAME}"'

## Overview

This project includes a structured setup with frontend, backend, and CLI components.

## CLI Parser Complexity

The default CLI parser has a time complexity of:

$$O(n \log n)$$

Where $n$ is the number of command-line arguments.

## Project Structure

```
.
├── frontend/          # Frontend application
├── backend/           # Backend services  
├── cli/              # Command-line interface
├── main.sh           # Main entry point
└── README.md         # This file
```

## Getting Started

1. Run the main script: `./main.sh`
2. For development, see individual component READMEs

## Development

This project uses:
- Git LFS for large files
- Husky for git hooks
- ggshield for secret scanning
- Semantic commit conventions'

safe_create_file "README.md" "$README_CONTENT"

# Create package.json for the root project
echo "${C_GREEN}Creating package.json...${C_RESET}"
PACKAGE_CONTENT='{
  "name": "'"${PROJECT_NAME}"'",
  "version": "1.0.0",
  "description": "Multi-component project with frontend, backend, and CLI",
  "main": "main.sh",
  "scripts": {
    "start": "./main.sh",
    "prepare": "husky install"
  },
  "devDependencies": {
    "husky": "^8.0.0"
  },
  "repository": {
    "type": "git",
    "url": "git+https://github.com/user/'"${PROJECT_NAME}"'.git"
  },
  "author": "",
  "license": "MIT"
}'

if ! safe_create_file "package.json" "$PACKAGE_CONTENT"; then
    merge_package_json '"husky": "^8.0.0", "@commitlint/cli": "^17.0.0", "@commitlint/config-conventional": "^17.0.0"'
fi

# Install husky if npm is available and package.json exists
if command -v npm &> /dev/null && [[ -f "package.json" ]]; then
    echo "${C_GREEN}Installing husky...${C_RESET}"
    
    # Check if husky is already installed
    if ! npm list husky &> /dev/null; then
        npm install
    fi
    
    # Initialize husky if not already done
    if [[ ! -d ".husky" ]]; then
        npx husky install
        
        # Create commit-msg hook for semantic commits
        npx husky add .husky/commit-msg 'npx --no -- commitlint --edit "$1"'
        
        # Create pre-commit hook for ggshield
        if command -v ggshield &> /dev/null; then
            echo "${C_GREEN}Setting up ggshield pre-commit hook...${C_RESET}"
            npx husky add .husky/pre-commit 'ggshield secret scan pre-commit'
        else
            echo "${C_YELLOW}ggshield not found. Install it with: pip install detect-secrets${C_RESET}"
            npx husky add .husky/pre-commit 'echo "ggshield not installed - skipping secret scan"'
        fi
        
        # Install commitlint if not in existing package.json
        if ! npm list @commitlint/cli &> /dev/null; then
            npm install -D @commitlint/cli @commitlint/config-conventional
        fi
        
        # Create commitlint config
        safe_create_file ".commitlintrc.json" '{
  "extends": ["@commitlint/config-conventional"],
  "rules": {
    "type-enum": [
      2,
      "always",
      [
        "feat",
        "fix",
        "docs",
        "style",
        "refactor",
        "perf",
        "test",
        "chore",
        "ci",
        "build"
      ]
    ]
  }
}'
    else
        echo "${C_YELLOW}Husky already configured${C_RESET}"
    fi
else
    echo "${C_YELLOW}npm not found or package.json missing. Skipping husky setup.${C_RESET}"
fi

echo "${C_GREEN}Project ${EXISTING_PROJECT:+enhancement }completed successfully!${C_RESET}"
echo "${C_CYAN}Next steps:${C_RESET}"

if [[ "$EXISTING_PROJECT" == "true" ]]; then
    echo "1. Review new/updated files and configurations"
    echo "2. Test your enhanced project: ${C_BLUE}./main.sh${C_RESET}"
    if [[ ! -d ".git" ]]; then
        echo "3. Initialize git: ${C_BLUE}git init${C_RESET}"
        echo "4. Add files: ${C_BLUE}git add .${C_RESET}"
        echo "5. Initial commit: ${C_BLUE}git commit -m \"feat: enhance project structure\"${C_RESET}"
    else
        echo "3. Add changes: ${C_BLUE}git add .${C_RESET}"
        echo "4. Commit changes: ${C_BLUE}git commit -m \"feat: enhance project structure\"${C_RESET}"
    fi
else
    echo "1. Initialize git: ${C_BLUE}git init${C_RESET}"
    echo "2. Add files: ${C_BLUE}git add .${C_RESET}"
    echo "3. Initial commit: ${C_BLUE}git commit -m \"feat: initial project setup\"${C_RESET}"
    echo "4. Run the project: ${C_BLUE}./main.sh${C_RESET}"
fi
