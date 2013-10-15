import Qt 4.7

Item {
    id: iconItem
    signal clicked()
    width: 70
    height: 70
    property alias source: icon.source
    property alias label: iconLabel.text
    opacity: mouseArea.pressed ? 0.7 : 1.0

    Image {
        id: icon
        source: "../pics/111-user@2x.png"
        anchors.centerIn: parent
    }

    Text {
        id: iconLabel
        font.pixelSize: 12
        color: "#ddd"
        text: "Wall"
        anchors.verticalCenter: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        onClicked: iconItem.clicked();
    }
}
