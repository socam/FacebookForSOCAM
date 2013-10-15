import Qt 4.7

Rectangle {
    id: wall
    width: parent.width
    height: parent.height
    property ListModel model
    property string user_id: ""
    property string user_name: ""
    signal showPhotosClicked(string user_id)
    signal showComment(string wall_id)
    signal clicked(int index)

    MouseArea {
        anchors.fill: parent
        onClicked: { }
    }


    HomeList {
        //id: wallList
        homeModel: wall.model
        width: parent.width
        y: menubar.height
        height: parent.height - menubar.height
        state: "shown"

        onClicked: {
            wall.clicked(index);
        }
    }

    Rectangle {
        id: menubar
        y: 0
        height: 50
        x: 0
        width: parent.width
        state: "shown"
        gradient: Gradient {
            //GradientStop { position: 0.0; color: "#F2F2F2" }
            GradientStop { position: 0.08; color: "#6079AB" }
            GradientStop { position: 0.5; color: "#3B5998" }
            GradientStop { position: 1.0; color: "#29447E" } // "#1a1a1a"
        }

        MouseArea {
            anchors.fill: parent
            onClicked: {
                console.log("I'm not letting this click to leak underneath me...");
            }
        }

        TitleButtonEx {
            width: parent.width/2 - 10
            height: 40
            buttonOpacity: 0.6
            x: 5
            y: 5
            onClicked: {
                //wall.state = "hidden";
                wall.showComment(wall.user_id);
            }
            label: "Write"
            visible: wall.user_id=="me"
        }

        TitleButtonEx {
            width: parent.width/2 - 10
            x: parent.width/2 + 5
            y: 5
            height: 40
            buttonOpacity: 0.6
            onClicked: {
                wall.state = "hidden";
                wall.showPhotosClicked(wall.user_id);
            }
            label: "Photos"
        }
    }

    Image {
        source: "../pics/top-shadow.png"
        width: parent.width
        x:0
        y:menubar.y + menubar.height - 1
    }

    states: [
        State {
            name: "hidden"
            PropertyChanges {
                target: wall
                x: parent.width
            }
        },
        State {
            name: "shown"
            PropertyChanges {
                target: wall
                x: 0
            }
        }
    ]

    transitions: [
        Transition {
            SequentialAnimation {
                PropertyAnimation {
                    target: wall
                    properties: "x"
                    duration: 300
                    easing.type: "InOutQuad"
                }
            }
        }
    ]
}
