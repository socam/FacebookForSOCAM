import Qt 4.7

Item {
    id: commentDialogItem
    signal clicked(string text, string url)
    width: parent.width; height: statusDialog.height // 150
    state: "hidden"
    property string statusText: ""
    property string url: ""
    property string name: ""

    CustomTheme {
        id: theme
    }

    function clear() {
        tweetText.text = "";
    }

    Rectangle {
        id: statusDialog
        width: parent.width
        y: 0
        height: statusButtonExContainer.y + statusButtonExContainer.height + 20

        color: theme.dialogBG

        Text {
            id: statusLabel
            text: "Write a comment to " + commentDialogItem.name
            font.pixelSize: 20
            color: "#222"
            width: parent.width - 20
            wrapMode: Text.Wrap
            y: 10
            x: 10
        }

        CustomTextEdit {
            id: tweetText
            text: commentDialogItem.statusText
            height: 110
            width: parent.width-20
            x: 10
            y: statusLabel.y + statusLabel.height + 10
        }

        Rectangle {
            id: statusButtonExContainer
            radius: 5
            color: theme.dialogButtonExAreaBG // "#999"
            x: 10
            width: parent.width - 20
            height: 70
            y: tweetText.y + tweetText.height + 20

            Row {
                id: buttonRow
                x: 10
                width: parent.width - 10
                height: 50
                spacing: 10
                y: 10

                ButtonEx {
                    id: tweetButtonEx
                    label: "Comment"
                    width: (parent.width / 3) * 2 - 10
                    height: 50
                    onClicked: {
                        commentDialogItem.clicked(tweetText.getText(), commentDialogItem.url);
                        tweetText.closeSoftwareInputPanel();
                        commentDialogItem.state = "hidden";
                    }
                }

                ButtonEx {
                    id: cancelButtonEx
                    label: "Cancel"
                    width: parent.width / 3 - 10
                    height: 50
                    onClicked: {
                        tweetText.closeSoftwareInputPanel();
                        commentDialogItem.statusText = "";
                        commentDialogItem.state = "hidden"
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
    }

    states: [
        State {
            name: "hidden"
            PropertyChanges {
                target: statusDialog
                y: commentDialogItem.parent.height + 20
            }
        },
        State {
            name: "shown"
            changes: [
                PropertyChanges {
                    target: statusDialog
                    y: commentDialogItem.parent.height - commentDialogItem.height
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
            to: "hidden"
            SequentialAnimation {
                PropertyAnimation {
                    target: statusDialog
                    properties: "y"
                    duration: 300
                    easing.type: "InOutQuad"
                }
            }
        },
        Transition {
            to: "shown"
            SequentialAnimation {
                PropertyAnimation {
                    target: statusDialog
                    properties: "y"
                    duration: 300
                    easing.type: "InOutQuad"
                }
            }
        }
    ]

}
