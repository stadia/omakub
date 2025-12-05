#!/bin/bash

# Windsurf - AI-powered code editor
# Check if AUR package is available, otherwise provide manual installation instructions
paru -S --noconfirm windsurf-bin 2>/dev/null || {
    echo "Windsurf package not found in AUR"
    echo "Please visit https://windsurf.ai/ to download and install manually"
}
