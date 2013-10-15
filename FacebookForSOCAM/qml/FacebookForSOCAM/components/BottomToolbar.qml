import QtQuick 1.0

Rectangle {
    id: menu
    signal homeClicked()
    signal friendsClicked()
    signal wallClicked()
    signal shareStatusClicked()
    signal messagesClicked()
    signal eventsClicked()
    signal photosClicked()
    signal placesClicked()
    signal logoutClicked()
    //color: "#667"
    gradient: Gradient {
        //GradientStop { position: 0.0; color: "#F2F2F2" }
        GradientStop { position: 0.08; color: "#6079AB" }
        GradientStop { position: 0.25; color: "#3B5998" }
        GradientStop { position: 0.5; color: "#29447E" } // "#1a1a1a"
    }
    width: parent.width
    height: 280
    y: parent.height - 80
    //radius: 5
    //smooth: true
    border.color: "#445"
    border.width: 1
    state: "minimized"

    Column {
        width: parent.width
        spacing: 8
        y: 0

        Row {
            //x: 10
            anchors.horizontalCenter: parent.horizontalCenter
            //width: parent.width - 20
            spacing: (window.width-350) / 6 // 6
            height:64

            MenuIcon {
                source: "../pics/home_menu.png"
                label: "Home"
                onClicked: {
                    menu.homeClicked();
                    menu.state = "minimized";
                }
            }

            MenuIcon {
                source: "../pics/group.png"
                label: "Friends"
                onClicked: {
                    menu.friendsClicked();
                    menu.state = "minimized";
                }
            }

            MenuIcon {
                source: "../pics/contacts.png"
                label: "Wall"
                onClicked: {
                    menu.wallClicked();
                    menu.state = "minimized";
                }
            }


            MenuIcon {
                source: "../pics/instant_messenger_chat.png"
                label: "Status"
                onClicked: {
                    menu.shareStatusClicked();
                    menu.state = "minimized";
                }
            }

            MenuIcon {
                source: "../pics/options.png"
                label: menu.state=="minimized" ? "More" : "Less"
                onClicked: {
                    //menu.shareStatusClicked();
                    if(menu.state!="shown") {
                        menu.state = "shown";
                    } else {
                        menu.state = "minimized";
                    }
                }
            }
        }

        Row {
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: (window.width-350) / 6 //6
            height:64

            MenuIcon {
                source: "../pics/photos.png"
                label: "Photos"
                onClicked: {
                    menu.photosClicked();
                    menu.state = "minimized";
                }
            }

            MenuIcon {
                source: "../pics/calendar_view_today.png"
                label: "Events"
                onClicked: {
                    menu.eventsClicked();
                    menu.state = "minimized";
                }
            }

            MenuIcon {
                source: "../pics/location_mark.png"
                label: "Places"
                onClicked: {
                    menu.placesClicked();
                    menu.state = "minimized";
                }
            }

            MenuIcon {
                source: "../pics/accounts.png"
                label: "Logout"
                onClicked: {
                    menu.logoutClicked();
                    menu.state = "minimized";
                }
            }

            MenuIcon {
                source: "../pics/close_stop.png"
                label: "Exit"
                onClicked: {
                    Qt.quit();
                }
            }

        }
    }

    Image {
        source: "../pics/bottom-shadow.png"
        y: -16
        height: 16
        anchors.right: parent.right
        anchors.rightMargin: 0
        anchors.left: parent.left
        anchors.leftMargin: 0
    }

    states: [
        State {
            name: "minimized"
            PropertyChanges {
                target: menu
                y: parent.height - 80
            }
        },
        State {
            name: "shown"
            PropertyChanges {
                target: menu
                y: parent.height - 160
            }
        }
    ]

    transitions: [
        Transition {
            SequentialAnimation {
                PropertyAnimation {
                    target: menu
                    properties: "y"
                    duration: 200
                    easing.type: "InOutCubic"
                }
                PropertyAnimation {
                    target: menu
                    properties: "y"
                    duration: 2000
                }
            }
        }
    ]

}
