import Qt 4.7

Rectangle {
    id: places
    width: parent.width
    height: parent.height
    property bool showSignal: true
    signal showRecentPlaces()
    signal showNearbyPlaces()
    signal checkinClicked(int index)
    signal placeClicked(int index)
    signal loadPlaces(string filter)

    MouseArea {
        anchors.fill: parent
        onClicked: { }
    }

    CheckinsList {
        id: checkinsList
        width: parent.width
        y: menubar.height
        height: parent.height - menubar.height
        visible: true
        state: "shown"
        onClicked: {
            places.checkinClicked(index);
        }
    }

    PlacesList {
        id: placesList
        width: parent.width
        y: menubar.height
        height: parent.height - menubar.height
        visible: true
        state: "hidden"
        onClicked: {
            places.placeClicked(index);
        }
        onSearch: {
            places.loadPlaces(filter);
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
                checkinsList.state = "shown";
                placesList.state = "hidden";
            }
            label: "Recent"
        }

        TitleButtonEx {
            width: parent.width/2 - 10
            x: parent.width/2 + 5
            y: 5
            height: 40
            buttonOpacity: 0.6
            onClicked: {
                places.loadPlaces("");
                checkinsList.state = "hidden";
                placesList.state = "shown";
            }
            label: "Nearby"
        }
    }

    Image {
        source: "../pics/top-shadow.png"
        width: parent.width
        x:0
        y:menubar.y + menubar.height - 1
    }

    Rectangle {
        id: signalIcon
        radius: 6
        color: "#d66"
        width: 32
        height: 32
        x: parent.width - 40
        y: parent.height - 40
        visible: places.showSignal
        Image {
            anchors.centerIn: parent
            source: "../pics/sat_dish.png"
        }
    }

    states: [
        State {
            name: "hidden"
            PropertyChanges {
                target: places
                x: parent.width
            }
        },
        State {
            name: "shown"
            PropertyChanges {
                target: places
                x: 0
            }
        }
    ]

    transitions: [
        Transition {
            SequentialAnimation {
                PropertyAnimation {
                    target: places
                    properties: "x"
                    duration: 300
                    easing.type: "InOutQuad"
                }
            }
        }
    ]
}
