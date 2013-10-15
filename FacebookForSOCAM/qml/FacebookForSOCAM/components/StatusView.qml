import Qt 4.7

Rectangle {
    id: statusDetails
    width: parent.width
    height: parent.height
    property ListModel model
    property ListModel discussionModel
    property int index
    property string status_id
    property string link
    property string photo_id
    property string user_id
    property string user_name
    state: "hidden"
    signal like(string status_id)
    signal comment(string status_id)
    signal likeComment(string comment_id)
    signal goBack()
    signal openWall(string user_id)
    signal openPhoto(string photo_id)
    signal share(string link)

    MouseArea {
        anchors.fill: parent
        onClicked: { }
    }

    function fill(index) {
        discussionModel.clear();
        statusDetails.index = index;
        var status = model.get(index);
        profileImage.source = status.profileImageUrl;
        statusDetails.status_id = status.status_id;
        statusDetails.user_id = status.fromID;
        statusDetails.user_name = status.fromName;
        userText.text = "<span>" + status.fromName + status.toName + "</span>";
        messageText.text = status.message;
        descriptionText.text = status.description;
        createdTimeText.text = status.created_time;
        statusDetails.link = status.link;
        likedByText.text = status.likedBy;
        if(status.type=="photo") {
            photo_id = status.object_id;
        } else {
            photo_id = "";
        }
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

            Row {
                id: profileRow
                width: parent.width
                spacing: 10

                Image {
                    id: profileImage
                    source: ""
                }

                Column {
                    width: parent.width - 160

                    Text {
                        id: userText
                        color: "#3B5998"
                        font.pixelSize: 16
                        width: parent.width
                        text: ""
                        wrapMode: Text.Wrap
                    }

                    Text {
                        id: createdTimeText
                        color: "#aaa"
                        font.pixelSize: 16
                        width: parent.width
                        text: ""
                        wrapMode: Text.Wrap
                    }
                }

                Column {
                    width: 90
                    spacing: 5

                    ButtonEx {
                        label: "Back"
                        width: 90
                        height: 45
                        onClicked: {
                            statusDetails.goBack();
                            statusDetails.state = "hidden";
                        }
                    }

                    ButtonEx {
                        width: 90
                        height: 45
                        label: "Wall"
                        onClicked: {
                            statusDetails.openWall( statusDetails.user_id );
                        }
                    }
                }

            }

            Text {
                id: messageText
                color: "#111"
                font.pixelSize: 18
                width: parent.width
                text: ""
                wrapMode: Text.Wrap
            }

            Row {
                width: parent.width - 10
                spacing: 10

                Column {
                    width: parent.width - 10

                    Text {
                        id: descriptionText
                        color: "#555"
                        font.pixelSize: 18
                        width: parent.width
                        text: ""
                        wrapMode: Text.Wrap
                        visible: text.length>0
                    }

                }

            }

            ButtonEx {
                width: parent.width
                height: 50
                label: "Open in Browser"
                visible: statusDetails.link.length>0
                onClicked: {
                    console.log("opening");
                    Qt.openUrlExternally(statusDetails.link);
                }
            }

            ButtonEx {
                width: parent.width
                height: 50
                label: "View photo"
                visible: statusDetails.photo_id.length>0
                onClicked: {
                    statusDetails.openPhoto(statusDetails.photo_id);
                }
            }

            ButtonEx {
                width: parent.width
                height: 50
                label: "Share"
                visible: statusDetails.link.length>0
                onClicked: {
                    statusDetails.share(statusDetails.link);
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
                        statusDetails.like( statusDetails.status_id );
                    }
                }

                ButtonEx {
                    width: parent.width/2 -5
                    height: 50
                    label: "Comment"
                    onClicked: {
                        statusDetails.comment( statusDetails.status_id );
                    }
                }
            }

            Text {
                id: likedByText
                color: "#667"
                font.pixelSize: 16
                width: parent.width
                text: ""
                wrapMode: Text.Wrap
            }

            Column {
                id: discussion
                width: parent.width
                Repeater{
                    model: statusDetails.discussionModel
                    width: parent.width
                    //height: discussionModel.count * 150
                    delegate: commentDelegate
                }
            }

        }

    }

    Component {
        id: commentDelegate

        Item {
            id: homeItem
            width: basic.width
            height: titleContainer.height + 4
            state: "shown"

            ButtonEx {
                label: "Like"
                onClicked: {
                    statusDetails.likeComment(comment_id);
                    homeItem.state = "shown";
                }
                y: 4
                x: parent.width / 2 - 105
                width: 100
            }

            ButtonEx {
                label: "Cancel"
                onClicked: homeItem.state = "shown"
                y: 4
                x: parent.width / 2 + 5
                width: 100
            }

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

                MouseArea {
                    id: mouseArea
                    anchors.fill: parent
                    onClicked: {
                        homeItem.state = "hidden";
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



            states: [
                State {
                    name: "hidden"
                    PropertyChanges {
                        target: titleContainer
                        x: -parent.width - 20
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

            transitions: [
                Transition {
                    SequentialAnimation {
                        PropertyAnimation {
                            target: titleContainer
                            properties: "x"
                            duration: 250
                            easing.type: "InOutQuad"
                        }
                    }
                }
            ]


        }

    }

    states: [
        State {
            name: "hidden"
            PropertyChanges {
                target: statusDetails
                x: parent.width
            }
        },
        State {
            name: "shown"
            PropertyChanges {
                target: statusDetails
                x: 0
            }
        }
    ]

    transitions: [
        Transition {
            SequentialAnimation {
                PropertyAnimation {
                    target: statusDetails
                    properties: "x"
                    duration: 300
                    easing.type: "InOutQuad"
                }
            }
        }
    ]
}
