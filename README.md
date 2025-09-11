<h1 align=center>caelestia-shell (Personal Fork)</h1>

<div align=center>

![GitHub last commit](https://img.shields.io/github/last-commit/liammmcauliffe/shell?style=for-the-badge&labelColor=101418&color=9ccbfb)
![GitHub Repo stars](https://img.shields.io/github/stars/liammmcauliffe/shell?style=for-the-badge&labelColor=101418&color=b9c8da)
![GitHub repo size](https://img.shields.io/github/repo-size/liammmcauliffe/shell?style=for-the-badge&labelColor=101418&color=d3bfe6)
[![Fork of caelestia-shell](https://img.shields.io/badge/fork%20of-caelestia--shell-blue?style=for-the-badge&labelColor=101418&color=9ccbfb)](https://github.com/caelestia-dots/shell)

</div>

> **⚠️ This is a personal fork of [caelestia-shell](https://github.com/caelestia-dots/shell) with custom modifications and additional features.**
> 
> This fork contains personal customizations, additional services, and enhanced functionality beyond the original caelestia-shell. While based on the excellent work of the original project, this version includes modifications tailored to my specific needs and preferences.
> 
> **Repository**: [liammmcauliffe/shell](https://github.com/liammmcauliffe/shell)  
> **Original Project**: [caelestia-dots/shell](https://github.com/caelestia-dots/shell)

https://github.com/user-attachments/assets/5a9e183f-5d58-4308-8567-9c8a50e12476

## Components

- Widgets: [`Quickshell`](https://quickshell.outfoxxed.me)
- Window manager: [`Hyprland`](https://hyprland.org)
- Dots: [`caelestia`](https://github.com/caelestia-dots)
- **Fork of**: [`caelestia-shell`](https://github.com/caelestia-dots/shell)

## Custom Features & Modifications

This personal fork includes several additional features and modifications beyond the original caelestia-shell:

### 🆕 Additional Services
- **Do Not Disturb**: Toggle notification blocking with pending notification management
- **Game Mode**: Performance optimization mode that disables animations and effects
- **Keyboard Backlight**: Control keyboard backlight brightness (supports brightnessctl, sysfs, and ddcutil)
- **Night Mode**: Blue light filter using hyprsunset
- **VPN**: Cloudflare WARP integration with connection management
- **Cava Integration**: Enhanced audio visualizer with custom C++ backend

### 🎨 Enhanced UI Components
- **Notifications Popout**: Improved notification management with Do Not Disturb integration
- **Additional Assets**: Custom globe.gif and dino.png assets
- **Enhanced Visualizer**: Better audio visualization with Cava backend
- **Refactored QuickToggles**: Modular, configurable toggle system with zero code duplication

### 🔧 Technical Improvements
- **Custom C++ Plugin**: Native Cava integration for better audio processing
- **Enhanced IPC**: Additional IPC commands for new services
- **Better Error Handling**: Improved service availability detection
- **Performance Optimizations**: Game mode and other performance enhancements
- **BeatTracker Integration**: Enhanced audio beat detection capabilities
- **Threaded Render Loop**: Improved performance with forced threaded rendering
- **Updated Dependencies**: Regular updates to stay current with upstream changes

### 📝 Recent Updates
Based on the latest commits, this fork includes:
- **Launcher Configuration**: Enhanced launcher with config options for hiding applications
- **Asset Management**: Restored personal configurations and customizations
- **Plugin Updates**: Added BeatTracker and removed multimedia dependencies
- **Code Quality**: Internal formatting improvements and better C++ code structure
- **Development Tools**: Added .envrc for development environment setup

## Installation

> [!NOTE]
> This repo is for the desktop shell of the caelestia dots. If you want installation instructions
> for the entire dots, head to [the main repo](https://github.com/caelestia-dots/caelestia) instead.

### Arch linux

> [!NOTE]
> If you want to make your own changes/tweaks to the shell do NOT edit the files installed by the AUR
> package. Instead, follow the instructions in the [manual installation section](#manual-installation).

The shell is available from the AUR as `caelestia-shell`. You can install it with an AUR helper
like [`yay`](https://github.com/Jguer/yay) or manually downloading the PKGBUILD and running `makepkg -si`.

A package following the latest commit also exists as `caelestia-shell-git`. This is bleeding edge
and likely to be unstable/have bugs. Regular users are recommended to use the stable package
(`caelestia-shell`).

### Nix

You can run the shell directly via `nix run`:

```sh
nix run github:caelestia-dots/shell
```

Or add it to your system configuration:

```nix
{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    caelestia-shell = {
      url = "github:caelestia-dots/shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
}
```

The package is available as `caelestia-shell.packages.<system>.default`, which can be added to your
`environment.systemPackages`, `users.users.<username>.packages`, `home.packages` if using home-manager,
or a devshell. The shell can then be run via `caelestia-shell`.

> [!TIP]
> The default package does not have the CLI enabled by default, which is required for full funcionality.
> To enable the CLI, use the `with-cli` package.

For home-manager, you can also use the Caelestia's home manager module (explained in [configuring](https://github.com/caelestia-dots/shell?tab=readme-ov-file#home-manager-module)) that installs and configures the shell and the CLI.

### Manual installation

Dependencies:

**Core Dependencies (from original caelestia-shell):**
- [`caelestia-cli`](https://github.com/caelestia-dots/cli)
- [`quickshell-git`](https://quickshell.outfoxxed.me) - this has to be the git version, not the latest tagged version
- [`ddcutil`](https://github.com/rockowitz/ddcutil)
- [`brightnessctl`](https://github.com/Hummer12007/brightnessctl)
- [`app2unit`](https://github.com/Vladimir-csp/app2unit)
- [`cava`](https://github.com/karlstav/cava)
- [`networkmanager`](https://networkmanager.dev)
- [`lm-sensors`](https://github.com/lm-sensors/lm-sensors)
- [`fish`](https://github.com/fish-shell/fish-shell)
- [`aubio`](https://github.com/aubio/aubio)
- [`libpipewire`](https://pipewire.org)
- `glibc`
- `qt6-declarative`
- `gcc-libs`
- [`material-symbols`](https://fonts.google.com/icons)
- [`caskaydia-cove-nerd`](https://www.nerdfonts.com/font-downloads)
- [`swappy`](https://github.com/jtheoof/swappy)
- [`libqalculate`](https://github.com/Qalculate/libqalculate)
- [`bash`](https://www.gnu.org/software/bash)
- `qt6-base`
- `qt6-declarative`

**Additional Dependencies (for custom features):**
- [`hyprsunset`](https://github.com/hyprwm/hyprsunset) - for Night Mode functionality
- [`warp-cli`](https://developers.cloudflare.com/warp-client/) - for VPN/Cloudflare WARP integration
- [`jq`](https://github.com/jqlang/jq) - for JSON processing in Game Mode
- `libcava` - Cava library for enhanced audio visualization
- `fftw` - Fast Fourier Transform library for audio processing

Build dependencies:

- [`cmake`](https://cmake.org)
- [`ninja`](https://github.com/ninja-build/ninja)

To install the shell manually, install all dependencies and clone this repo to `$XDG_CONFIG_HOME/quickshell/caelestia`.
Then simply build and install using `cmake`.

```sh
cd $XDG_CONFIG_HOME/quickshell
git clone https://github.com/liammmcauliffe/shell.git caelestia

cd caelestia
cmake -B build -G Ninja -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/
cmake --build build
sudo cmake --install build
```

> [!IMPORTANT]
> **Installation Notes for This Fork:**
> 
> 1. **Additional Dependencies**: Make sure to install all the additional dependencies listed above for the custom features to work properly.
> 
> 2. **Service Availability**: Some services (like VPN, Night Mode, Keyboard Backlight) will automatically detect if their required tools are available and disable themselves gracefully if not found.
> 
> 3. **Custom Features**: The custom features are designed to be optional - the shell will work without them, but you'll get the full experience with all dependencies installed.
> 
> 4. **Configuration**: The original configuration options still apply, plus you can configure the new services through the same `~/.config/caelestia/shell.json` file.

> [!TIP]
> You can customise the installation location via the `cmake` flags `INSTALL_LIBDIR`, `INSTALL_QMLDIR` and
> `INSTALL_QSCONFDIR` for the libraries (the beat detector), QML plugin and Quickshell config directories
> respectively. If changing the library directory, remember to set the `CAELESTIA_LIB_DIR` environment
> variable to the custom directory when launching the shell.
>
> e.g. installing to `~/.config/quickshell/caelestia` for easy local changes:
>
> ```sh
> mkdir -p ~/.config/quickshell/caelestia
> cmake -B build -G Ninja -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/ -DINSTALL_QSCONFDIR=~/.config/quickshell/caelestia
> cmake --build build
> sudo cmake --install build
> sudo chown -R $USER ~/.config/quickshell/caelestia
> ```

## Usage

The shell can be started via the `caelestia shell -d` command or `qs -c caelestia`.
If the entire caelestia dots are installed, the shell will be autostarted on login
via an `exec-once` in the hyprland config.

### Shortcuts/IPC

All keybinds are accessible via Hyprland [global shortcuts](https://wiki.hyprland.org/Configuring/Binds/#dbus-global-shortcuts).
If using the entire caelestia dots, the keybinds are already configured for you.
Otherwise, [this file](https://github.com/caelestia-dots/caelestia/blob/main/hypr/hyprland/keybinds.conf#L1-L39)
contains an example on how to use global shortcuts.

All IPC commands can be accessed via `caelestia shell ...`. For example

```sh
caelestia shell mpris getActive trackTitle
```

The list of IPC commands can be shown via `caelestia shell -s`:

```
$ caelestia shell -s
target drawers
  function toggle(drawer: string): void
  function list(): string
target notifs
  function clear(): void
target lock
  function lock(): void
  function unlock(): void
  function isLocked(): bool
target mpris
  function playPause(): void
  function getActive(prop: string): string
  function next(): void
  function stop(): void
  function play(): void
  function list(): string
  function pause(): void
  function previous(): void
target picker
  function openFreeze(): void
  function open(): void
target wallpaper
  function set(path: string): void
  function get(): string
  function list(): string
target doNotDisturb
  function isEnabled(): bool
  function toggle(): void
  function enable(): void
  function disable(): void
  function getPendingCount(): int
target gameMode
  function isEnabled(): bool
  function toggle(): void
  function enable(): void
  function disable(): void
target keyboardBacklight
  function isEnabled(): bool
  function getBrightness(): real
  function setBrightness(value: real): void
  function toggle(): void
  function isAvailable(): bool
target nightMode
  function isEnabled(): bool
  function toggle(): void
  function enable(): void
  function disable(): void
  function isAvailable(): bool
target vpn
  function isEnabled(): bool
  function getStatus(): string
  function isAvailable(): bool
  function needsRegistration(): bool
  function toggle(): void
  function connect(): void
  function disconnect(): void
  function register(): void
```

### PFP/Wallpapers

The profile picture for the dashboard is read from the file `~/.face`, so to set
it you can copy your image to there or set it via the dashboard.

The wallpapers for the wallpaper switcher are read from `~/Pictures/Wallpapers`
by default. To change it, change the wallpapers path in `~/.config/caelestia/shell.json`.

To set the wallpaper, you can use the command `caelestia wallpaper`. Use `caelestia wallpaper -h` for more info about
the command.

## Updating

If installed via the AUR package, simply update your system (e.g. using `yay`).

If installed manually, you can update by running `git pull` in `$XDG_CONFIG_HOME/quickshell/caelestia`.

```sh
cd $XDG_CONFIG_HOME/quickshell/caelestia
git pull
```

## Configuring

All configuration options should be put in `~/.config/caelestia/shell.json`. This file is _not_ created by
default, you must create it manually.

### Example configuration

> [!NOTE]
> The example configuration only includes recommended configuration options. For more advanced customisation
> such as modifying the size of individual items or changing constants in the code, there are some other
> options which can be found in the source files in the `config` directory.

<details><summary>Example</summary>

```json
{
  "appearance": {
    "anim": {
      "durations": {
        "scale": 1
      }
    },
    "font": {
      "family": {
        "material": "Material Symbols Rounded",
        "mono": "CaskaydiaCove NF",
        "sans": "Rubik"
      },
      "size": {
        "scale": 1
      }
    },
    "padding": {
      "scale": 1
    },
    "rounding": {
      "scale": 1
    },
    "spacing": {
      "scale": 1
    },
    "transparency": {
      "enabled": false,
      "base": 0.85,
      "layers": 0.4
    }
  },
  "general": {
    "apps": {
      "terminal": ["foot"],
      "audio": ["pavucontrol"]
    }
  },
  "background": {
    "desktopClock": {
      "enabled": false
    },
    "enabled": true,
    "visualiser": {
      "enabled": false,
      "autoHide": true,
      "rounding": 1,
      "spacing": 1
    }
  },
  "bar": {
    "clock": {
      "showIcon": true
    },
    "dragThreshold": 20,
    "entries": [
      {
        "id": "logo",
        "enabled": true
      },
      {
        "id": "workspaces",
        "enabled": true
      },
      {
        "id": "spacer",
        "enabled": true
      },
      {
        "id": "activeWindow",
        "enabled": true
      },
      {
        "id": "spacer",
        "enabled": true
      },
      {
        "id": "tray",
        "enabled": true
      },
      {
        "id": "clock",
        "enabled": true
      },
      {
        "id": "statusIcons",
        "enabled": true
      },
      {
        "id": "power",
        "enabled": true
      },
      {
        "id": "idleInhibitor",
        "enabled": false
      }
    ],
    "persistent": true,
    "scrollActions": {
      "brightness": true,
      "workspaces": true,
      "volume": true
    },
    "showOnHover": true,
    "status": {
      "showAudio": false,
      "showBattery": true,
      "showBluetooth": true,
      "showKbLayout": false,
      "showMicrophone": false,
      "showNetwork": true,
      "showLockStatus": true
    },
    "tray": {
      "background": false,
      "iconSubs": [],
      "recolour": false
    },
    "workspaces": {
      "activeIndicator": true,
      "activeLabel": "󰮯",
      "activeTrail": false,
      "label": "  ",
      "occupiedBg": false,
      "occupiedLabel": "󰮯",
      "perMonitorWorkspaces": true,
      "showWindows": true,
      "shown": 5
    }
  },
  "border": {
    "rounding": 25,
    "thickness": 10
  },
  "dashboard": {
    "enabled": true,
    "dragThreshold": 50,
    "mediaUpdateInterval": 500,
    "showOnHover": true
  },
  "launcher": {
    "actionPrefix": ">",
    "actions": [
      {
        "name": "Calculator",
        "icon": "calculate",
        "description": "Do simple math equations (powered by Qalc)",
        "command": ["autocomplete", "calc"],
        "enabled": true,
        "dangerous": false
      },
      {
        "name": "Scheme",
        "icon": "palette",
        "description": "Change the current colour scheme",
        "command": ["autocomplete", "scheme"],
        "enabled": true,
        "dangerous": false
      },
      {
        "name": "Wallpaper",
        "icon": "image",
        "description": "Change the current wallpaper",
        "command": ["autocomplete", "wallpaper"],
        "enabled": true,
        "dangerous": false
      },
      {
        "name": "Variant",
        "icon": "colors",
        "description": "Change the current scheme variant",
        "command": ["autocomplete", "variant"],
        "enabled": true,
        "dangerous": false
      },
      {
        "name": "Transparency",
        "icon": "opacity",
        "description": "Change shell transparency",
        "command": ["autocomplete", "transparency"],
        "enabled": false,
        "dangerous": false
      },
      {
        "name": "Random",
        "icon": "casino",
        "description": "Switch to a random wallpaper",
        "command": ["caelestia", "wallpaper", "-r"],
        "enabled": true,
        "dangerous": false
      },
      {
        "name": "Light",
        "icon": "light_mode",
        "description": "Change the scheme to light mode",
        "command": ["setMode", "light"],
        "enabled": true,
        "dangerous": false
      },
      {
        "name": "Dark",
        "icon": "dark_mode",
        "description": "Change the scheme to dark mode",
        "command": ["setMode", "dark"],
        "enabled": true,
        "dangerous": false
      },
      {
        "name": "Shutdown",
        "icon": "power_settings_new",
        "description": "Shutdown the system",
        "command": ["systemctl", "poweroff"],
        "enabled": true,
        "dangerous": true
      },
      {
        "name": "Reboot",
        "icon": "cached",
        "description": "Reboot the system",
        "command": ["systemctl", "reboot"],
        "enabled": true,
        "dangerous": true
      },
      {
        "name": "Logout",
        "icon": "exit_to_app",
        "description": "Log out of the current session",
        "command": ["loginctl", "terminate-user", ""],
        "enabled": true,
        "dangerous": true
      },
      {
        "name": "Lock",
        "icon": "lock",
        "description": "Lock the current session",
        "command": ["loginctl", "lock-session"],
        "enabled": true,
        "dangerous": false
      },
      {
        "name": "Sleep",
        "icon": "bedtime",
        "description": "Suspend then hibernate",
        "command": ["systemctl", "suspend-then-hibernate"],
        "enabled": true,
        "dangerous": false
      }
    ],
    "dragThreshold": 50,
    "vimKeybinds": false,
    "enableDangerousActions": false,
    "maxShown": 8,
    "maxWallpapers": 9,
    "specialPrefix": "@",
    "useFuzzy": {
      "apps": false,
      "actions": false,
      "schemes": false,
      "variants": false,
      "wallpapers": false
    },
    "showOnHover": false,
    "hiddenApps": []
  },
  "lock": {
    "recolourLogo": false
  },
  "notifs": {
    "actionOnClick": false,
    "clearThreshold": 0.3,
    "defaultExpireTimeout": 5000,
    "expandThreshold": 20,
    "expire": false
  },
  "osd": {
    "enabled": true,
    "enableBrightness": true,
    "enableMicrophone": false,
    "hideDelay": 2000
  },
  "paths": {
    "mediaGif": "root:/assets/bongocat.gif",
    "sessionGif": "root:/assets/globe.gif",
    "wallpaperDir": "~/Pictures/Wallpapers"
  },
  "services": {
    "audioIncrement": 0.1,
    "defaultPlayer": "Spotify",
    "gpuType": "",
    "playerAliases": [
      { "from": "com.github.th_ch.youtube_music", "to": "YT Music" }
    ],
    "weatherLocation": "",
    "useFahrenheit": false,
    "useTwelveHourClock": false,
    "smartScheme": true,
    "visualiserBars": 45
  },
  "session": {
    "dragThreshold": 30,
    "vimKeybinds": false,
    "commands": {
      "logout": ["loginctl", "terminate-user", ""],
      "shutdown": ["systemctl", "poweroff"],
      "hibernate": ["systemctl", "hibernate"],
      "reboot": ["systemctl", "reboot"]
    }
  }
}
```

</details>

### Home Manager Module

For NixOS users, a home manager module is also available.

<details><summary><code>home.nix</code></summary>

```nix
programs.caelestia = {
  enable = true;
  systemd = {
    enable = false; # if you prefer starting from your compositor
    target = "graphical-session.target";
    environment = [];
  };
  settings = {
    bar.status = {
      showBattery = false;
    };
    paths.wallpaperDir = "~/Images";
  };
  cli = {
    enable = true; # Also add caelestia-cli to path
    settings = {
      theme.enableGtk = false;
    };
  };
};
```

The module automatically adds Caelestia shell to the path with **full functionality**. The CLI is not required, however you have the option to enable and configure it.

</details>

## QuickToggles System

The QuickToggles system has been completely refactored to eliminate code duplication and provide a flexible, configuration-driven approach for managing system toggles.

### Features

- **Zero Code Duplication**: All toggles use the same reusable `ToggleButton` component
- **Fully Configurable**: All settings can be customized via JSON configuration
- **Smart Loading States**: Automatic handling of connecting/disconnecting states
- **Availability Detection**: Automatically hides unavailable services
- **Consistent Animations**: All toggles use the same smooth Material Design 3 animations
- **Easy to Extend**: Adding new toggles requires minimal code

### Configuration

Add the `quickToggles` section to your `~/.config/caelestia/shell.json`:

```json
{
  "quickToggles": {
    "layout": {
      "spacing": 12
    },
    "toggles": {
      "idleInhibitor": {
        "enabled": true,
        "name": "Idle Inhibitor",
        "iconEnabled": "pause_circle",
        "iconDisabled": "play_circle",
        "colorScheme": "primary"
      },
      "nightMode": {
        "enabled": true,
        "name": "Night Mode",
        "iconEnabled": "dark_mode",
        "iconDisabled": "light_mode",
        "colorScheme": "secondary"
      },
      "keyboardBacklight": {
        "enabled": true,
        "name": "Keyboard Backlight",
        "iconEnabled": "keyboard",
        "iconDisabled": "keyboard",
        "colorScheme": "tertiary"
      },
      "doNotDisturb": {
        "enabled": true,
        "name": "Do Not Disturb",
        "iconEnabled": "notifications_off",
        "iconDisabled": "notifications",
        "colorScheme": "error"
      },
      "vpn": {
        "enabled": true,
        "name": "Cloudflare WARP",
        "iconEnabled": "shield",
        "iconDisabled": "shield",
        "colorScheme": "primary",
        "showLoadingState": true
      },
      "gameMode": {
        "enabled": true,
        "name": "Gamemode",
        "iconEnabled": "rocket_launch",
        "iconDisabled": "sports_esports",
        "colorScheme": "secondary"
      }
    },
    "tooltips": {
      "enabled": true,
      "delay": 500,
      "timeout": 3000,
      "showUnavailableServices": true
    }
  }
}
```

### Adding Custom QuickToggles

To add a new toggle, follow these steps:

#### 1. Create Your Service

Create a new service in `services/YourService.qml`:

```qml
pragma Singleton

import Quickshell
import Quickshell.Io

Singleton {
    id: root

    property bool enabled: false
    property bool available: true // Set to false if service is unavailable

    PersistentProperties {
        id: props
        property bool enabled: false
        reloadableId: "yourService"
    }

    // Your service logic here
    function toggle(): void {
        enabled = !enabled;
        // Add your toggle logic
    }

    // Optional: Add connecting/disconnecting states
    property bool connecting: false
    property bool disconnecting: false

    IpcHandler {
        target: "yourService"
        function toggle(): void { root.toggle(); }
        function isEnabled(): bool { return root.enabled; }
        function enable(): void { root.enabled = true; }
        function disable(): void { root.enabled = false; }
    }
}
```

#### 2. Add Configuration

Add your toggle configuration to `config/QuickTogglesConfig.qml`:

```qml
component YourService: JsonObject {
    property bool enabled: true
    property string name: "Your Service"
    property string iconEnabled: "your_enabled_icon"
    property string iconDisabled: "your_disabled_icon"
    property string colorScheme: "primary" // primary, secondary, tertiary, error
    property bool showLoadingState: false // true if you have connecting states
}
```

And add it to the Toggles component:

```qml
component Toggles: JsonObject {
    // ... existing toggles ...
    property YourService yourService: YourService {}
}
```

#### 3. Add to QuickToggles

Add your toggle to `modules/dashboard/dash/QuickToggles.qml`:

```qml
// Your Service Toggle
ToggleButton {
    service: YourService
    config: Config.quickToggles.toggles.yourService
    toggleId: "yourService"
    visible: Config.quickToggles.toggles.yourService.enabled
    showLoadingState: Config.quickToggles.toggles.yourService.showLoadingState
    tooltipsEnabled: Config.quickToggles.tooltips.enabled
    tooltipDelay: Config.quickToggles.tooltips.delay
    tooltipTimeout: Config.quickToggles.tooltips.timeout
    showUnavailableServices: Config.quickToggles.tooltips.showUnavailableServices
}
```

### Service Requirements

Your service should implement:
- `enabled` property (boolean) - Current state of the toggle
- `toggle()` function - Toggle the state
- Optional: `available` property (boolean) - Whether the service is available
- Optional: `connecting` property (boolean) - For loading states
- Optional: `disconnecting` property (boolean) - For loading states

### Color Schemes

Available color schemes:
- `"primary"` - Uses Material Design 3 primary colors
- `"secondary"` - Uses Material Design 3 secondary colors  
- `"tertiary"` - Uses Material Design 3 tertiary colors
- `"error"` - Uses Material Design 3 error colors

### Benefits

- **Maintainable**: Single component to maintain for all toggles
- **Consistent**: All toggles look and behave identically
- **Flexible**: Highly configurable via JSON
- **Performant**: Reduced code duplication means faster loading
- **Extensible**: Easy to add new features to all toggles at once

## FAQ

### My screen is flickering, help pls!

Try disabling VRR in the hyprland config. You can do this by adding the following to `~/.config/caelestia/hypr-user.conf`:

```conf
misc {
    vrr = 0
}
```

### I want to make my own changes to the hyprland config!

You can add your custom hyprland configs to `~/.config/caelestia/hypr-user.conf`.

### I want to make my own changes to other stuff!

See the [manual installation](https://github.com/caelestia-dots/shell?tab=readme-ov-file#manual-installation) section
for the corresponding repo.

### I want to disable XXX feature!

Please read the [configuring](https://github.com/caelestia-dots/shell?tab=readme-ov-file#configuring) section in the readme.
If there is no corresponding option, make feature request.

### How do I make my colour scheme change with my wallpaper?

Set a wallpaper via the launcher or `caelestia wallpaper` and set the scheme to the dynamic scheme via the launcher
or `caelestia scheme set`. e.g.

```sh
caelestia wallpaper -f <path/to/file>
caelestia scheme set -n dynamic
```

### My wallpapers aren't showing up in the launcher!

The launcher pulls wallpapers from `~/Pictures/Wallpapers` by default. You can change this in the config. Additionally,
the launcher only shows an odd number of wallpapers at one time. If you only have 2 wallpapers, consider getting more
(or just putting one).

## Credits

### Original Project
This is a personal fork of the excellent [caelestia-shell](https://github.com/caelestia-dots/shell) project. All credit for the original design, architecture, and core functionality goes to the original developers and contributors.

### Original Credits
Thanks to the Hyprland discord community (especially the homies in #rice-discussion) for all the help and suggestions
for improving these dots!

A special thanks to [@outfoxxed](https://github.com/outfoxxed) for making Quickshell and the effort put into fixing issues
and implementing various feature requests.

Another special thanks to [@end_4](https://github.com/end-4) for his [config](https://github.com/end-4/dots-hyprland)
which helped me a lot with learning how to use Quickshell.

Finally another thank you to all the configs I took inspiration from (only one for now):

- [Axenide/Ax-Shell](https://github.com/Axenide/Ax-Shell)

### Additional Credits for Custom Features
- [Cava](https://github.com/karlstav/cava) - Audio visualizer library
- [Hyprsunset](https://github.com/hyprwm/hyprsunset) - Blue light filter for Hyprland
- [Cloudflare WARP](https://developers.cloudflare.com/warp-client/) - VPN service integration

## Contributing

This is a personal fork, but if you find any issues or have suggestions for improvements, feel free to:
- Open an issue on [GitHub](https://github.com/liammmcauliffe/shell/issues)
- Submit a pull request if you have improvements
- Check the [original project](https://github.com/caelestia-dots/shell) for upstream issues and features

## License

This project is licensed under the GPL-3.0 License - see the [LICENSE](LICENSE) file for details.

## Stonks 📈

<a href="https://www.star-history.com/#liammmcauliffe/shell&caelestia-dots/shell&Date">
 <picture>
   <source media="(prefers-color-scheme: dark)" srcset="https://api.star-history.com/svg?repos=liammmcauliffe/shell,caelestia-dots/shell&type=Date&theme=dark" />
   <source media="(prefers-color-scheme: light)" srcset="https://api.star-history.com/svg?repos=liammmcauliffe/shell,caelestia-dots/shell&type=Date" />
   <img alt="Star History Chart" src="https://api.star-history.com/svg?repos=liammmcauliffe/shell,caelestia-dots/shell&type=Date" />
 </picture>
</a>
