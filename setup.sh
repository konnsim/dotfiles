#!/bin/bash

# Exit immediately if a command exits with a non-zero status.
set -e

echo "Starting dotfiles setup script..."

# --- Configuration ---

# The dotfiles directory is the directory the script is in
SCRIPT_DIR="$(dirname "$0")"
DOTFILES_DIR="$(cd "$SCRIPT_DIR" && pwd)" # Resolve to absolute path

echo "Dotfiles directory: ${DOTFILES_DIR}"

# Define an array of packages to install from the official repositories
OFFICIAL_PACKAGES=(
    git                  # Probably already installed to get this repo, but maybe not
    base-devel
    man-db               # rtfm
    stow                 # To manage dotfiles
    hyprland             # Wayland compositor
    hyprpaper		 # background manager
    waybar               # Wayland status bar
    networkmanager
    network-manager-applet # waybar tray applet
    clipman              # clipboard manager daemon
    wl-clipboard         # cli clipboard tools
    less                 # Pager
    nvim                 # real IDE
)

# Define an array of packages to install from the AUR (if any)
AUR_PACKAGES=(
    cursor-bin           # AI IDE (VSC*de fork)
    zen-browser-bin      # firefox based browser
    # Example: wofi nerd-fonts-complete
)

# --- Package Installation ---

echo "Installing official repository packages..."
sudo pacman -S --needed "${OFFICIAL_PACKAGES[@]}"
echo "Official repository packages installation finished."

# --- Install Yay (AUR Helper) ---

echo "Installing Yay (AUR helper)..."

# Check if yay is already installed
if command -v yay &> /dev/null; then
    echo "Yay is already installed. Skipping yay installation."
else
    # Temporarily create a directory for building yay
    YAY_BUILD_DIR=$(mktemp -d)
    echo "Building yay in temporary directory: ${YAY_BUILD_DIR}"
    cd "${YAY_BUILD_DIR}" || { echo "Error: Could not change directory to ${YAY_BUILD_DIR}."; exit 1; }

    # Clone the yay repository
    git clone https://aur.archlinux.org/yay.git .

    # Build and install yay
    makepkg -si --noconfirm

    # Clean up the temporary directory
    cd "${DOTFILES_DIR}" # Navigate back to the dotfiles directory
    rm -rf "${YAY_BUILD_DIR}"
    echo "Yay installation finished."
fi

# --- Install AUR Packages (if any) ---
if [ ${#AUR_PACKAGES[@]} -gt 0 ]; then
    echo "Installing AUR packages..."
    if ! command -v yay &> /dev/null; then
        echo "Yay is not installed. Please install yay manually or add its installation to this script."
        echo "Skipping AUR package installation."
    else
        yay -S --needed "${AUR_PACKAGES[@]}"
        if [ $? -eq 0 ]; then
            echo "AUR packages installed successfully."
        else
            echo "Error installing AUR packages. Please check manually."
        fi
    fi
fi

# --- Clean up potential destination paths before stowing ---

echo "Cleaning up potential default configuration paths based on dotfiles structure..."

# Navigate to the dotfiles directory (where the script is located)
cd "$DOTFILES_DIR" || { echo "Error: Could not change directory to ${DOTFILES_DIR}."; exit 1; }

# Iterate over each directory in the dotfiles directory (these are our packages)
for package in *; do
    # Check if it's a directory and not the .git directory
    if [ -d "$package" ] && [ "$package" != ".git" ]; then
        echo "Processing package for cleanup: $package"
        # Find all files and directories within the package that should be stowed
        # We use find and then calculate the corresponding path in the home directory

        # Use 'find' to list items to be stowed (excluding the package root itself)
        # -mindepth 1: Start from one level below the package directory
        find "$package" -mindepth 1 | while read -r item; do
            # Calculate the relative path from the package root
            RELATIVE_PATH="${item#$package/}"
            # Construct the potential destination path in the home directory
            DEST_PATH="$HOME/$RELATIVE_PATH"

            # Check if the destination path exists (either file or directory)
            if [ -e "$DEST_PATH" ]; then # -e checks if the file/directory exists
                echo "Removing existing destination: $DEST_PATH"
                # Use rm -rf to remove directories and their contents safely
                rm -rf "$DEST_PATH"
            fi
        done
    fi
done

echo "Default configuration cleanup finished."


# --- Stow Dotfiles/Scripts ---

echo "Stowing dotfiles from ${DOTFILES_DIR}..."

# Navigate back to the dotfiles directory (if the find loop changed it, though it shouldn't with while read)
cd "$DOTFILES_DIR" || { echo "Error: Could not change directory to ${DOTFILES_DIR}."; exit 1; }

# Iterate over each directory in the dotfiles directory (these are our packages)
for package in *; do
    # Check if it's a directory and not the .git directory
    if [ -d "$package" ] && [ "$package" != ".git" ]; then
        echo "Stowing package: $package"
        # Use -v for verbose output from stow (optional)
        stow "$package" # Use the standard stow command now that the path is clean

        # Check if stow was successful for this package
        if [ $? -ne 0 ]; then
            echo "Warning: Stow failed for package $package. Please check for conflicts manually."
            # You might choose to exit here if a failed stow is critical
        fi
    fi
done

echo "Dotfiles stowing finished."

# --- Post-Installation Steps ---

echo "Performing post-installation steps..."

# Enable and start NetworkManager service
echo "Enabling and starting NetworkManager service..."
sudo systemctl enable --now NetworkManager

# Add other post-installation steps here (e.g., starting a display manager)

echo "Post-installation steps finished."

echo "Dotfiles setup script completed."
echo "Please log out and log back in (or restart your system) to apply all changes."
