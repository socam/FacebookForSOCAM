import Qt 4.7

Item {
    id: button
    property int pixelSize: 18
    property alias label: buttonText.text
    property double buttonOpacity: 1.0
    signal clicked()
    width: parent.width;
    height: 50

    Rectangle {
        id: buttonRect
        anchors.fill: parent
        opacity: button.opacity
        radius: 3
        border.color: "#147"
        border.width: 1
        gradient: !mouseArea.pressed ? idleColor : pressedColor
        smooth: true

        Text {
            id: buttonText
            text: "What?"
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            color: "#fff"
            font.pixelSize: button.pixelSize
            font.bold: true
        }

    }

    Gradient {
        id: pressedColor
        GradientStop { position: 0.0; color: "#445" }
        GradientStop { position: 0.1; color: "#556" }
        GradientStop { position: 0.9; color: "#667" }
        GradientStop { position: 1.0; color: "#778" }
    }

    Gradient {
        id: idleColor

        GradientStop { position: 0.08; color: "#5c76af" } // "#6079AB" }
        GradientStop { position: 0.5; color: "#356098" } //  "#3B5998" }
        GradientStop { position: 1.0; color: "#29447E" } // "#1a1a1a"

/*
        GradientStop { position: 0.0; color: "#ddd" }
        GradientStop { position: 0.1; color: "#ccc" }
        GradientStop { position: 0.8; color: "#999" }
        GradientStop { position: 1.0; color: "#bbb" }
*/

/*    	GradientStop { position: 0.0; color: "#ddd" }
        GradientStop { position: 0.1; color: "#ccc" }
        GradientStop { position: 0.5; color: "#d7d7d7" }
        GradientStop { position: 0.51; color: "#bbb" }
        GradientStop { position: 1.0; color: "#999" }
*/    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        onClicked: {
            button.clicked();
        }
    }

}
