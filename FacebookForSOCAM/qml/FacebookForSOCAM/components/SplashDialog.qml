import Qt 4.7

Rectangle {
    width: parent.width
    height: copyTexts.height + 20
    color: "#ddd"

    Column {
        id: copyTexts
        y: 10
        width: parent.width

        Text {
            text: "Kasvopus 1.2.2"
            anchors.horizontalCenter: parent.horizontalCenter
            color: "#333"
            font.pixelSize: 22
        }

        Text {
            text: "Crafted by\nTommi Laukkanen (@tlaukkanen)\nhttp://kasvopus.com"
            anchors.horizontalCenter: parent.horizontalCenter
            color: "#666"
            font.pixelSize: 22
        }
    }

}
