import Qt 4.7

Item {
    id: homeList
    signal clicked(int index)
    signal loadMore()
    signal refresh()
    property ListModel homeModel
    clip: true

    Component.onCompleted: {
        loadMoreTimer.start();
    }

    MouseArea {
        anchors.fill: parent
        onClicked: { }
    }

    Timer {
        id: loadMoreTimer
        interval: 555
        repeat: true
        onTriggered: {
            if(feedList.atYEnd) {
                if(homeList.homeModel.count>0) {
                    var last = homeList.homeModel.get(homeList.homeModel.count-1);
                    if(last.message.indexOf("Load more...")>=0) {
                        console.log("Triggered load more...");
                        last.message = "Please wait...";
                        homeList.loadMore();
                    }
                }
            }
            if(feedList.atYBeginning) {
                if(!pullLabel.visible && feedList.contentY<-5) {
                    pullLabel.visible = true;
                } else if(pullLabel.visible && feedList.contentY>=0) {
                    pullLabel.text = "Pull down to refresh";
                    pullLabel.visible = false;
                }
                if(feedList.contentY<-50) {
                    pullLabel.text = "Release to refresh";
                }
            }
        }
    }

    Rectangle {
        id: pullText
        width: window.width
        height: 0

        Text {
            id: pullLabel
            text: "Pull down to refresh"
            visible: false
            width: window.width
            //anchors.top: window.top
            font.pixelSize: 20
            anchors.horizontalCenter: parent.horizontalCenter
            horizontalAlignment: Text.AlignHCenter
            color: theme.textColor
        }
    }


    ListView {
        id: feedList
        model: homeList.homeModel
        anchors.fill: parent
        delegate: homeListDelegate
        highlightFollowsCurrentItem: true
        onMovingChanged: {
            if(feedList.atYBeginning && pullLabel.text=="Release to refresh") {
                // Refresh
                pullLabel.text = "Pull to refresh";
                pullLabel.visible = false;
                homeList.refresh();
            }
        }
    }

    Component {
        id: homeListDelegate

        Item {
            id: homeItem
            width: parent.width
            height: message=="Load more..." ? 120 : titleContainer.height

            Rectangle {
                id: titleContainer
                color: mouseArea.pressed ? "#ddd" : "#fff"
                y: 1
                width: parent.width
                height: statusTextArea.height + 16 < 58 ? 58 : statusTextArea.height + 16

                Image {
                    x: 4
                    y: 4
                    id: profileImage
                    source: profileImageUrl
                }

                Column {
                    id: statusTextArea
                    spacing: 4
                    x: 62 // profileImage.width + 12
                    y: 4
                    width: parent.width - 62

                    /*Text {
                        id: fromNameText
                        color: "#444"
                        font.pixelSize: 16
                        width: parent.width
                        text: fromName
                        wrapMode: Text.WrapAnywhere
                    }*/

                    Text {
                        id: messageText
                        color: "#111"
                        font.pixelSize: 18
                        width: parent.width
                        text: "<span style='color:#3B5998'><b>" + fromName + toName + "</b></span>&nbsp;<span>" + message + "</span>"
                        wrapMode: Text.Wrap
                    }

                    Row {
                        width: parent.width - 10
                        spacing: 10

                        /*
                        Image {
                            id: picImage
                            source: picture
                            visible: picture.length > 0
                        }*/

                        Column {
                            width: parent.width - 10
/*
                            Text {
                                id: nameText
                                color: "#3B5998"
                                font.pixelSize: 16
                                width: parent.width
                                text: "<span>" + name + "</span>"
                                font.bold: true
                                wrapMode: Text.Wrap
                                visible: name.length>0
                            }

                            Text {
                                id: captionText
                                color: "#777"
                                font.pixelSize: 14
                                width: parent.width
                                text: "<span>" + caption + "</span>"
                                wrapMode: Text.Wrap
                                visible: caption.length>0
                            }*/
                            Text {
                                id: descriptionText
                                color: "#555"
                                font.pixelSize: 18
                                width: parent.width
                                text: "<span>" + description + "</span>"
                                wrapMode: Text.Wrap
                                visible: description.length>0
                            }
                        }

                    }

                    Row {
                        spacing: 8
                        width: parent.width
                        height: 16

                        Image {
                            id: pictureImage
                            source: icon
                            visible: icon.length > 0
                            anchors.verticalCenter: parent.verticalCenter
                        }

                        Text {
                            id: createdTimeText
                            color: "#aaa"
                            font.pixelSize: 16
                            text: "<span>" + created_time + "</span>"
                            wrapMode: Text.Wrap
                            anchors.verticalCenter: parent.verticalCenter
                        }

                        Item {
                            visible: likes>0
                            width: 40
                            height: 16
                            anchors.verticalCenter: parent.verticalCenter
                            Image {
                                source: "../pics/hand_pro.png"
                                anchors.verticalCenter: parent.verticalCenter
                            }
                            Text {
                                x: 18
                                color: "#3B5998"
                                text: likes
                                font.pixelSize: 16
                                anchors.verticalCenter: parent.verticalCenter
                            }
                        }

                        Item {
                            visible: comments>0
                            width: 40
                            height: 16
                            anchors.verticalCenter: parent.verticalCenter
                            Image {
                                source: "../pics/spechbubble.png"
                                anchors.verticalCenter: parent.verticalCenter
                            }
                            Text {
                                x: 18
                                color: "#3B5998"
                                text: comments
                                font.pixelSize: 16
                                anchors.verticalCenter: parent.verticalCenter
                            }
                        }
                    }
                }

            }

            Rectangle {
                width:  parent.width
                x: 4
                y: homeItem.height - 1
                height: 1
                color: "#ddd"
            }

            MouseArea {
                id: mouseArea
                anchors.fill: parent
                onClicked: {
                    homeList.clicked( index );
                }
            }

        }
    }

    states: [
        State {
            name: "hidden"
            PropertyChanges {
                target: homeList
                x: parent.width
            }
        },
        State {
            name: "hiddenLeft"
            PropertyChanges {
                target: homeList
                x: parent.width
            }
        },
        State {
            name: "shown"
            PropertyChanges {
                target: homeList
                x: 0
            }
        }
    ]

    transitions: [
        Transition {
            SequentialAnimation {
                PropertyAnimation {
                    target: homeList
                    properties: "x"
                    duration: 300
                    easing.type: "InOutQuad"
                }
            }
        }
    ]
}
