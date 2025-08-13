#!/bin/bash
# APM Framework Universal Installer v4.0.0
# Downloads and installs the latest APM release with flexible options

set -e

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

# Default Configuration
REPO="omayhemo/APM"
DEFAULT_INSTALL_DIR="$HOME/.apm-framework"
INSTALL_DIR=""
VERSION=""
AUTO_YES=false
QUIET=false
WITH_TTS=false
VERBOSE=false

# Show usage
show_usage() {
    cat << EOF
APM Framework Universal Installer

Usage: $0 [OPTIONS]

OPTIONS:
    -y, --yes, --defaults     Automatic yes to all prompts (non-interactive)
    -v, --version VERSION     Install specific version (default: latest)
    -p, --path PATH          Custom installation path (default: current directory)
    -t, --with-tts           Enable TTS voice notifications
    -q, --quiet              Minimal output
    -V, --verbose            Verbose output
    -h, --help               Show this help message

EXAMPLES:
    # Quick install with defaults (non-interactive)
    curl -fsSL https://raw.githubusercontent.com/omayhemo/APM/master/install.sh | bash -s -- --defaults

    # Install specific version
    curl -fsSL https://raw.githubusercontent.com/omayhemo/APM/master/install.sh | bash -s -- --version 4.0.0

    # Install to specific directory with TTS
    curl -fsSL https://raw.githubusercontent.com/omayhemo/APM/master/install.sh | bash -s -- --path /opt/apm --with-tts

    # Quiet installation with defaults
    curl -fsSL https://raw.githubusercontent.com/omayhemo/APM/master/install.sh | bash -s -- --defaults --quiet

EOF
    exit 0
}

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -y|--yes|--defaults)
            AUTO_YES=true
            shift
            ;;
        -v|--version)
            VERSION="$2"
            shift 2
            ;;
        -p|--path)
            INSTALL_DIR="$2"
            shift 2
            ;;
        -t|--with-tts)
            WITH_TTS=true
            shift
            ;;
        -q|--quiet)
            QUIET=true
            shift
            ;;
        -V|--verbose)
            VERBOSE=true
            shift
            ;;
        -h|--help)
            show_usage
            ;;
        *)
            echo -e "${RED}Unknown option: $1${NC}"
            echo "Use --help for usage information"
            exit 1
            ;;
    esac
done

# Logging functions
log_info() {
    if [ "$QUIET" != "true" ]; then
        echo -e "${BLUE}$1${NC}"
    fi
}

log_success() {
    if [ "$QUIET" != "true" ]; then
        echo -e "${GREEN}$1${NC}"
    fi
}

log_error() {
    echo -e "${RED}$1${NC}" >&2
}

log_verbose() {
    if [ "$VERBOSE" = "true" ]; then
        echo -e "${YELLOW}[DEBUG] $1${NC}"
    fi
}

# Header (skip if quiet)
if [ "$QUIET" != "true" ]; then
    echo -e "${BLUE}═══════════════════════════════════════════${NC}"
    echo -e "${BLUE}     APM Framework Installer v2.0${NC}"
    echo -e "${BLUE}═══════════════════════════════════════════${NC}"
    echo ""
fi

# Check for required tools
log_verbose "Checking required tools..."
for tool in curl tar; do
    if ! command -v $tool &> /dev/null; then
        log_error "Error: $tool is required but not installed"
        exit 1
    fi
done
log_verbose "All required tools found"

# Determine version to install
if [ -z "$VERSION" ]; then
    log_info "Fetching latest version..."
    LATEST_VERSION=$(curl -s "https://api.github.com/repos/$REPO/releases/latest" | grep '"tag_name"' | sed -E 's/.*"([^"]+)".*/\1/')
    
    if [ -z "$LATEST_VERSION" ]; then
        log_error "Error: Could not determine latest version"
        echo "Please check https://github.com/$REPO/releases"
        exit 1
    fi
    VERSION="${LATEST_VERSION#v}"
else
    # Ensure version doesn't have 'v' prefix
    VERSION="${VERSION#v}"
fi

log_success "✓ Installing version: v$VERSION"

