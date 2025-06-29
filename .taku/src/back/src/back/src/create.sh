#!/bin/bash
# create.sh - Project initialization script for taku
# Extracted from README.md and packaged into a single script

set -e  # Exit on any error

# Default values
PROJECT_NAME=""
PROJECT_PATH="."
FRONTEND_FRAMEWORK="react"
BACKEND_FRAMEWORK="rust"
CLI_FRAMEWORK="shellscript"
USE_TYPESCRIPT="true"
PACKAGE_MANAGER="yarn"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Helper functions
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Prompt for project details
prompt_user() {
    # Project name (defaults to directory name)
    if [ -z "$PROJECT_NAME" ]; then
        DEFAULT_NAME=$(basename "$(pwd)")
        read -p "Enter project name [$DEFAULT_NAME]: " PROJECT_NAME
        PROJECT_NAME=${PROJECT_NAME:-$DEFAULT_NAME}
    fi

    # Frontend framework
    echo "Select frontend framework:"
    echo "1) React (default)"
    echo "2) Vue"
    echo "3) Angular"
    read -p "Choice [1]: " frontend_choice
    case $frontend_choice in
        2) FRONTEND_FRAMEWORK="vue" ;;
        3) FRONTEND_FRAMEWORK="angular" ;;
        *) FRONTEND_FRAMEWORK="react" ;;
    esac

    # TypeScript/JavaScript
    read -p "Use TypeScript? [y/N]: " use_ts
    case $use_ts in
        [Yy]*) USE_TYPESCRIPT="true" ;;
        *) USE_TYPESCRIPT="false" ;;
    esac

    # Package manager
    echo "Select package manager:"
    echo "1) Yarn (default)"
    echo "2) npm"
    echo "3) pnpm"
    read -p "Choice [1]: " pm_choice
    case $pm_choice in
        2) PACKAGE_MANAGER="npm" ;;
        3) PACKAGE_MANAGER="pnpm" ;;
        *) PACKAGE_MANAGER="yarn" ;;
    esac

    # Backend framework
    echo "Select backend framework:"
    echo "1) Rust (default)"
    echo "2) Node.js"
    echo "3) Go"
    echo "4) Python"
    read -p "Choice [1]: " backend_choice
    case $backend_choice in
        2) BACKEND_FRAMEWORK="nodejs" ;;
        3) BACKEND_FRAMEWORK="go" ;;
        4) BACKEND_FRAMEWORK="python" ;;
        *) BACKEND_FRAMEWORK="rust" ;;
    esac

    # CLI framework
    echo "Select CLI framework:"
    echo "1) Shell script (default)"
    echo "2) JavaScript/Node.js"
    echo "3) Rust"
    read -p "Choice [1]: " cli_choice
    case $cli_choice in
        2) CLI_FRAMEWORK="javascript" ;;
        3) CLI_FRAMEWORK="rust" ;;
        *) CLI_FRAMEWORK="shellscript" ;;
    esac
}

# Create directory structure
create_directory_structure() {
    log_info "Creating directory structure..."
    
    if [ "$PROJECT_PATH" != "." ]; then
        mkdir -p "$PROJECT_PATH"
        cd "$PROJECT_PATH"
    fi

    mkdir -p frontend/src frontend/dist
    mkdir -p backend/src backend/dist
    mkdir -p cli/src cli/dist

    log_success "Directory structure created"
}

# Initialize Git with LFS
initialize_git() {
    log_info "Initializing Git repository..."
    
    # Check if git is available
    if ! command -v git &> /dev/null; then
        log_error "Git is not installed. Please install Git first."
        exit 1
    fi

    # Initialize git repo if not already initialized
    if [ ! -d ".git" ]; then
        git init
    fi

    # Install git-lfs if available
    if command -v brew &> /dev/null; then
        brew install git-lfs 2>/dev/null || log_warning "Could not install git-lfs via brew"
    fi

    # Configure git-lfs for common file types
    if command -v git-lfs &> /dev/null; then
        git lfs track "*.jpg"
        git lfs track "*.jpeg"
        git lfs track "*.png"
        git lfs track "*.tiff"
        git lfs track "*.ogg"
        git lfs track "*.zip"
        git lfs track "*.mid"
        git lfs track "*.pdf"
        log_success "Git LFS configured for binary files"
    else
        log_warning "Git LFS not available, skipping binary file tracking"
    fi

    log_success "Git repository initialized"
}

