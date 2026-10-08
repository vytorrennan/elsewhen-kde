import QtQuick
import "Commons" as Compat
import "Ui"

// The matches for a CitySearch; hosts that overlay results place this themselves.
Column {
  id: list

  required property var citySearch

  spacing: Compat.Style.space(2)

  Repeater {
    model: list.citySearch.matches

    CursorSurface {
      id: match
      required property var modelData
      required property int index

      width: parent.width
      implicitHeight: Compat.Style.spacing.popupRowHeight
      foreground: list.citySearch.foreground
      hasCursor: list.citySearch.selectedIndex === index

      Text {
        anchors.left: parent.left
        anchors.leftMargin: Compat.Style.spacing.xl
        anchors.right: matchZone.left
        anchors.rightMargin: Compat.Style.spacing.lg
        anchors.verticalCenter: parent.verticalCenter
        textFormat: Text.PlainText
        text: match.modelData.label
        color: list.citySearch.foreground
        font.family: list.citySearch.fontFamily
        font.pixelSize: list.citySearch.fontSize
        elide: Text.ElideRight
      }

      // Two cities in one zone differ by name, two zones with one name by offset.
      Row {
        id: matchZone
        anchors.right: parent.right
        anchors.rightMargin: Compat.Style.spacing.xl
        anchors.verticalCenter: parent.verticalCenter
        spacing: Compat.Style.spacing.md

        Caption {
          text: match.modelData.value
          color: list.citySearch.fainter
        }

        Caption {
          text: list.citySearch.offsetLabel(match.modelData.value)
          visible: text !== ""
        }
      }

      // Only movement moves the selection, so a resting pointer cannot
      // steal it from the arrow keys as the list rebuilds.
      MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onPositionChanged: list.citySearch.selectedIndex = match.index
        onClicked: list.citySearch.pick(match.modelData)
      }
    }
  }

  Caption {
    visible: list.citySearch.matches.length === 0
    width: parent.width
    horizontalAlignment: Text.AlignHCenter
    topPadding: Compat.Style.spacing.md
    text: list.citySearch.loading ? list.citySearch.loadingText : "No matches"
    color: list.citySearch.fainter
  }

  component Caption: Text {
    textFormat: Text.PlainText
    color: list.citySearch.dim
    font.family: list.citySearch.fontFamily
    font.pixelSize: Compat.Style.font.caption
  }
}
