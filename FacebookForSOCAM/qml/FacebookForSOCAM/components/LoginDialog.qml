import Qt 4.7
import QtWebKit 1.0

Rectangle {
    id: loginDialog
    signal finished(string url)
    signal loadFailed()
    anchors.fill: parent
    color: "#fff"    

    function reset() {

        console.log("app_id=" + window.appId + "!!!!!");
        webView.url = "https://www.facebook.com/dialog/oauth?client_id=" + window.appId + "&redirect_uri=http://www.facebook.com/connect/login_success.html&display=touch&response_type=token&scope=user_about_me,publish_stream,offline_access,read_stream,user_status,user_photos,friends_photos,friends_status,user_checkins,friends_checkins,user_events,publish_checkins,manage_notifications";

        webView.reload.trigger();
    }

    Flickable {
        width: parent.width
        height: parent.height
        contentWidth: Math.min(parent.width,800)
        contentHeight: Math.max(parent.height,800)
        pressDelay: 200

        WebView {
            id: webView
            anchors.fill: parent
            //anchors.centerIn: parent
            //width: parent.width
            //height: parent.height
            preferredHeight: Math.max(parent.height,800)
            preferredWidth: Math.min(parent.width,800)

            url: ""

            onLoadStarted: {
                loadingIndicator.visible = true;
                hiddenInput.closeVirtualKeyboard();
            }

            onLoadFinished: {
                loadingIndicator.visible = false;
                loginDialog.finished( webView.url );
            }

            onLoadFailed: {
                loadingIndicator.visible = false;
                loginDialog.loadFailed();
            }

        }
    }

    CustomTextInput {
        id: hiddenInput
        visible: false
    }

    Rectangle {
        id: loadingIndicator
        width: 200
        height: 40
        anchors.centerIn: parent
        color: "#333"
        visible: false

        Text {
            text: "Loading"
            anchors.centerIn: parent
            font.pixelSize: 20
            color: "#fff"
        }
    }

}
