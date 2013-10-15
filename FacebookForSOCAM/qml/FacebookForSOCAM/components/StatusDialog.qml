import Qt 4.7

Item {
    id: statusDialogItem
    signal clicked(string text, string link)
    width: parent.width; height: 150
    state: "hidden"
    property string statusText: ""
    property string linkTxt: ""

    CustomTheme {
        id: theme
    }

    function reset() {
        statusDialogItem.statusText = "What's on your mind?";
        statusDialogItem.linkTxt = "";
    }

    Rectangle {
        id: statusDialog
        width: parent.width
        y: 0
        height: statusButtonExContainer.y + statusButtonExContainer.height + 20
	
        color: theme.dialogBG
/*
        Text {
            id: statusLabel
            text: "Share status"
            font.pixelSize: 20
            color: "#222"
            y: 10
            x: 10
        }*/

        CustomTextEdit {
            id: tweetText
            text: statusDialogItem.statusText
            height: 110
            width: parent.width-20
            placeholderText: "What's on your mind?"
            x: 10
            y: 10
        }

        Text {
            id: linkLabel
            text: "Link"
            font.pixelSize: 20
            color: "#222"
            y: linkText.y
            x: 10
        }

        CustomTextInput {
            id: linkText
            placeholderText: "Link? http://..."
            text: statusDialogItem.linkTxt
            x: 50
            y: tweetText.y + tweetText.height + 10
            width: parent.width - 60
        }

        Rectangle {
            id: statusButtonExContainer
            radius: 5
            color: theme.dialogButtonExAreaBG // "#999"
            x: 10
            width: parent.width - 20
            height: 70
            y: linkText.y + linkText.height + 20

            Row {
                id: buttonRow
                x: 10
                width: parent.width - 10
                height: 50
                spacing: 10
                y: 10

                ButtonEx {
                    id: tweetButtonEx
                    label: "Share"
                    width: (parent.width / 3) * 2 - 10
                    height: 50
                    onClicked: {
                        statusDialogItem.clicked(tweetText.getText(), linkText.getText());
                        tweetText.closeSoftwareInputPanel();
                        statusDialogItem.state = "hidden";
                    }
                }

                ButtonEx {
                    id: cancelButtonEx
                    label: "Cancel"
                    width: parent.width / 3 - 10
                    height: 50
                    onClicked: {
                        tweetText.closeSoftwareInputPanel();
                        statusDialogItem.statusText = "";
                        statusDialogItem.linkTxt = "";
                        statusDialogItem.state = "hidden"
                    }
                }
            }
        }

	
        Image {
            source: "../pics/top-shadow.png"
            y: parent.height
            height: 16
            anchors.right: parent.right
            anchors.rightMargin: 0
            anchors.left: parent.left
            anchors.leftMargin: 0
        }
    }

    states: [
        State {
            name: "hidden"
            PropertyChanges {
                target: statusDialog
                y: 0 - statusDialog.height - 16
            }
        },
        State {
            name: "shown"
            changes: [
                PropertyChanges {
                    target: statusDialog
                    y: 0 // 50
                },
                PropertyChanges {
                    target: statusDialog
                    visible: true
                }
            ]
        }
    ]

    transitions: [
        Transition {
            SequentialAnimation {
                PropertyAnimation {
                    target: statusDialog
                    properties: "y"
                    duration: 400
                    easing.type: "InQuad"
                }
            }
        }
    ]

}
