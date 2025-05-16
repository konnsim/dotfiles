# konn's Arch Linux Dotfiles

Welcome to my personal dotfiles repository for my Arch Linux setup. This repository contains the configuration files for my window manager, status bar, and other essential applications, managed using GNU Stow.

My setup is built around:

*   **Operating System:** Arch Linux
*   **Window Manager:** Hyprland (Wayland)
*   **Status Bar:** Waybar
*   **Package Management:** pacman and yay (AUR helper)
*   **Dotfile Management:** GNU Stow

## Contents

This repository is organized into directories, where each directory represents a "Stow package" for a specific application or set of configurations.

The structure within each package directory mirrors the desired structure in your `~` home directory.

## Installation

This repository includes an automated setup script designed for a fresh or minimal Arch Linux installation. The script will install necessary packages (including `yay`), clean up potential default configuration files, and then use Stow to symlink the dotfiles from this repository to your home directory.

**Prerequisites:**

*   A working Arch Linux installation.
*   Basic internet connectivity.
*   `git` installed (usually available in the base installation or easily installed with `sudo pacman -S git`).

**Steps:**

1.  **Clone the repository:**
    Clone this repository to your home directory. It's recommended to clone it to `~/dotfiles`.

    ```bash
    git clone https://github.com/konnsim/dotfiles.git ~/dotfiles
    ```

2.  **Navigate to the dotfiles directory:**

    ```bash
    cd ~/dotfiles
    ```

3.  **Make the setup script executable:**

    ```bash
    chmod +x setup.sh
    ```

4.  **Run the setup script:**
    Execute the script. It will ask for your `sudo` password to install packages.

    ```bash
    ./setup.sh
    ```

    The script will:
    *   Install essential packages from the official Arch repositories (including `stow` and build tools for AUR).
    *   Install `yay` from the AUR if it's not already present.
    *   Install other specified AUR packages using `yay`.
    *   **Clean up** potential default configuration files in your home directory that would conflict with stowing, based on the structure of this repository. **(Note: Ensure your dotfiles repository contains the configurations you intend to use, as this step will remove existing files in the target locations).**
    *   Use `stow` to create symbolic links from this repository to the appropriate locations in your home directory.
    *   Perform any defined post-installation steps (e.g., enabling systemd services like NetworkManager).

5.  **Reboot or Log Out/In:**
    After the script completes, it's recommended to reboot your system or log out and log back in to ensure all changes (like service activations and shell configurations) take effect.

## Updating Dotfiles

If you make changes to your dotfiles locally (by editing the symlinked files in your home directory) and want to push them to this repository:

1.  Navigate to your dotfiles repository:
    ```bash
    cd ~/dotfiles
    ```
2.  Add the changes:
    ```bash
    git add .
    ```
3.  Commit the changes:
    ```bash
    git commit -m "Descriptive commit message"
    ```
4.  Push to the remote repository:
    ```bash
    git push origin main
    ```

If you pull updates from this repository to another machine, Stow will automatically update the symlinks.

## Structure

The repository follows a standard Stow structure. Each top-level directory (excluding `.git`) is a Stow package. The contents within each package are structured relative to the user's home directory (`~`).

Here's a representation of the directory structure:

*   `.git/` - Git repository data (ignored)
*   `setup.sh` - Automated setup script
*   `<named-packages>/` - Individually stowable packages

Within each package directory (e.g., `hypr`), the directory structure matches the path relative to your home directory where the configuration files should reside (e.g., `.config/hypr/hyprland.conf`).

## Customization

Feel free to fork this repository and modify the dotfiles to your liking. Remember to update the `setup.sh` script's package lists if you add or remove dependencies for your configuration.

## License

This project is licensed under the [MIT License] - see the [LICENSE.md] file for details.

## Acknowledgements

*   Inspired by my unwillingness to ever do the same thing twice.
