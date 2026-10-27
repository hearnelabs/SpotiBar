#!/usr/bin/env bash
# SpotiBar Installer for KDE Plasma 6
# HearneLabs

set -e

PLASMOID_NAME="org.hearnelabs.spotibar"
TARGET_DIR="${HOME}/.local/share/plasma/plasmoids/${PLASMOID_NAME}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "🎵 Installing SpotiBar..."

# Check playerctl dependency
if ! command -v playerctl >/dev/null 2>&1; then
    echo "⚠️ Warning: 'playerctl' is not installed."
    echo "   SpotiBar needs playerctl to query Spotify via MPRIS."
    echo "   Install it with: sudo pacman -S playerctl"
fi

# Ensure target plasmoids directory exists
mkdir -p "${HOME}/.local/share/plasma/plasmoids"

# Create symlink or copy
if [ -d "$TARGET_DIR" ] || [ -L "$TARGET_DIR" ]; then
    echo "Removing previous installation..."
    rm -rf "$TARGET_DIR"
fi

echo "Symlinking SpotiBar into KDE Plasma directory..."
ln -sfn "$SCRIPT_DIR" "$TARGET_DIR"

# Refresh KDE Plasma system cache
if command -v kbuildsycoca6 >/dev/null 2>&1; then
    echo "Refreshing KDE Plasma cache..."
    kbuildsycoca6 --noincremental >/dev/null 2>&1 || true
fi

echo ""
echo "✅ SpotiBar installed successfully!"
echo ""
echo "👉 To add it to your panel:"
echo "   1. Right-click your panel -> 'Add Widgets...'"
echo "   2. Search for 'SpotiBar'"
echo "   3. Drag and drop it onto your panel"
echo ""
echo "💡 Tip: Middle-click on SpotiBar in your panel to toggle between Cachy Wave & Native Breeze styles!"
