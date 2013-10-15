import Qt 4.7

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
    color: "#667"
    width: 280
    height: 280
    radius: 5
    smooth: true
    border.color: "#445"
    border.width: 1

    Column {
        width: parent.width
        spacing: 16
        y: 20

        Row {
            //x: 10
            anchors.horizontalCenter: parent.horizontalCenter
            //width: parent.width - 20
            spacing: 16
            height:64

            MenuIcon {
                source: "../pics/group.png"
                label: "Friends"
                onClicked: {
                    menu.friendsClicked();
                    menu.state = "hidden";
                }
            }

            MenuIcon {
                source: "../pics/contacts.png"
                label: "Wall"
                onClicked: {
                    menu.wallClicked();
                    menu.state = "hidden";
                }
            }

            MenuIcon {
                source: "../pics/photos.png"
                label: "Photos"
                onClicked: {
                    menu.photosClicked();
                    menu.state = "hidden";
                }
            }
        }

        Row {
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 16
            height:64

            MenuIcon {
                source: "../pics/home_menu.png"
                label: "Home"
                onClicked: {
                    menu.homeClicked();
                    menu.state = "hidden";
                }
            }
/*
            MenuIcon {
                source: "../pics/08-chat@2x.png"
                label: "Share status"
                onClicked: {
                    menu.shareStatusClicked();
                    menu.state = "hidden";
                }
            }
/*
            MenuIcon {
                source: "../pics/18-envelope@2x.png"
                label: "Messages"
                onClicked: {
                    menu.messagesClicked();
                    menu.state = "hidden";
                }
            }
*/
            MenuIcon {
                source: "../pics/calendar_view_today.png"
                label: "Events"
                onClicked: {
                    menu.eventsClicked();
                    menu.state = "hidden";
                }
            }

            MenuIcon {
                source: "../pics/location_mark.png"
                label: "Places"
                onClicked: {
                    menu.placesClicked();
                    menu.state = "hidden";
                }
            }
        }

        Row {
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 16
            height:64

            MenuIcon {
                source: "../pics/accounts.png"
                label: "Logout"
                onClicked: {
                    menu.logoutClicked();
                    menu.state = "hidden";
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


}
