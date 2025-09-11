import Quickshell.Io

JsonObject {
    property bool enabled: true
    property DesktopClock desktopClock: DesktopClock {}
    property Visualiser visualiser: Visualiser {}

    component DesktopClock: JsonObject {
        property bool enabled: true
        property string position: "random" // "center", "top-left", "top-right", "bottom-left", "bottom-right", "random", "custom"
        property bool showDate: true
        property bool showSeconds: false
        property string size: "normal" // "small", "normal", "large"
        property string dateFormat: "dddd, MMMM dd, yyyy" // Custom date format
        property int customX: 0 // Custom X position (when position is "custom")
        property int customY: 0 // Custom Y position (when position is "custom")
    }

    component Visualiser: JsonObject {
        property bool enabled: false
        property bool autoHide: true
        property real rounding: 1
        property real spacing: 1
    }
}
