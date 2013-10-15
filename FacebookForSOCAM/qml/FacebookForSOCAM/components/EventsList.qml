import Qt 4.7

Rectangle {
    id: eventsList
    signal clicked(int index)
    property ListModel eventsModel
    width: parent.width
    color: "#fff"

    MouseArea {
        anchors.fill: parent
        onClicked: { }
    }

    ListView {
        model: eventsList.eventsModel
        anchors.fill: parent
        delegate: eventsListDelegate
        highlightFollowsCurrentItem: true
    }

    Component {
        id: eventsListDelegate

        Item {
            id: eventsItem
            width: parent.width
            height: titleContainer.height + 2

            Rectangle {
                id: titleContainer
                color: mouseArea.pressed ? "#ddd" : "#fff"
                y: 1
                width: parent.width
                height: statusTextArea.height + 8 < 56 ? 56 : statusTextArea.height + 8

                Column {
                    id: statusTextArea
                    spacing: 4
                    x: 4
                    y: 4
                    width: parent.width - 8

                    Text {
                        id: messageText
                        color: "#111"
                        font.pixelSize: 18
                        width: parent.width
                        text: "<span><b>" + name + "</b><br/>" + location + "<br/>" + start_time + "</span>"
                        wrapMode: Text.Wrap
                    }
                }
            }

            Rectangle {
                width:  parent.width
                x: 4
                y: eventsItem.height - 1
                height: 1
                color: "#ddd"
            }

            MouseArea {
                id: mouseArea
                anchors.fill: parent
                onClicked: {
                    eventsList.clicked( index );
                }
            }

        }
    }

    states: [
        State {
            name: "hidden"
            PropertyChanges {
                target: eventsList
                x: parent.width
            }
        },
        State {
            name: "shown"
            PropertyChanges {
                target: eventsList
                x: 0
            }
        }
    ]

    transitions: [
        Transition {
            SequentialAnimation {
                PropertyAnimation {
                    target: eventsList
                    properties: "x"
                    duration: 300
                    easing.type: "InOutQuad"
                }
            }
        }
    ]
}
