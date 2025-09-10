import Quickshell.Io

JsonObject {
    property Apps apps: Apps {}

    component Apps: JsonObject {
        property list<string> terminal: ["ghostty"]
        property list<string> audio: ["pavucontrol"]
    }
}
