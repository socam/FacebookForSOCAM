import Qt 4.7
Item {
    id: toolbar
    width:  parent.width
    height: 50
    signal menuClicked()
    signal homeClicked()
    signal minimizeClicked();
    signal shareStatusClicked()
    property bool showBack: false
    property bool showMinimize: false
    z: 1

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
/*
        Text{
            text: "Kasvopus"
            anchors.centerIn: parent
            font.pixelSize: 24
            color: "#fff"
        }
*/
        TitleButtonEx {
            id: mainMenuButtonEx
            width: 150
            anchors.centerIn: parent
            pixelSize: 24
            height: 40
            buttonOpacity: 0.6
            label: "Kasvopus"
            onClicked: toolbar.homeClicked();
        }

        /*Image {
            id: homeButtonEx
            source: "../pics/arrow_left.png"
            x: 10 //parent.width - width - 10
            anchors.verticalCenter: parent.verticalCenter
            opacity: homeIcon.pressed ? 0.5 : 1.0
            MouseArea {
                id: homeIcon
                width: parent.width + 20
                height: parent.height + 20
                anchors.centerIn: parent
                onClicked: {
                    toolBar.showBack = false;
                    toolbar.homeClicked();
                }
            }
            visible: toolbar.showBack
        }*/

        Image {
            id: statusButtonEx
            source: "../pics/spechbubble_sq.png"
            x: menuButtonEx.x - width - 20  //parent.width - width - 10
            anchors.verticalCenter: parent.verticalCenter
            opacity: statusIcon.pressed ? 0.5 : 1.0
            MouseArea {
                id: statusIcon
                width: parent.width + 20
                height: parent.height + 20
                anchors.centerIn: parent
                onClicked: {
                    toolBar.shareStatusClicked();
                }
            }
        }

        Image {
            id: menuButtonEx
            source: "../pics/align_just.png" // "../pics/delete.png"
            //visible: !toolbar.showBack
            x: parent.width - width - 10
            anchors.verticalCenter: parent.verticalCenter
            opacity: quitIcon.pressed ? 0.5 : 1.0
            MouseArea {
                id: quitIcon
                width: parent.width + 20
                height: parent.height + 20
                anchors.centerIn: parent
                onClicked: {
                    toolbar.menuClicked();
                    //Qt.quit();
                }
            }
        }

        Image {
            source: "../pics/minimize.png"
            x: 10
            anchors.verticalCenter: parent.verticalCenter
            visible: toolbar.showMinimize
            MouseArea {
                id: minimizeIcon
                width: parent.width + 20
                height: parent.height + 20
                anchors.centerIn: parent
                onClicked: {
                    toolbar.minimizeClicked();
                }
            }
        }
    }

    Image {
        source: "../pics/top-shadow.png"
        width: parent.width
        x:0
        y:50-1
    }

}
