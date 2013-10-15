import Qt 4.7

Rectangle {
    id: photoDetails
    width: parent.width
    height: parent.height
    property ListModel photoDiscussionModel
    property string photo_id
    property string link
    property string photo_url
    property string title
    property bool showBackToAlbum: true
    property bool showBackToStatus: false
    state: "hidden"
    signal like(string index)
    signal comment(string index)
    signal showNext()
    signal goBack()

    MouseArea {
        anchors.fill: parent
        onClicked: { }
    }

    Flickable {
        anchors.fill: parent
        contentWidth: parent.width
        contentHeight: basic.height + 100

        Column {
            id: basic
            width: parent.width - 20
            x: 10
            y: 10
            spacing: 10

            ButtonEx {
                id: backToAlbumButtonEx
                visible: photoDetails.showBackToAlbum || photoDetails.showBackToStatus
                width: parent.width
                label: "Back"
                onClicked: {
                    photoDetails.state = "hidden";
                    photoDetails.showBackToAlbum = false;
                    photoDetails.showBackToStatus = false;
                }
            }

            Image {
                width: parent.width
                smooth: true
                source: photoDetails.photo_url
                fillMode: Image.PreserveAspectFit

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        photoDetails.showNext();
                    }
                }
            }

            Row {
                width: parent.width - 10
                spacing: 10

                Column {
                    width: parent.width - 10

                    Text {
                        id: descriptionText
                        color: "#555"
                        font.pixelSize: 16
                        width: parent.width
                        text: photoDetails.title
                        wrapMode: Text.Wrap
                        visible: text.length>0
                    }
                }

            }

            ButtonEx {
                width: parent.width
                height: 50
                label: "Open in Browser"
                visible: photoDetails.link.length>0
                onClicked: {
                    console.log("opening");
                    Qt.openUrlExternally(photoDetails.link);
                }
            }

            Row {
                spacing: 10
                width: parent.width
                height: 50

                ButtonEx {
                    width: parent.width/2 -5
                    height: 50
                    label: "Like"
                    onClicked: {
                        console.log("Liking");
                        photoDetails.like( photoDetails.photo_id );
                    }
                }

                ButtonEx {
                    width: parent.width/2 -5
                    height: 50
                    label: "Comment"
                    onClicked: {
                        photoDetails.comment( photoDetails.photo_id );
                    }
                }
            }

            Column {
                id: discussion
                width: parent.width
                Repeater{
                    model: photoDiscussionModel
                    width: parent.width
                    delegate: commentDelegate
                }
            }
        }
    }
/*
    BackButtonEx {
        onClicked: {
            photoDetails.goBack();
            photoDetails.state = "hidden";
        }
    }
*/
    Component {
        id: commentDelegate

        Item {
            id: homeItem
            width: basic.width
            height: titleContainer.height + 4
            state: "shown"

            Rectangle {
                id: titleContainer
                color: mouseArea.pressed ? "#ddd" : "#fff"
                y: 1
                width: parent.width
                height: statusTextArea.height + 8 < 58 ? 58 : statusTextArea.height + 8

                Image {
                    x: 4
                    y: 4
                    id: profile
                    source: profileImage
                }

                Column {
                    id: statusTextArea
                    spacing: 4
                    x: 62 // profileImage.width + 12
                    y: 4
                    width: parent.width - 62

                    Text {
                        id: fromNameText
                        color: "#3B5998"
                        font.pixelSize: 16
                        width: parent.width
                        text: fromName
                        wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                    }

                    Text {
                        id: messageText
                        color: "#111"
                        font.pixelSize: 18
                        width: parent.width
                        text: "<span>" + message + "</span>"
                        wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                    }
                }
            }

            Rectangle {
                width:  parent.width
                x: 4
                y: homeItem.height - 2
                height: 1
                color: "#ccc"
            }

            MouseArea {
                id: mouseArea
                anchors.fill: parent
                onClicked: {
                    //homeList.clicked( index );
                }
            }

            states: [
                State {
                    name: "hidden"
                    PropertyChanges {
                        target: titleContainer
                        x: -parent.width
                    }
                },
                State {
                    name: "shown"
                    PropertyChanges {
                        target: titleContainer
                        x: 0
                    }
                }
            ]
        }

    }

    states: [
        State {
            name: "hidden"
            PropertyChanges {
                target: photoDetails
                x: parent.width
            }
        },
        State {
            name: "shown"
            PropertyChanges {
                target: photoDetails
                x: 0
            }
        }
    ]

    transitions: [
        Transition {
            SequentialAnimation {
                PropertyAnimation {
                    target: photoDetails
                    properties: "x"
                    duration: 300
                    easing.type: "InOutQuad"
                }
            }
        }
    ]
}
