import Qt 4.7

Rectangle {
    id: waitingIndicator
    y: 60
    //x: 10
    anchors.horizontalCenter: parent.horizontalCenter
    property string label: "Please wait..."
    width: doneItems.width+30
    height: doneItems.height+20
    color: "#3B5998"
    radius: 5
    opacity: 0.9
    smooth: true
    state: "hidden"

    /*Image {
        source: "../pics/sand.png"
    }*/

    Row {
        id: doneItems
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        spacing: 10

        Image {
            source: "../pics/clock_48.png"
        }

        Text {
            id: doneText
            text: waitingIndicator.label
            color: "#eee"
            font.pixelSize: 22
            anchors.verticalCenter: parent.verticalCenter
        }
    }

    states:
        State {
        name: "hidden"
        PropertyChanges {
            target: waitingIndicator
            y: 0 - waitingIndicator.height - 1
        }
    }
    State {
        name: "shown"
        PropertyChanges {
            target: waitingIndicator
            y: 10
        }
    }

    transitions: [
        Transition {
            SequentialAnimation {
                PropertyAnimation {
                    target: waitingIndicator
                    properties: "y"
                    duration: 200
                    easing.type: "InOutCubic"
                }/*
                PropertyAnimation {
                    target: waitingIndicator
                    properties: "y"
                    duration: 8000
                }
                ScriptAction {
                    script: {
                        waitingIndicator.state = "hidden";
                    }
                }*/
            }
        }
    ]
}
