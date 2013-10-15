import Qt 4.7

Rectangle {
    id: notficationsList
    signal clicked(int index)
    property ListModel notificationsModel
    width: parent.width
    color: "#fff"

    MouseArea {
        anchors.fill: parent
        onClicked: { }
    }

    ListView {
        model: notficationsList.notificationsModel
        anchors.fill: parent
        delegate: notificationsListDelegate
        highlightFollowsCurrentItem: true
    }

    Component {
        id: notificationsListDelegate

        Item {
            id: notificationItem
            width: parent.width
            height: titleContainer.height + 2

            Rectangle {
                id: titleContainer
                color: mouseArea.pressed ? "#ddd" : "#fff"
                y: 1
                width: parent.width
                height: statusTextArea.height + 8 < 56 ? 56 : statusTextArea.height + 8

                Image {
                    x: 4
                    y: 2
                    source: icon_url
                }

                Column {
                    id: statusTextArea
                    spacing: 4
                    x: 62 // profileImage.width + 12
                    y: 4
                    width: parent.width - 62

                    Text {
                        id: messageText
                        color: "#111"
                        font.pixelSize: 18
                        width: parent.width
                        text: title
                        wrapMode: Text.Wrap
                    }
                }
            }

            Rectangle {
                width:  parent.width
                x: 4
                y: notificationItem.height - 1
                height: 1
                color: "#ddd"
            }

            MouseArea {
                id: mouseArea
                anchors.fill: parent
                onClicked: {
                    notficationsList.clicked( index );
                }
            }

        }
    }

    states: [
        State {
            name: "hidden"
            PropertyChanges {
                target: notificationsList
                y: parent.height
            }
        },
        State {
            name: "shown"
            PropertyChanges {
                target: notificationsList
                y: 50
            }
        }
    ]

    transitions: [
        Transition {
            SequentialAnimation {
                PropertyAnimation {
                    target: notificationsList
                    properties: "y"
                    duration: 300
                    easing.type: "InOutQuad"
                }
            }
        }
    ]
}
