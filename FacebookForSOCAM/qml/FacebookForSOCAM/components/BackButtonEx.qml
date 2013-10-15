import Qt 4.7

Item {
    id: backButtonEx
    signal clicked()
    y: -25
    x: 0
    height: 50
    width: 50
    property string icon: "../pics/arrow_left.png"
    z: 15

    Image {
        opacity: mouse.pressed ? 0.5 : 1.0
        source: backButtonEx.icon
        anchors.centerIn: parent
        z: 15
    }

    MouseArea {
        z: 15
        id: mouse
        anchors.fill: parent
        onClicked: {
            backButtonEx.clicked();
        }
    }

}
