import Qt 4.7

Item {
    id: notificationBar
    width:  48
    height: 32
    y: 9
    x: 52
    z: 5
    signal menuClicked()
    opacity: count=="0" ? 0 : 1
    property string count: "0"
    state: "hidden"

    Rectangle {
        id: menubar
        anchors.fill: parent
        state: "shown"
        radius: 5
        color: "#d00"

        Text {
            font.pixelSize: 20
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            text: notificationBar.count
            font.bold: true
            color: "#fff"
        }

        MouseArea {
            anchors.fill: parent
            onClicked: notificationBar.menuClicked();
        }

    }

    states: [
        State {
            name: "hidden"
            PropertyChanges {
                target: notificationBar
                opacity: 0
            }
        },
        State {
            name: "shown"
            PropertyChanges {
                target: notificationBar
                opacity: 1
            }
        }
    ]

}
