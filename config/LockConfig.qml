import Quickshell.Io

JsonObject {
    property bool recolourLogo: true
    property bool enableFprint: false
    property int maxFprintTries: 3
    property Sizes sizes: Sizes {}

    component Sizes: JsonObject {
        property real heightMult: 0.7
        property real ratio: 16 / 9
        property int centerWidth: 600
    }
}
