import qs.components
import qs.components.controls
import qs.services
import qs.config
import Quickshell
import QtQuick
import QtQuick.Layouts

StyledRect {
    id: root

    anchors.fill: parent
    implicitHeight: 200
    radius: Appearance.rounding.small

    GridLayout {
        anchors.fill: parent
        anchors.margins: Appearance.padding.normal
        columns: 3
        rowSpacing: Config.quickToggles.layout.spacing
        columnSpacing: Config.quickToggles.layout.spacing

        // Idle Inhibitor Toggle
        ToggleButton {
            service: IdleInhibitor
            config: Config.quickToggles.toggles.idleInhibitor
            toggleId: "idleInhibitor"
            visible: Config.quickToggles.toggles.idleInhibitor.enabled
            tooltipsEnabled: Config.quickToggles.tooltips.enabled
            tooltipDelay: Config.quickToggles.tooltips.delay
            tooltipTimeout: Config.quickToggles.tooltips.timeout
            showUnavailableServices: Config.quickToggles.tooltips.showUnavailableServices
        }

        // Night Mode Toggle
        ToggleButton {
            service: NightMode
            config: Config.quickToggles.toggles.nightMode
            toggleId: "nightMode"
            visible: Config.quickToggles.toggles.nightMode.enabled
            tooltipsEnabled: Config.quickToggles.tooltips.enabled
            tooltipDelay: Config.quickToggles.tooltips.delay
            tooltipTimeout: Config.quickToggles.tooltips.timeout
            showUnavailableServices: Config.quickToggles.tooltips.showUnavailableServices
        }

        // Keyboard Backlight Toggle
        ToggleButton {
            service: KeyboardBacklight
            config: Config.quickToggles.toggles.keyboardBacklight
            toggleId: "keyboardBacklight"
            visible: Config.quickToggles.toggles.keyboardBacklight.enabled
            tooltipsEnabled: Config.quickToggles.tooltips.enabled
            tooltipDelay: Config.quickToggles.tooltips.delay
            tooltipTimeout: Config.quickToggles.tooltips.timeout
            showUnavailableServices: Config.quickToggles.tooltips.showUnavailableServices
        }

        // Do Not Disturb Toggle
        ToggleButton {
            service: DoNotDisturb
            config: Config.quickToggles.toggles.doNotDisturb
            toggleId: "doNotDisturb"
            visible: Config.quickToggles.toggles.doNotDisturb.enabled
            tooltipsEnabled: Config.quickToggles.tooltips.enabled
            tooltipDelay: Config.quickToggles.tooltips.delay
            tooltipTimeout: Config.quickToggles.tooltips.timeout
            showUnavailableServices: Config.quickToggles.tooltips.showUnavailableServices
        }

        // VPN Toggle
        ToggleButton {
            service: Vpn
            config: Config.quickToggles.toggles.vpn
            toggleId: "vpn"
            showLoadingState: Config.quickToggles.toggles.vpn.showLoadingState
            visible: Config.quickToggles.toggles.vpn.enabled
            tooltipsEnabled: Config.quickToggles.tooltips.enabled
            tooltipDelay: Config.quickToggles.tooltips.delay
            tooltipTimeout: Config.quickToggles.tooltips.timeout
            showUnavailableServices: Config.quickToggles.tooltips.showUnavailableServices
            loadingColor: Colours.palette.m3onTertiary
            loadingErrorColor: Colours.palette.m3onError
        }

        // Game Mode Toggle
        ToggleButton {
            service: GameMode
            config: Config.quickToggles.toggles.gameMode
            toggleId: "gameMode"
            visible: Config.quickToggles.toggles.gameMode.enabled
            tooltipsEnabled: Config.quickToggles.tooltips.enabled
            tooltipDelay: Config.quickToggles.tooltips.delay
            tooltipTimeout: Config.quickToggles.tooltips.timeout
            showUnavailableServices: Config.quickToggles.tooltips.showUnavailableServices
        }
    }
}