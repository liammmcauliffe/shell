#!/usr/bin/env python3

# From https://github.com/stwa/wayland-idle-inhibitor
# License: WTFPL Version 2

import sys
import os
from dataclasses import dataclass
from signal import SIGINT, SIGTERM, signal
from threading import Event
import setproctitle

try:
    from pywayland.client.display import Display
    from pywayland.protocol.idle_inhibit_unstable_v1.zwp_idle_inhibit_manager_v1 import (
        ZwpIdleInhibitManagerV1,
    )
    from pywayland.protocol.wayland.wl_compositor import WlCompositor
    from pywayland.protocol.wayland.wl_registry import WlRegistryProxy
    from pywayland.protocol.wayland.wl_surface import WlSurface
except ImportError as e:
    print(f"Error: Missing required dependencies: {e}")
    print("Please install pywayland: pip install pywayland")
    sys.exit(1)


@dataclass
class GlobalRegistry:
    surface: WlSurface | None = None
    inhibit_manager: ZwpIdleInhibitManagerV1 | None = None


def handle_registry_global(
    wl_registry: WlRegistryProxy, id_num: int, iface_name: str, version: int
) -> None:
    global_registry: GlobalRegistry = wl_registry.user_data or GlobalRegistry()

    if iface_name == "wl_compositor":
        compositor = wl_registry.bind(id_num, WlCompositor, version)
        global_registry.surface = compositor.create_surface()  # type: ignore
    elif iface_name == "zwp_idle_inhibit_manager_v1":
        global_registry.inhibit_manager = wl_registry.bind(
            id_num, ZwpIdleInhibitManagerV1, version
        )


def main() -> None:
    # Check if we're in a wayland session
    if not os.environ.get('WAYLAND_DISPLAY') and not os.environ.get('XDG_SESSION_TYPE') == 'wayland':
        print("Error: Not running in a Wayland session")
        print("This script requires a Wayland session to work")
        sys.exit(1)

    done = Event()
    signal(SIGINT, lambda _, __: done.set())
    signal(SIGTERM, lambda _, __: done.set())

    global_registry = GlobalRegistry()

    try:
        display = Display()
        display.connect()
    except Exception as e:
        print(f"Error: Failed to connect to Wayland display: {e}")
        sys.exit(1)

    try:
        registry = display.get_registry()  # type: ignore
        registry.user_data = global_registry
        registry.dispatcher["global"] = handle_registry_global
    except Exception as e:
        print(f"Error: Failed to get Wayland registry: {e}")
        display.disconnect()
        sys.exit(1)

    def shutdown() -> None:
        try:
            display.dispatch()
            display.roundtrip()
            display.disconnect()
        except Exception as e:
            print(f"Warning: Error during shutdown: {e}")

    try:
        display.dispatch()
        display.roundtrip()
    except Exception as e:
        print(f"Error: Failed to dispatch Wayland events: {e}")
        shutdown()
        sys.exit(1)

    if global_registry.surface is None or global_registry.inhibit_manager is None:
        print("Error: Wayland compositor does not support idle_inhibit_unstable_v1 protocol")
        print("This feature requires a Wayland compositor that supports idle inhibition")
        shutdown()
        sys.exit(1)

    try:
        inhibitor = global_registry.inhibit_manager.create_inhibitor(  # type: ignore
            global_registry.surface
        )
    except Exception as e:
        print(f"Error: Failed to create idle inhibitor: {e}")
        shutdown()
        sys.exit(1)

    try:
        display.dispatch()
        display.roundtrip()
    except Exception as e:
        print(f"Error: Failed to dispatch after creating inhibitor: {e}")
        inhibitor.destroy()
        shutdown()
        sys.exit(1)

    print("Inhibiting idle...")
    done.wait()
    print("Shutting down...")

    try:
        inhibitor.destroy()
    except Exception as e:
        print(f"Warning: Error destroying inhibitor: {e}")

    shutdown()


if __name__ == "__main__":
    setproctitle.setproctitle("wayland-idle-inhibitor.py")
    main() 