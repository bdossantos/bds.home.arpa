#!/bin/bash

# Install Dyson Custom Integration for Home Assistant
# This script provides instructions for downloading and installing the ha-dyson custom component

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
CUSTOM_COMPONENTS_DIR="$PROJECT_ROOT/homeassistant/custom_components"
DYSON_COMPONENT_DIR="$CUSTOM_COMPONENTS_DIR/dyson"

echo "Dyson Custom Integration Setup"
echo "=============================="
echo ""

# Create custom_components directory if it doesn't exist
mkdir -p "$CUSTOM_COMPONENTS_DIR"

# Check if we can access GitHub API
GITHUB_RESPONSE=$(curl -s --connect-timeout 5 --max-time 10 https://api.github.com/repos/libdyson-wg/ha-dyson/releases/latest 2>/dev/null || echo "FAILED")

if [[ "$GITHUB_RESPONSE" != "FAILED" ]] && [[ "$GITHUB_RESPONSE" != *"Blocked by DNS monitoring proxy"* ]] && [[ -n "$GITHUB_RESPONSE" ]]; then
    echo "✅ Network access available - attempting automatic installation..."
    
    # Extract version from response
    LATEST_RELEASE=$(echo "$GITHUB_RESPONSE" | grep '"tag_name"' | cut -d '"' -f 4)
    
    if [ -z "$LATEST_RELEASE" ]; then
        echo "❌ Could not determine latest release version from API response"
        echo "📋 Please install manually using the instructions below"
        MANUAL_INSTALL=true
    else
        DOWNLOAD_URL="https://github.com/libdyson-wg/ha-dyson/archive/${LATEST_RELEASE}.tar.gz"
        
        echo "📦 Downloading ha-dyson version: $LATEST_RELEASE"
        
        # Create temporary directory for download
        TEMP_DIR=$(mktemp -d)
        cd "$TEMP_DIR"
        
        # Download and extract
        if curl -L "$DOWNLOAD_URL" -o dyson.tar.gz; then
            tar -xzf dyson.tar.gz
            
            # Find the extracted directory (it will be ha-dyson-<version>)
            EXTRACTED_DIR=$(find . -maxdepth 1 -type d -name "ha-dyson-*" | head -1)
            
            if [ -n "$EXTRACTED_DIR" ] && [ -d "$EXTRACTED_DIR/custom_components/dyson" ]; then
                echo "📁 Installing dyson custom component to $DYSON_COMPONENT_DIR"
                rm -rf "$DYSON_COMPONENT_DIR"
                cp -r "$EXTRACTED_DIR/custom_components/dyson" "$DYSON_COMPONENT_DIR"
                echo "✅ Dyson custom component installed successfully!"
                
                # Cleanup
                cd "$PROJECT_ROOT"
                rm -rf "$TEMP_DIR"
                
                echo ""
                echo "🎉 Automatic installation complete!"
            else
                echo "❌ Error: dyson custom component not found in downloaded archive"
                MANUAL_INSTALL=true
            fi
        else
            echo "❌ Failed to download release archive"
            MANUAL_INSTALL=true
        fi
    fi
else
    echo "⚠️  Network access limited or GitHub API blocked - manual installation required"
    MANUAL_INSTALL=true
fi

if [ "${MANUAL_INSTALL:-false}" = "true" ]; then
    echo ""
    echo "📋 Manual Installation Instructions"
    echo "=================================="
    echo ""
    echo "1. Visit: https://github.com/libdyson-wg/ha-dyson/releases/latest"
    echo "2. Download the latest release archive (Source code tar.gz)"
    echo "3. Extract the archive"
    echo "4. Copy the 'custom_components/dyson' directory to:"
    echo "   $CUSTOM_COMPONENTS_DIR/"
    echo ""
    echo "Example commands:"
    echo "  wget https://github.com/libdyson-wg/ha-dyson/archive/refs/tags/\$VERSION.tar.gz"
    echo "  tar -xzf \$VERSION.tar.gz"
    echo "  cp -r ha-dyson-\$VERSION/custom_components/dyson $CUSTOM_COMPONENTS_DIR/"
    echo ""
fi

echo ""
echo "📝 Next Steps"
echo "============"
echo ""
echo "1. 🔧 Build and restart the Docker container:"
echo "   make build && make up"
echo ""
echo "2. 🏠 Configure in Home Assistant:"
echo "   - Go to Settings > Devices & Services"
echo "   - Click 'Add Integration' and search for 'Dyson'"
echo "   - Follow the setup wizard"
echo ""
echo "3. 🔐 Authentication Options:"
echo "   - Option A: Use your MyDyson account (email/password)"
echo "   - Option B: Use device Wi-Fi information from device sticker"
echo ""
echo "4. 📖 For detailed setup instructions, see:"
echo "   docs/dyson-integration.md"
echo ""

# Check if component is already installed
if [ -d "$DYSON_COMPONENT_DIR" ]; then
    echo "✅ Dyson custom component directory exists at: $DYSON_COMPONENT_DIR"
    if [ -f "$DYSON_COMPONENT_DIR/manifest.json" ]; then
        echo "✅ Component manifest found - installation appears complete"
    else
        echo "⚠️  Component directory exists but manifest.json not found"
    fi
else
    echo "❌ Dyson custom component not yet installed"
fi