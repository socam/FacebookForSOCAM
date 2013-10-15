import Qt 4.7

Item {
    id: settingsDialogItem
    signal clicked()
    width: parent.width; height: settingsColumn.height
    state: "hidden"
    property bool useList: false
    property string autoRefresh: "5"

    CustomTheme {
        id: theme
    }

    Rectangle {
        id: settingsDialog
        width: parent.width
        y: 0
        height: settingsButtonExContainer.y + settingsButtonExContainer.height + 30
        color: theme.dialogBG

        MouseArea {
            anchors.fill: parent
            onClicked: {
                console.log("Preventing click leaking to underneath");
            }
        }

        Text {
            text: "Auto-refresh"
            wrapMode: Text.Wrap
            font.pixelSize: 22
            color: "#ddd"
            x: -width/2 + 52
            rotation: -90
            y: width
        }

        Column {
            id: settingsColumn
            x: 10
            y: 10
            width: parent.width - 20
            spacing: 10

            Row {
                x: 64
                spacing: 10
                width: parent.width - 64

                Rectangle {
                    border.width: 1
                    border.color: "#444"
                    color: useListMouseArea.pressed ? "#555" : "#111"
                    radius: 5
                    width: 42
                    height: 42

                    Image {
                        anchors.centerIn: parent
                        source: "../pics/delete.png"
                        visible: settingsDialogItem.useList
                    }

                    MouseArea {
                        id: useListMouseArea
                        anchors.fill: parent
                        onClicked: {
                            settingsDialogItem.useList = !settingsDialogItem.useList;
                        }
                    }
                }

                Text {
                    text: "List in landscape"
                    width: parent.width - 64
                    wrapMode: Text.Wrap
                    font.pixelSize: 22
                    anchors.verticalCenter: parent.verticalCenter
                    color: "#ddd"
                }


            }

            Rectangle {
                x: 64
                width: 240
                height: 1
                color: "#ccc"
            }

            Row {
                x: 64
                spacing: 10
                width: parent.width - 64

                Rectangle {
                    border.width: 1
                    border.color: "#444"
                    color: noneMouseArea.pressed ? "#555" : "#111"
                    radius: 5
                    width: 42
                    height: 42

                    Image {
                        anchors.centerIn: parent
                        source: "../pics/delete.png"
                        visible: settingsDialogItem.autoRefresh == "0"
                    }

                    MouseArea {
                        id: noneMouseArea
                        anchors.fill: parent
                        onClicked: {
                            settingsDialogItem.autoRefresh = "0";
                        }
                    }
                }

                Text {
                    text: "None"
                    wrapMode: Text.Wrap
                    font.pixelSize: 22
                    anchors.verticalCenter: parent.verticalCenter
                    color: "#ddd"
                }
            }

            Row {
                x: 64
                spacing: 10
                width: parent.width - 64

                Rectangle {
                    border.width: 1
                    border.color: "#444"
                    color: minuteMouseArea.pressed ? "#555" : "#111"
                    radius: 5
                    width: 42
                    height: 42

                    Image {
                        anchors.centerIn: parent
                        source: "../pics/delete.png"
                        visible: settingsDialogItem.autoRefresh == "1"
                    }

                    MouseArea {
                        id: minuteMouseArea
                        anchors.fill: parent
                        onClicked: {
                            settingsDialogItem.autoRefresh = "1";
                        }
                    }
                }

                Text {
                    text: "1 minute"
                    wrapMode: Text.Wrap
                    font.pixelSize: 22
                    anchors.verticalCenter: parent.verticalCenter
                    color: "#ddd"
                }
            }

            Row {
                x: 64
                spacing: 10
                width: parent.width - 64

                Rectangle {
                    border.width: 1
                    border.color: "#444"
                    color: fiveMouseArea.pressed ? "#555" : "#111"
                    radius: 5
                    width: 42
                    height: 42

                    Image {
                        anchors.centerIn: parent
                        source: "../pics/delete.png"
                        visible: settingsDialogItem.autoRefresh == "5"
                    }

                    MouseArea {
                        id: fiveMouseArea
                        anchors.fill: parent
                        onClicked: {
                            settingsDialogItem.autoRefresh = "5";
                        }
                    }
                }

                Text {
                    text: "5 minutes"
                    wrapMode: Text.Wrap
                    font.pixelSize: 22
                    anchors.verticalCenter: parent.verticalCenter
                    color: "#ddd"
                }
            }

            Row {
                x: 64
                spacing: 10
                width: parent.width - 64

                Rectangle {
                    border.width: 1
                    border.color: "#444"
                    color: fifteenMouseArea.pressed ? "#555" : "#111"
                    radius: 5
                    width: 42
                    height: 42

                    Image {
                        anchors.centerIn: parent
                        source: "../pics/delete.png"
                        visible: settingsDialogItem.autoRefresh == "15"
                    }

                    MouseArea {
                        id: fifteenMouseArea
                        anchors.fill: parent
                        onClicked: {
                            settingsDialogItem.autoRefresh = "15";
                        }
                    }
                }

                Text {
                    text: "15 minutes"
                    wrapMode: Text.Wrap
                    font.pixelSize: 22
                    anchors.verticalCenter: parent.verticalCenter
                    color: "#ddd"
                }
            }
            Rectangle {
                id: settingsButtonExContainer
                radius: 5
                color: theme.dialogButtonExAreaBG
                width: parent.width
                height: 70

                ButtonEx {
                    id: settingsButtonEx
                    label: "Save"
                    width: parent.width/2 - 15
                    x: 10
                    y: 10 //
                    onClicked: {
                        settingsDialogItem.clicked();
                        settingsDialogItem.state = "hidden"
                    }
                }

                ButtonEx {
                    id: cancelButtonEx
                    label: "Cancel"
                    width: parent.width/2 - 15
                    x: parent.width/2 + 5
                    y: 10 //
                    onClicked: {
                        settingsDialogItem.state = "hidden"
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

    states:
        State {
        name: "hidden"
        PropertyChanges {
            target: settingsDialog
            y: 0 - settingsDialog.height - 16
        }
    }
    State {
        name: "shown"
        PropertyChanges {
            target: settingsDialog
            y: 0
        }
    }

    transitions: Transition {
        SequentialAnimation {
            PropertyAnimation {
                target: settingsDialog
                properties: "y"
                duration: 600
                easing.type: "OutQuad"
            }
        }
    }

}
