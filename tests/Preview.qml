import QtQuick
import QtQuick.Window
import "../package/contents/ui"
import "../package/contents/ui/Commons" as Compat
Window {
    width: 388
    height: 600
    visible: true
    color: Compat.Color.background
    WorldClock {
        id: clock
        anchors.fill: parent
        opened: true
        settings: ({zones: "São Paulo|America/Sao_Paulo, London|Europe/London, Tokyo|Asia/Tokyo", hour24: true})
    }
}