# Create main entry script
create_main_script() {
    log_info "Creating main entry script..."
    
    cat > main.sh << 'EOF'
#!/bin/bash
# Main entry point for the project
# This script orchestrates the CLI, backend, and frontend components

# Source the CLI main script and pass arguments
./cli/main.sh "$@"
EOF

    chmod +x main.sh
    log_success "Main script created"
}

# Initialize frontend
initialize_frontend() {
    log_info "Initializing frontend ($FRONTEND_FRAMEWORK)..."
    
    cd frontend

    case $FRONTEND_FRAMEWORK in
        "react")
            if [ "$USE_TYPESCRIPT" = "true" ]; then
                $PACKAGE_MANAGER create react-app . --template typescript
            else
                $PACKAGE_MANAGER create react-app .
            fi
            # Add additional dependencies
            $PACKAGE_MANAGER add tailwindcss postcss autoprefixer
            $PACKAGE_MANAGER add -D webpack webpack-cli webpack-dev-server
            ;;
        "vue")
            $PACKAGE_MANAGER create vue-app .
            ;;
        "angular")
            npx @angular/cli new . --routing=true --style=css
            ;;
    esac

    cd ..
    log_success "Frontend initialized"
}

# Initialize backend
initialize_backend() {
    log_info "Initializing backend ($BACKEND_FRAMEWORK)..."
    
    cd backend

    case $BACKEND_FRAMEWORK in
        "rust")
            if command -v cargo &> /dev/null; then
                cargo init .
            else
                log_error "Cargo not found. Please install Rust first."
                exit 1
            fi
            ;;
        "nodejs")
            npm init -y
            npm install express
            ;;
        "go")
            if command -v go &> /dev/null; then
                go mod init "$PROJECT_NAME-backend"
            else
                log_error "Go not found. Please install Go first."
                exit 1
            fi
            ;;
        "python")
            python3 -m venv venv
            echo "flask" > requirements.txt
            ;;
    esac

    cd ..
    log_success "Backend initialized"
}

# Initialize CLI
initialize_cli() {
    log_info "Initializing CLI ($CLI_FRAMEWORK)..."
    
    cd cli

    case $CLI_FRAMEWORK in
        "shellscript")
            cat > main.sh << 'EOF'
#!/bin/bash
# CLI main script

echo "Welcome to the CLI!"
echo "Arguments passed: $*"
EOF
            chmod +x main.sh
            ;;
        "javascript")
            cat > main.js << 'EOF'
#!/usr/bin/env node
// CLI main script

console.log("Welcome to the CLI!");
console.log("Arguments passed:", process.argv.slice(2));
EOF
            chmod +x main.js
            ;;
        "rust")
            if command -v cargo &> /dev/null; then
                cargo init .
            else
                log_error "Cargo not found for CLI initialization."
                exit 1
            fi
            ;;
    esac

    cd ..
    log_success "CLI initialized"
}

