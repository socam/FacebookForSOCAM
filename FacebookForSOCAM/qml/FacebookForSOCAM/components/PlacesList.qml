import Qt 4.7

Rectangle {
    id: placesList
    signal clicked(int index)
    signal search(string filter)
    width: parent.width
    color: "#fff"

    MouseArea {
        anchors.fill: parent
        onClicked: { }
    }

    ListView {
        model: placesModel
        y: 80
        width: parent.width
        height: parent.height - y
        delegate: placesListDelegate
        highlightFollowsCurrentItem: true
    }

    Rectangle {
        width: parent.width
        height: 60

        CustomTextInput {
            id: filterText
            text: "Search..."
            x: 10
            y: 10
            height: 40
            width: parent.width - 130
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    if(filterText.text=="Search...") {
                        filterText.text = "";
                        filterText.focus = true;
                    }
                    filterText.forceActiveFocus();
                    filterText.openSoftwareInputPanel();
                }
            }
//            onAccepted: {
//                var query = filterText.text;
//                if(query=="Search...") {
//                    query = "";
//                }
//                placesList.search(query);
//            }
        }


        ButtonEx {
            x: parent.width - 110
            y: 10
            width: 100
            height: 40
            label: "Search"
            onClicked: {
                var filter = filterText.text;
                if(filter=="Search...") {
                    filter = "";
                }
                placesList.search(filter);
            }
        }
    }

    Image {
        source: "../pics/top-shadow.png"
        width: parent.width
        x: 0
        y: 60
    }

    Component {
        id: placesListDelegate

        Item {
            id: placeItem
            width: parent.width
            height: titleContainer.height + 2

            Rectangle {
                id: titleContainer
                color: mouseArea.pressed ? "#ddd" : "#fff"
                y: 1
                width: parent.width
                height: statusTextArea.height + 8

                /*
                Image {
                    x: 4
                    y: 2
                    id: profileImage
                    source: profileImageUrl
                }*/

                Column {
                    id: statusTextArea
                    spacing: 4
                    x: 4 // profileImage.width + 12
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
                    /*
                    Text {
                        color: "#111"
                        font.pixelSize: 16
                        width: parent.width
                        text: category
                        wrapMode: Text.Wrap
                    }*/
                    Text {
                        color: "#111"
                        font.pixelSize: 16
                        width: parent.width
                        text: street
                        wrapMode: Text.Wrap
                    }
                }
            }

            Rectangle {
                width:  parent.width
                x: 4
                y: placeItem.height - 1
                height: 1
                color: "#ddd"
            }

            MouseArea {
                id: mouseArea
                anchors.fill: parent
                onClicked: {
                    placesList.clicked( index );
                }
            }

        }
    }

    states: [
        State {
            name: "hidden"
            PropertyChanges {
                target: placesList
                x: parent.width
            }
        },
        State {
            name: "hiddenLeft"
            PropertyChanges {
                target: placesList
                x: -parent.width
            }
        },
        State {
            name: "shown"
            PropertyChanges {
                target: placesList
                x: 0
            }
        }
    ]

    transitions: [
        Transition {
            SequentialAnimation {
                PropertyAnimation {
                    target: placesList
                    properties: "x"
                    duration: 300
                    easing.type: "InOutQuad"
                }
            }
        }
    ]
}
