import Qt 4.7

Rectangle {
    id: albumsList
    signal clicked(string album)
    property ListModel model
    width: parent.width
    color: "#fff"

    MouseArea {
        anchors.fill: parent
        onClicked: { }
    }

    ListView {
        model: albumsList.model
        anchors.fill: parent
        delegate: albumsListDelegate
        highlightFollowsCurrentItem: true
    }

    Component {
        id: albumsListDelegate

        Item {
            id: albumItem
            width: parent.width
            height: albumContainer.height + 2
            property string album: album_id

            Rectangle {
                id: albumContainer
                color: mouseArea.pressed ? "#ddd" : "#fff"
                y: 1
                width: parent.width
                height: statusTextArea.height + 8 < 56 ? 56 : statusTextArea.height + 4

                Row {
                    id: statusTextArea
                    spacing: 4
                    x: 4
                    y: 2
                    width: parent.width - 8

                    Image {
                        id: albumCoverImage
                        source: cover
                    }

                    Text {
                        id: messageText
                        color: "#111"
                        font.pixelSize: 18
                        width: parent.width
                        text: "<span><b>" + name + "</b> (" + count + ")<br/>Updated " + updated_time  + "</span>"
                        wrapMode: Text.Wrap
                    }
                }
            }

            Rectangle {
                width:  parent.width
                x: 4
                y: albumItem.height - 1
                height: 1
                color: "#ddd"
            }

            MouseArea {
                id: mouseArea
                anchors.fill: parent
                onClicked: {
                    albumsList.clicked( albumItem.album );
                }
            }

        }
    }

    states: [
        State {
            name: "hidden"
            PropertyChanges {
                target: albumsList
                x: parent.width
            }
        },
        State {
            name: "shown"
            PropertyChanges {
                target: albumsList
                x: 0
            }
        }
    ]

    transitions: [
        Transition {
            SequentialAnimation {
                PropertyAnimation {
                    target: albumsList
                    properties: "x"
                    duration: 300
                    easing.type: "InOutQuad"
                }
            }
        }
    ]
}
