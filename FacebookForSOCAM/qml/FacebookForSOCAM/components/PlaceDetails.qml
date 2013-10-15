import Qt 4.7

Rectangle {
    id: place
    signal back()
    signal checkin(string pid, string comment, string friendIDs)
    width: parent.width
    color: "#fff"
    property string name: ""
    property string street: ""
    property string category: ""
    property string placeID: ""
    property string friendIDs: ""

    function reset() {
        place.friendIDs = "";
        checkinFriendNames.text = "";
    }

    MouseArea {
        anchors.fill: parent
        onClicked: { }
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
            width: parent.width - 10
            height: 40
            buttonOpacity: 0.6
            x: 5
            y: 5
            onClicked: {
                place.back();
            }
            label: "Back to places"
        }

    }

    Column {
        id: statusTextArea
        spacing: 4
        x: 4 // profileImage.width + 12
        y: menubar.y + menubar.height + 4
        width: parent.width - 8

        Text {
            color: "#111"
            font.pixelSize: 18
            width: parent.width
            text: "<span style='color:#3B5998'><b>" + place.name + "</b></span>"
            wrapMode: Text.Wrap
        }

        Text {
            color: "#111"
            font.pixelSize: 16
            width: parent.width
            text: place.category
            wrapMode: Text.Wrap
        }

        Text {
            color: "#111"
            font.pixelSize: 16
            width: parent.width
            text: place.street
            wrapMode: Text.Wrap
        }

        CustomTextEdit {
            id: checkinText
            //wrapMode: TextEdit.Wrap
            text: "Your message..."
            //textFormat: TextEdit.PlainText
            height: 76
            width: parent.width
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    if(checkinText.getText()=="Your message...") {
                        checkinText.text = "";
                        checkinText.focus = true;
                    }
                    checkinText.forceActiveFocus();
                    checkinText.openSoftwareInputPanel();
                }
            }
        }

        Row {
            width: parent.width
            height: 40
            spacing: 10

            ButtonEx {
                width: parent.width/2 - 5
                height: 40
                label: "I'm with..."
                onClicked: {
                    if(friendsModel.count==0) {
                        window.loadFriends();
                    }
                    checkinFriendList.state = "shown";
                }
            }

            TitleButtonEx {
                width: parent.width/2 - 5
                height: 40
                buttonOpacity: 0.6
                onClicked: {
                    var comment = checkinText.text;
                    if(comment == "Your message...") {
                        comment = "";
                    }
                    place.checkin(place.placeID, comment, place.friendIDs);
                }
                label: "CHECKIN"
            }

        }

        Text {
            id: checkinFriendNames
            color: "#111"
            font.pixelSize: 16
            width: parent.width
            text: ""
            wrapMode: Text.Wrap
        }
    }

    Image {
        source: "../pics/top-shadow.png"
        width: parent.width
        x:0
        y:menubar.y + menubar.height - 1
    }

    FriendsList {
        id: checkinFriendList
        width: parent.width
        height: parent.height
        state: "hidden"
        onClicked: {
            // Add user to checkin list
            var friend = friendsModel.get(index);
            if(checkinFriendNames.text.length==0) {
                checkinFriendNames.text = "with ";
            } else {
                checkinFriendNames.text += ", ";
            }
            checkinFriendNames.text += friend.name + " ";
            if(place.friendIDs.length>0) {
                place.friendIDs += ",";
            }
            place.friendIDs += friend.id;
            checkinFriendList.state = "hidden";
        }
    }

    states: [
        State {
            name: "hidden"
            PropertyChanges {
                target: place
                x: parent.width
            }
        },
        State {
            name: "hiddenLeft"
            PropertyChanges {
                target: place
                x: -parent.width
            }
        },
        State {
            name: "shown"
            PropertyChanges {
                target: place
                x: 0
            }
        }
    ]

    transitions: [
        Transition {
            SequentialAnimation {
                PropertyAnimation {
                    target: place
                    properties: "x"
                    duration: 300
                    easing.type: "InOutQuad"
                }
            }
        }
    ]
}