# Create project files
create_project_files() {
    log_info "Creating project files..."

    # .gitignore
    cat > .gitignore << 'EOF'
# Dependencies
node_modules/
target/
dist/
build/

# Environment variables
.env
.env.local
.env.development.local
.env.test.local
.env.production.local

# IDE
.vscode/
.idea/
*.swp
*.swo

# OS
.DS_Store
Thumbs.db

# Logs
*.log
npm-debug.log*
yarn-debug.log*
yarn-error.log*
EOF

    # README.md with KaTeX formula
    cat > README.md << EOF
# $PROJECT_NAME

<!-- CLI parser formula -->
\$\$
\\begin{aligned}
\\text{Runtime}_{\\text{CLI}} &= \\mathcal{O}(n + m \\cdot \\log k) + \\sum_{i=1}^{f} \\Bigg[\\frac{d_i^2}{\\sqrt{p_i + 1}} + \\ln\\left(\\frac{v_i!}{(v_i - u_i)!}\\right)\\Bigg] \\\\\\\\
\\text{where:} \\quad
n &= \\text{number of arguments}, \\\\
m &= \\text{number of key-value pairs}, \\\\
k &= \\text{distinct normalized keys}, \\\\
f &= \\text{number of flags}, \\\\
d_i &= \\text{depth of nesting in flag } i, \\\\
p_i &= \\text{number of positional args before flag } i, \\\\
v_i &= \\text{length of value assigned to flag } i, \\\\
u_i &= \\text{number of underscores in that value}
\\end{aligned}
\$\$

## Project Structure

- \`frontend/\` - Frontend application ($FRONTEND_FRAMEWORK)
- \`backend/\` - Backend services ($BACKEND_FRAMEWORK)
- \`cli/\` - Command-line interface ($CLI_FRAMEWORK)

## Getting Started

\`\`\`bash
./main.sh
\`\`\`
EOF

    # LICENSE (MIT)
    cat > LICENSE << EOF
MIT License

Copyright (c) $(date +%Y) $PROJECT_NAME

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
EOF

    # CHANGELOG.md
    cat > CHANGELOG.md << EOF
# Changelog

All notable changes to this project will be documented in this file.

## [0.1.0] - $(date +%Y-%m-%d)

### Added
- Initial project setup
- Frontend application ($FRONTEND_FRAMEWORK)
- Backend services ($BACKEND_FRAMEWORK)
- CLI interface ($CLI_FRAMEWORK)
EOF

    # package.json
    cat > package.json << EOF
{
  "name": "$PROJECT_NAME",
  "version": "0.1.0",
  "description": "Generated by taku create script",
  "main": "main.sh",
  "scripts": {
    "dev": "./main.sh dev",
    "build": "./main.sh build",
    "test": "./main.sh test"
  },
  "license": "MIT"
}
EOF

    # Makefile
    cat > Makefile << 'EOF'
.PHONY: build test lint format clean

build:
	@echo "Building project..."
	cd frontend && npm run build
	cd backend && cargo build --release

test:
	@echo "Running tests..."
	cd frontend && npm test
	cd backend && cargo test

lint:
	@echo "Linting code..."
	cd frontend && npm run lint
	cd backend && cargo clippy

format:
	@echo "Formatting code..."
	cd frontend && npm run format
	cd backend && cargo fmt

clean:
	@echo "Cleaning build artifacts..."
	rm -rf frontend/dist backend/target
EOF

    log_success "Project files created"
}

# Install and configure development tools
setup_dev_tools() {
    log_info "Setting up development tools..."

    # Install husky if package manager supports it
    if command -v $PACKAGE_MANAGER &> /dev/null && [ "$PACKAGE_MANAGER" != "cargo" ]; then
        $PACKAGE_MANAGER add -D husky
        npx husky install
        log_success "Husky installed and configured"
    fi

    # Check for ggshield
    if command -v ggshield &> /dev/null; then
        log_success "ggshield detected for secret scanning"
    else
        log_warning "ggshield not found. Consider installing for secret scanning."
    fi

    log_success "Development tools configured"
}

# Main execution
main() {
    echo "=== Taku Project Initializer ==="
    echo

    # Parse command line arguments
    while [[ $# -gt 0 ]]; do
        case $1 in
            -n|--name)
                PROJECT_NAME="$2"
                shift 2
                ;;
            -p|--path)
                PROJECT_PATH="$2"
                shift 2
                ;;
            -y|--yes)
                # Skip prompts, use defaults
                PROJECT_NAME=${PROJECT_NAME:-$(basename "$(pwd)")}
                shift
                ;;
            -h|--help)
                echo "Usage: $0 [options]"
                echo "Options:"
                echo "  -n, --name <name>    Project name"
                echo "  -p, --path <path>    Project path"
                echo "  -y, --yes           Use defaults, skip prompts"
                echo "  -h, --help          Show this help"
                exit 0
                ;;
            *)
                log_error "Unknown option: $1"
                exit 1
                ;;
        esac
    done

    # Prompt user for configuration if not using --yes
    if [ -z "$PROJECT_NAME" ]; then
        prompt_user
    fi

    # Execute initialization steps
    create_directory_structure
    initialize_git
    create_main_script
    initialize_frontend
    initialize_backend
    initialize_cli
    create_project_files
    setup_dev_tools

    echo
    log_success "Project '$PROJECT_NAME' initialized successfully!"
    echo
    echo "Next steps:"
    echo "  cd $PROJECT_PATH"
    echo "  ./main.sh"
    echo
}

# Run main function with all arguments
main "$@"