# Determine installation directory
if [ -z "$INSTALL_DIR" ]; then
    # If no path specified, install in current directory
    INSTALL_DIR="$(pwd)"
    log_verbose "Using current directory: $INSTALL_DIR"
fi

# Confirm installation (skip if auto-yes)
if [ "$AUTO_YES" != "true" ] && [ "$QUIET" != "true" ]; then
    echo ""
    echo "Installation details:"
    echo "  Version: v$VERSION"
    echo "  Directory: $INSTALL_DIR"
    echo "  TTS: $([ "$WITH_TTS" = "true" ] && echo "Enabled" || echo "Disabled")"
    echo ""
    read -p "Continue with installation? (y/N) " -n 1 -r
    echo ""
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Installation cancelled"
        exit 0
    fi
fi

# Download URL
DOWNLOAD_URL="https://github.com/$REPO/releases/download/v$VERSION/apm-v$VERSION.tar.gz"
log_verbose "Download URL: $DOWNLOAD_URL"

# Create temp directory
TEMP_DIR=$(mktemp -d)
trap "rm -rf $TEMP_DIR" EXIT
log_verbose "Created temp directory: $TEMP_DIR"

# Download release
log_info "Downloading APM v$VERSION..."
if [ "$VERBOSE" = "true" ]; then
    curl -L -o "$TEMP_DIR/apm.tar.gz" "$DOWNLOAD_URL"
else
    curl -L -s -o "$TEMP_DIR/apm.tar.gz" "$DOWNLOAD_URL"
fi

if [ ! -f "$TEMP_DIR/apm.tar.gz" ]; then
    log_error "Error: Failed to download release"
    exit 1
fi
log_verbose "Download complete"

# Extract
log_info "Extracting files..."
tar -xzf "$TEMP_DIR/apm.tar.gz" -C "$TEMP_DIR"
log_verbose "Extraction complete"

# Find the extracted directory
EXTRACTED_DIR=$(find "$TEMP_DIR" -maxdepth 1 -type d -name "apm-*" | head -1)

if [ -z "$EXTRACTED_DIR" ]; then
    log_error "Error: Could not find extracted directory"
    exit 1
fi
log_verbose "Found extracted directory: $EXTRACTED_DIR"

# Prepare installer arguments
INSTALLER_ARGS=""
if [ "$AUTO_YES" = "true" ]; then
    INSTALLER_ARGS="$INSTALLER_ARGS --defaults"
fi
if [ "$WITH_TTS" = "true" ]; then
    INSTALLER_ARGS="$INSTALLER_ARGS --with-tts"
fi
if [ "$QUIET" = "true" ]; then
    INSTALLER_ARGS="$INSTALLER_ARGS --quiet"
fi

# Run the actual installer
log_info "Running APM installer..."
log_verbose "Installer arguments: $INSTALLER_ARGS"

if [ -f "$EXTRACTED_DIR/installer/install.sh" ]; then
    cd "$EXTRACTED_DIR"
    # Pass the installation directory and any additional arguments
    if [ "$QUIET" = "true" ]; then
        bash installer/install.sh "$INSTALL_DIR" $INSTALLER_ARGS > /dev/null 2>&1
    else
        bash installer/install.sh "$INSTALL_DIR" $INSTALLER_ARGS
    fi
else
    log_error "Error: Installer not found in package"
    exit 1
fi

# Success message
if [ "$QUIET" != "true" ]; then
    echo ""
    echo -e "${GREEN}═══════════════════════════════════════════${NC}"
    echo -e "${GREEN}     APM Installation Complete!${NC}"
    echo -e "${GREEN}═══════════════════════════════════════════${NC}"
    echo ""
    echo -e "${BLUE}Get started with:${NC}"
    echo -e "  ${GREEN}/ap${NC}         - Launch the orchestrator"
    echo -e "  ${GREEN}/analyst${NC}    - Start with research"
    echo -e "  ${GREEN}/dev${NC}        - Jump into coding"
    echo ""
    echo -e "${BLUE}Documentation:${NC} .apm/README.md"
    echo -e "${BLUE}Version:${NC} v$VERSION"
fi

# Minimal output for quiet mode
if [ "$QUIET" = "true" ]; then
    echo "APM v$VERSION installed successfully"
fi