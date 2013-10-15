import Qt 4.7

Rectangle {
    id: friendsList
    signal clicked(int index)
    width: parent.width
    color: "#fff"

    MouseArea {
        anchors.fill: parent
        onClicked: { }
    }

    ListView {
        model: friendsModel
        anchors.fill: parent
        delegate: friendsListDelegate
        highlightFollowsCurrentItem: true
    }

    Component {
        id: friendsListDelegate

        Item {
            id: friendItem
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
                    id: profileImage
                    source: profileImageUrl
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
                        text: "<span style='color:#3B5998'><b>" + name + "</b></span>"
                        wrapMode: Text.Wrap
                    }
                }
            }

            Rectangle {
                width:  parent.width
                x: 4
                y: friendItem.height - 1
                height: 1
                color: "#ddd"
            }

            MouseArea {
                id: mouseArea
                anchors.fill: parent
                onClicked: {
                    friendsList.clicked( index );
                }
            }

        }
    }

    states: [
        State {
            name: "hidden"
            PropertyChanges {
                target: friendsList
                x: parent.width
            }
        },
        State {
            name: "hiddenLeft"
            PropertyChanges {
                target: friendsList
                x: -parent.width
            }
        },
        State {
            name: "shown"
            PropertyChanges {
                target: friendsList
                x: 0
            }
        }
    ]

    transitions: [
        Transition {
            SequentialAnimation {
                PropertyAnimation {
                    target: friendsList
                    properties: "x"
                    duration: 300
                    easing.type: "InOutQuad"
                }
            }
        }
    ]
}
