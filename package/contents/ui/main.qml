import QtQuick
import QtQuick.Layouts
import org.kde.plasma.plasmoid
import org.kde.plasma.core as PlasmaCore
import org.kde.plasma.components as PlasmaComponents

PlasmoidItem {
    id: applet
    readonly property bool inPanel: Plasmoid.formFactor === PlasmaCore.Types.Horizontal || Plasmoid.formFactor === PlasmaCore.Types.Vertical
    preferredRepresentation: inPanel ? compactRepresentation : fullRepresentation
    Plasmoid.backgroundHints: PlasmaCore.Types.StandardBackground
    toolTipMainText: "Elsewhen"
    toolTipSubText: "World clock · click the globe to explore"
    compactRepresentation: PlasmaComponents.ToolButton {
        icon.name: "globe"
        text: "Elsewhen"
        display: PlasmaComponents.ToolButton.IconOnly
        onClicked: applet.expanded = !applet.expanded
    }
    fullRepresentation: WorldClock {
        Layout.minimumWidth: 388
        Layout.minimumHeight: 540
        Layout.preferredWidth: 388
        Layout.preferredHeight: 600
        opened: applet.expanded || !applet.inPanel
        settings: {
            try { return JSON.parse(Plasmoid.configuration.state) } catch (e) { return ({}) }
        }
        onSettingsEdited: function(values) { Plasmoid.configuration.state = JSON.stringify(values) }
        onCloseRequested: applet.expanded = false
    }
}
