import QtQuick 1.0
//import com.meego 1.0

/*TextField {
    id: textBox
    placeholderText: "Search"
    text: ""
    function getText(){
        return textBox.text
    }
    function setText(txt) {
        textBox.text = txt;
    }
    function closeVirtualKeyboard() {
        textBox.focus = true;
        textBox.closeSoftwareInputPanel();
    }
}*/

Rectangle {
    id: checkinShoutBox
    width: parent.width
    height: 35
    gradient: Gradient {
        GradientStop { position: 0.0; color: "#ccc" }
        GradientStop { position: 0.1; color: "#fafafa" }
        GradientStop { position: 1.0; color: "#fff" }
    }
    radius: 5
    border.width: 1
    border.color: "#aaa"
    smooth: true
    property string text: ""
    property string placeholderText: ""

    function getText(){
        if(textBox.text == checkinShoutBox.placeholerText) {
            return "";
        } else {
            return textBox.text
        }
    }
    function setText(txt) {
        textBox.text = txt;
    }
    function closeVirtualKeyboard() {
        textBox.closeSoftwareInputPanel();
    }
    function closeSoftwareInputPanel() {
        textBox.closeSoftwareInputPanel();
    }

    TextInput {
        id: textBox
        //wrapMode: TextEdit.Wrap
        text: checkinShoutBox.text
        //textFormat: TextEdit.PlainText
        width: parent.width - 10
        height: parent.height - 10
        x: 5
        y: 5
        color: "#111"
        font.pixelSize: 20

        MouseArea {
            anchors.fill: parent
            onClicked: {
                textBox.forceActiveFocus();
                textBox.openSoftwareInputPanel();
            }
        }
    }
}
