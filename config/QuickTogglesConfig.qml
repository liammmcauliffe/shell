import Quickshell.Io

JsonObject {
    property Layout layout: Layout {}
    property Toggles toggles: Toggles {}
    property Tooltips tooltips: Tooltips {}

    component Layout: JsonObject {
        property real spacing: 12
    }

    component Toggles: JsonObject {
        property IdleInhibitor idleInhibitor: IdleInhibitor {}
        property NightMode nightMode: NightMode {}
        property KeyboardBacklight keyboardBacklight: KeyboardBacklight {}
        property DoNotDisturb doNotDisturb: DoNotDisturb {}
        property Vpn vpn: Vpn {}
        property GameMode gameMode: GameMode {}
    }

    component IdleInhibitor: JsonObject {
        property bool enabled: true
        property string name: "Idle Inhibitor"
        property string iconEnabled: "pause_circle"
        property string iconDisabled: "play_circle"
        property string colorScheme: "primary"
    }

    component NightMode: JsonObject {
        property bool enabled: true
        property string name: "Night Mode"
        property string iconEnabled: "dark_mode"
        property string iconDisabled: "light_mode"
        property string colorScheme: "secondary"
    }

    component KeyboardBacklight: JsonObject {
        property bool enabled: true
        property string name: "Keyboard Backlight"
        property string iconEnabled: "keyboard"
        property string iconDisabled: "keyboard"
        property string colorScheme: "tertiary"
    }

    component DoNotDisturb: JsonObject {
        property bool enabled: true
        property string name: "Do Not Disturb"
        property string iconEnabled: "notifications_off"
        property string iconDisabled: "notifications"
        property string colorScheme: "error"
    }

    component Vpn: JsonObject {
        property bool enabled: true
        property string name: "Cloudflare WARP"
        property string iconEnabled: "shield"
        property string iconDisabled: "shield"
        property string colorScheme: "primary"
        property bool showLoadingState: true
    }

    component GameMode: JsonObject {
        property bool enabled: true
        property string name: "Gamemode"
        property string iconEnabled: "rocket_launch"
        property string iconDisabled: "sports_esports"
        property string colorScheme: "secondary"
    }

    component Tooltips: JsonObject {
        property bool enabled: true
        property int delay: 500
        property int timeout: 3000
        property bool showUnavailableServices: true
    }
}
