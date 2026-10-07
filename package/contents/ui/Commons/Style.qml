pragma Singleton
import QtQuick
import org.kde.kirigami as Kirigami
import "../Io"
QtObject {
    readonly property string family: Native.resolveFont(Kirigami.Theme.defaultFont.family)
    readonly property var font: ({family: family, caption: 12, bodySmall: 13, subtitle: 16, heading: 25, title: 30, display: 30})
    readonly property var spacing: ({xs: 3, sm: 5, md: 8, lg: 12, xl: 16, rowPaddingX: 15, panelGap: 16, popupRowHeight: 38})
    readonly property int cornerRadius: 10
    function space(n) { return Math.round(n) }
    function spaceReal(n) { return n }
    function duration(n) { return n }
}
