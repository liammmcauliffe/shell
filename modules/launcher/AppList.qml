pragma ComponentBehavior: Bound

import "items"
import "services"
import qs.components
import qs.components.controls
import qs.components.containers
import qs.services
import qs.config
import Quickshell
import QtQuick
import QtQuick.Controls

StyledListView {
    id: root

    required property TextField search
    required property PersistentProperties visibilities

    model: ScriptModel {
        id: model

        onValuesChanged: {
            if (root.currentIndex >= count) {
                root.currentIndex = 0;
            }
        }
    }

    spacing: Appearance.spacing.small
    orientation: Qt.Vertical
    implicitHeight: (Config.launcher.sizes.itemHeight + spacing) * Math.min(Config.launcher.maxShown, count) - spacing

    highlightMoveDuration: Appearance.anim.durations.normal
    highlightResizeDuration: 0
    preferredHighlightBegin: 0
    preferredHighlightEnd: height
    highlightRangeMode: ListView.ApplyRange

    highlightFollowsCurrentItem: false
    highlight: StyledRect {
        radius: Appearance.rounding.normal
        color: Colours.palette.m3onSurface
        opacity: 0.08
        y: root.currentItem?.y ?? 0
        implicitWidth: root.width
        implicitHeight: root.currentItem?.implicitHeight ?? 0
        Behavior on y {
            Anim {
                duration: Appearance.anim.durations.expressiveDefaultSpatial
                easing.bezierCurve: Appearance.anim.curves.expressiveDefaultSpatial
            }
        }
    }

    property string currentState: "apps"
    property string lastSearchText: ""

    property string searchText: search.text

    function updateModelValues() {
        const text = search.text;
        switch (currentState) {
            case "apps":
                model.values = Apps.search(text);
                root.delegate = appItem;
                break;
            case "actions":
                model.values = Actions.query(text);
                root.delegate = actionItem;
                break;
            case "calc":
                model.values = [0];
                root.delegate = calcItem;
                break;
            case "scheme":
                model.values = Schemes.query(text);
                root.delegate = schemeItem;
                break;
            case "variant":
                model.values = M3Variants.query(text);
                root.delegate = variantItem;
                break;
        }
    }

    onSearchTextChanged: {
        const text = search.text;
        const prefix = Config.launcher.actionPrefix;
        let newState = "apps";
        
        if (text.startsWith(prefix)) {
            for (const action of ["calc", "scheme", "variant"])
                if (text.startsWith(`${prefix}${action} `)) {
                    newState = action;
                    break;
                }
            if (newState === "apps")
                newState = "actions";
        }

        if (newState !== currentState) {
            currentState = newState;
            state = currentState;
            if (state === "scheme" || state === "variant")
                Schemes.reload();
        }
        
        lastSearchText = text;
        updateModelValues();
    }

    onCurrentStateChanged: {
        updateModelValues();
    }

    Component.onCompleted: {
        updateModelValues();
    }

    states: [
        State {
            name: "apps"
        },
        State {
            name: "actions"
        },
        State {
            name: "calc"
        },
        State {
            name: "scheme"
        },
        State {
            name: "variant"
        }
    ]

    transitions: Transition {
        SequentialAnimation {
            ParallelAnimation {
                Anim {
                    target: root
                    property: "opacity"
                    from: 1
                    to: 0
                    duration: Appearance.anim.durations.small
                    easing.bezierCurve: Appearance.anim.curves.standardAccel
                }
                Anim {
                    target: root
                    property: "scale"
                    from: 1
                    to: 0.9
                    duration: Appearance.anim.durations.small
                    easing.bezierCurve: Appearance.anim.curves.standardAccel
                }
            }
            PropertyAction {
                targets: [model, root]
                properties: "values,delegate"
            }
            ParallelAnimation {
                Anim {
                    target: root
                    property: "opacity"
                    from: 0
                    to: 1
                    duration: Appearance.anim.durations.small
                    easing.bezierCurve: Appearance.anim.curves.standardDecel
                }
                Anim {
                    target: root
                    property: "scale"
                    from: 0.9
                    to: 1
                    duration: Appearance.anim.durations.small
                    easing.bezierCurve: Appearance.anim.curves.standardDecel
                }
            }
            PropertyAction {
                targets: [root.add, root.remove]
                property: "enabled"
                value: true
            }
        }
    }

    ScrollBar.vertical: StyledScrollBar {}

    add: Transition {
        enabled: !root.state

        Anim {
            properties: "opacity,scale"
            from: 0
            to: 1
        }
    }

    remove: Transition {
        enabled: !root.state

        Anim {
            properties: "opacity,scale"
            from: 1
            to: 0
        }
    }

    move: Transition {
        Anim {
            property: "y"
        }
        Anim {
            properties: "opacity,scale"
            to: 1
        }
    }

    addDisplaced: Transition {
        Anim {
            property: "y"
            duration: Appearance.anim.durations.small
        }
        Anim {
            properties: "opacity,scale"
            to: 1
        }
    }

    displaced: Transition {
        Anim {
            property: "y"
        }
        Anim {
            properties: "opacity,scale"
            to: 1
        }
    }

    Component {
        id: appItem

        AppItem {
            visibilities: root.visibilities
        }
    }

    Component {
        id: actionItem

        ActionItem {
            list: root
        }
    }

    Component {
        id: calcItem

        CalcItem {
            list: root
        }
    }

    Component {
        id: schemeItem

        SchemeItem {
            list: root
        }
    }

    Component {
        id: variantItem

        VariantItem {
            list: root
        }
    }
}
