#!/bin/bash

# OpenClaw Backup Universal Skill - One-Click Installer
# Version: 1.0.0
# Repository: https://github.com/DeiuDesHommies/openclaw-backup-skill

set -e

REPO="DeiuDesHommies/openclaw-backup-skill"
VERSION="v1.0.0"
SKILL_NAME="openclaw-backup-universal"
DOWNLOAD_URL="https://github.com/${REPO}/releases/download/${VERSION}/${SKILL_NAME}.tar.gz"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo "================================================"
echo "OpenClaw Backup Universal Skill Installer"
echo "Version: ${VERSION}"
echo "================================================"
echo ""

# Detect OpenClaw installation directory
if [ -d "$HOME/.openclaw" ]; then
    OPENCLAW_DIR="$HOME/.openclaw"
elif [ -d "$HOME/.config/openclaw" ]; then
    OPENCLAW_DIR="$HOME/.config/openclaw"
else
    echo -e "${RED}Error: OpenClaw installation not found!${NC}"
    echo "Please install OpenClaw first."
    exit 1
fi

SKILLS_DIR="${OPENCLAW_DIR}/workspace/skills"
INSTALL_DIR="${SKILLS_DIR}/${SKILL_NAME}"

echo -e "${GREEN}✓${NC} Found OpenClaw at: ${OPENCLAW_DIR}"

# Create skills directory if it doesn't exist
if [ ! -d "${SKILLS_DIR}" ]; then
    echo "Creating skills directory..."
    mkdir -p "${SKILLS_DIR}"
fi

# Check if skill already exists
if [ -d "${INSTALL_DIR}" ]; then
    echo -e "${YELLOW}Warning: Skill already exists at ${INSTALL_DIR}${NC}"
    read -p "Do you want to overwrite it? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Installation cancelled."
        exit 0
    fi
    rm -rf "${INSTALL_DIR}"
fi

# Download and extract
echo "Downloading ${SKILL_NAME} ${VERSION}..."
TEMP_FILE=$(mktemp)
if command -v curl &> /dev/null; then
    curl -L -o "${TEMP_FILE}" "${DOWNLOAD_URL}"
elif command -v wget &> /dev/null; then
    wget -O "${TEMP_FILE}" "${DOWNLOAD_URL}"
else
    echo -e "${RED}Error: Neither curl nor wget found. Please install one of them.${NC}"
    exit 1
fi

echo "Extracting to ${SKILLS_DIR}..."
tar -xzf "${TEMP_FILE}" -C "${SKILLS_DIR}"
rm "${TEMP_FILE}"

echo -e "${GREEN}✓${NC} Installation complete!"
echo ""
echo "================================================"
echo "Next Steps:"
echo "================================================"
echo ""
echo "1. Enable the skill in your openclaw.json:"
echo ""
echo "   {"
echo "     \"skills\": {"
echo "       \"entries\": {"
echo "         \"${SKILL_NAME}\": { \"enabled\": true }"
echo "       }"
echo "     }"
echo "   }"
echo ""
echo "2. Restart OpenClaw"
echo ""
echo "3. Use the skill by saying:"
echo "   \"backup my openclaw config\""
echo ""
echo "================================================"
echo -e "${GREEN}Installation successful!${NC}"
echo "================================================"
