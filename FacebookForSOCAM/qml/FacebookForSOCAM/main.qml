import QtQuick 1.0
import QtMobility.location 1.1
import "components"
import "js/facebook.js" as Facebook
import "js/storage.js" as Storage
//import com.meego 1.0

//PageStackWindow {
//    showToolBar: false
//    initialPage: window

Rectangle {
    id: window
    anchors.fill: parent
    width: 360
    height: 640
    color: "#f3f3f3"
    property string lat: ""
    property string lon: ""
    property bool locationAvailable: false

    property string appId : "165597683490107";
    property string appSecret : "c1077c7d5b6ecabff82d4f140dc98246";

    ListModel {
        id: homeModel
    }

    ListModel {
        id: friendsModel
    }

    ListModel {
        id: notificationsModel
    }

    ListModel {
        id: eventsModel
    }

    ListModel {
        id: commentsModel
    }

    ListModel {
        id: wallModel
    }

    ListModel {
        id: albumsModel
    }

    ListModel {
        id: photosModel
    }

    ListModel {
        id: photoDiscussionModel
    }

    ListModel {
        id: checkinsModel
    }

    ListModel {
        id: placesModel
    }

    CustomTheme {
        id: theme
        visible: false
    }

    Timer {
        id: locationTimer
        interval: 1500
        repeat: true
        onTriggered: {
            if(typeof(positionSource)!="undefined" &&
                    typeof(positionSource.position.coordinate.latitude)!="undefined") {

                //console.log("Update locations");

                var coord = positionSource.position.coordinate;
                window.lat = String(coord.latitude);
                window.lon = String(coord.longitude);

                //console.log("LAT: " + window.lat);

                if(window.lat.length>0 && window.lat!="NaN") {
                    Storage.setKeyValue("latitude", window.lat);
                    Storage.setKeyValue("longitude", window.lon);
                    window.locationAvailable = true;
                } else {
                    window.locationAvailable = false;
                }
            }
        }
    }

    Timer {
        id: screenSizeChecker
        interval: 2500
        repeat: false
        onTriggered: {
            var smallerSide = window.height;
            if(smallerSide>window.width) {
                smallerSide = window.width;
            }
            var what = smallerSide % 90;
            photosList.thumbSize = 90 + parseInt(what / parseInt(smallerSide/90));
            console.log("ThumbSize: " + photosList.thumbSize);
        }
    }

    Timer {
        id: splashHider
        interval: 2800
        repeat: false
        onTriggered: {
            splash.visible = false;
        }
    }

    PositionSource {
        id: positionSource
        updateInterval: 1000
        active: false
    }

    Component.onCompleted: {
        Facebook.setComponents(commentsModel,
                               done,
                               waiting);
        //Facebook.setAccessToken("access_token=...");
        //Facebook.loadHomeFeed();
        //Facebook.loadSearch();
        Storage.getKeyValue("accesstoken", valueLoaded);
        Storage.getKeyValue("longitude", valueLoaded);
        Storage.getKeyValue("latitude", valueLoaded);
        screenSizeChecker.start();
        splashHider.start();
        locationTimer.start();
    }

    function valueLoaded(key, value) {
        if(key==="accesstoken") {
            if(value.length>20) {
                console.log("VALUE LOADED access_token")
                Facebook.setAccessToken(value);
                Facebook.loadHomeFeed();
            } else {
                login.visible = true;
                login.reset();
            }
        } else if(key=="latitude") {
            window.lat = value;
        } else if(key=="longitude") {
            window.lon = value;
        }
    }

    function loadFriends() {
        Facebook.loadFriends();
    }

    Item {
        id: toolBar
        height: 0
        property bool showBack: false
    }


/*    ToolBar {
        id: toolBar
        showMinimize: windowHelper.isMaemo();
        onMenuClicked: {
            if(menu.state!="shown") {
                menu.state = "shown";
            } else {
                menu.state = "hidden";
            }
        }
        onHomeClicked: {
            window.showHome();
        }
        onShareStatusClicked: {
            if(statusDialog.state!="shown") {
                statusDialog.state = "shown";
            } else {
                statusDialog.state = "hidden";
            }
        }
        onMinimizeClicked: {
            windowHelper.minimize();
        }
    }
*/
    HomeList {
        id: homeList
        homeModel: homeModel
        width:parent.width
        //y: toolBar.height
        height: parent.height - toolBar.height

        onClicked: {
            var status = homeModel.get(index);
            if(status.message=="Load more...") {
                Facebook.nextPage(status.next);
            } else {
                statusView.state = "shown";
                statusView.model = homeModel;
                statusView.fill(index);
                toolBar.showBack = true;
                if(status.comments>0) {
                    Facebook.loadComments(status.id);
                }
            }
        }
        onLoadMore: {
            var status = homeModel.get(homeModel.count - 1);
            Facebook.nextPage(status.next);
        }
        onRefresh: {
            console.log("HOMELIST:onRefresh()");
            Facebook.loadHomeFeed();
        }
    }

    FriendsList {
        id: friendsList
        //y: toolBar.height
        height: parent.height // - toolBar.height
        state: "hidden"
        onClicked: {
            friendsList.state = "hiddenLeft";
            wallList.state = "shown";
            var user = friendsModel.get(index);
            Facebook.loadUserWall(user.id);
            wallList.user_name = user.name;
            toolBar.showBack = true;
        }
    }

    Wall {
        id: wallList
        model: wallModel
        width:parent.width
        y: toolBar.height
        height: parent.height - toolBar.height
        state: "hidden"

        onShowPhotosClicked: {
            hideAllPanels();
            albumsList.state = "shown";
            Facebook.loadAlbums(wallList.user_id);
        }

        onShowComment: {
            commentDialog.state = "shown";
            commentDialog.clear();
            commentDialog.name = wallList.user_name;
            commentDialog.url = wall_id + "/feed";
        }

        onClicked: {
            var status = wallModel.get(index);
            if(status.message=="Load more...") {
                Facebook.nextWallPage(status.next);
            } else {
                statusView.state = "shown";
                statusView.model = wallModel;
                statusView.fill(index);
                if(status.comments>0) {
                    Facebook.loadComments(status.id);
                }
                toolBar.showBack = true;
            }
        }
    }

    EventsList {
        id: eventsList
        eventsModel: eventsModel
        width:parent.width
        //y: toolBar.height
        height: parent.height //- toolBar.height
        state: "hidden"
        onClicked: {
           // TODO
        }
    }

    Places {
        id: places
        width:parent.width
        //y: toolBar.height
        height: parent.height // - toolBar.height
        state: "hidden"
        showSignal: !window.locationAvailable
        onPlaceClicked: {
            window.hideAllPanels();
            var plc = placesModel.get(index);
            place.state = "shown";
            place.name = plc.name;
            place.placeID = plc.placeid;
            place.street = plc.street;
            place.category = plc.category;
            place.reset();
        }
        onCheckinClicked: {
            window.hideAllPanels();
            var plc = checkinsModel.get(index);
            place.state = "shown";
            place.name = plc.name;
            place.placeID = plc.placeid;
            place.street = plc.street;
            place.category = plc.category;
            place.reset();
        }
        onLoadPlaces: {
            if(window.locationAvailable) {
                Facebook.loadPlaces(filter, window.lat, window.lon);
            } else {
                placesModel.append({
                                   "name": "No GPS connection",
                                   "category": "",
                                   "street": "Please wait while your phone is trying to figure out your location on earth.",
                                   "placeid": ""
                });
            }
        }
    }

    PlaceDetails {
        id: place
        width: parent.width
        y: toolBar.height
        height: parent.height - toolBar.height
        state: "hidden"

        onBack: {
            place.state = "hidden";
            places.state = "shown";
        }
        onCheckin: {
            place.state = "hidden";
            places.state = "shown";
            Facebook.checkin(pid, window.lat, window.lon, comment, friendIDs);
        }
    }

    AlbumsList {
        id: albumsList
        model: albumsModel
        width:parent.width
        //y: toolBar.height
        height: parent.height //- toolBar.height
        state: "hidden"
        onClicked: {
            albumsList.state = "hidden";
            photosList.state = "shown";
            Facebook.loadPhotos(album);
        }
    }

    PhotosList {
        id: photosList
        model: photosModel
        width:parent.width
        y: toolBar.height
        height: parent.height - toolBar.height
        state: "hidden"
        onClicked: {
            //photosList.state = "hidden";
            photoView.state = "shown";
            photoView.showBackToAlbum = true;
            Facebook.loadPhoto(photo);
        }
        onLoadMore: {
            Facebook.loadMorePhotos(url);
        }
        onBackToAlbums: {
            photosList.state = "hidden";
            albumsList.state = "shown";
        }
    }

    Image {
        source:  "pics/bottom-shadow.png"
        x: 0
        y: parent.height - height
        width: parent.width
    }

    function hideAllPanels() {
        notificationsList.state = "hidden";
        homeList.state = "hiddenLeft";
        friendsList.state = "hidden";
        statusView.state = "hidden";
        wallList.state = "hidden";
        eventsList.state = "hidden";
        albumsList.state = "hidden";
        photosList.state = "hidden";
        photoView.state = "hidden";
        places.state = "hidden";
        place.state = "hidden";
        toolBar.showBack = false;
    }

    function showHome() {
        window.hideAllPanels();
        homeList.state = "shown";
    }

    StatusView {
        id: statusView
        width: parent.width
        height: parent.height
        model: homeModel
        discussionModel: commentsModel

        onLike: {
            Facebook.like(status_id);
        }

        onComment: {
            commentDialog.state = "shown";
            commentDialog.clear();
            commentDialog.url = status_id;
            commentDialog.name = "status of " + statusView.user_name;
        }

        onGoBack: {
            if(statusView.model==homeModel) {
                toolBar.showBack = false;
            }
        }

        onShare: {
            statusDialog.state = "shown";
            statusDialog.reset();
            statusDialog.linkTxt = link; //setLink(link);
        }

        onOpenWall: {
            window.hideAllPanels();
            wallList.state = "shown";
            Facebook.loadUserWall( user_id );
            wallList.user_name = status.fromName;
            toolBar.showBack = true;
        }

        onOpenPhoto: {
            //window.hideAllPanels();
            photoView.state = "shown";
            photoView.showBackToAlbum = false;
            photoView.showBackToStatus = true;
            Facebook.loadPhoto(photo_id);
            photosModel.clear();
            toolBar.showBack = true;
        }

        onLikeComment: {
            Facebook.like( comment_id );
        }
    }

    PhotoView {
        id: photoView
        width: parent.width
        y: toolBar.height
        photoDiscussionModel: photoDiscussionModel
        height: parent.height - toolBar.height
        state: "hidden"
        onLike: {
            console.log("Liking " + index);
            Facebook.like(index);
        }
        onComment: {
            commentDialog.state = "shown";
            commentDialog.url = index;
            commentDialog.name = "photo";
        }
        onGoBack: {
            photoView.state = "hidden";
            photosList.state = "shown";
        }
        onShowNext: {
            photosList.showNext();
        }
    }

    NotificationsList {
        id: notificationsList
        notificationsModel: notificationsModel
        width: parent.width
        y: toolBar.height
        height:  parent.height - toolBar.height
        state: "hidden"
        onClicked: {
            var noti = notificationsModel.get(index);
            Facebook.markNotificationAsRead(noti.id);
            if(noti.object_type=="stream") {
                var obj_id = noti.object_id;
                var separator = obj_id.indexOf("_");
                if(separator>0) {
                    var user_id = obj_id.substr(0,separator);
                    window.hideAllPanels();
                    wallList.state = "shown";
                    Facebook.loadUserWall(user_id);
                    toolBar.showBack = true;
                }
            }
            notificationsModel.remove(index);
        }
    }
/*
    MainMenu {
        id: menu
        //anchors.horizontalCenter: parent.horizontalCenter
        x: parent.width - width
        y: -menu.height
        state: "hidden"
        onHomeClicked: {
            window.showHome();
            Facebook.loadHomeFeed();
        }
        onFriendsClicked: {
            window.hideAllPanels();
            friendsList.state = "shown";
            Facebook.loadFriends();
            toolBar.showBack = true;
        }
        onWallClicked: {
            window.hideAllPanels();
            wallList.state = "shown";
            Facebook.loadUserWall("me");
            toolBar.showBack = false;
        }
        onShareStatusClicked: statusDialog.state = "shown";
        onMessagesClicked: Facebook.loadMessages();
        onEventsClicked: {
            window.hideAllPanels();
            eventsList.state = "shown";
            toolBar.showBack = true;
            Facebook.loadEvents();
        }
        onPhotosClicked: {
            window.hideAllPanels();
            albumsList.state = "shown";
            toolBar.showBack = true;
            Facebook.loadAlbums("me");
        }
        onPlacesClicked: {
            window.hideAllPanels();
            places.state = "shown";
            toolBar.showBack = false;
            positionSource.active = true;
            Facebook.loadRecentCheckins();
            //Facebook.loadPlaces("", window.lat, window.lon);
        }
        onLogoutClicked: {
            window.hideAllPanels();
            Facebook.accessToken = "";
            login.visible = true;
            login.reset();
        }

        states: [
            State {
                name: "shown"
                PropertyChanges {
                    target: menu
                    y: 45
                }
            },
            State {
                name: "hidden"
                PropertyChanges {
                    target: menu
                    y: -menu.height
                }
            }
        ]

        transitions: [
            Transition {
                SequentialAnimation {
                    PropertyAnimation {
                        target: menu
                        properties: "y"
                        duration: 400
                        easing.type: "InOutQuad"
                    }
                }
            }
        ]
    }
*/


    NotificationBar {
        id: notification
        count: "0"
        state: "hidden"
        onMenuClicked: {
            //notification.state = "hidden";
            window.hideAllPanels();
            notificationsList.state = "shown";
            Facebook.loadNotifications();
            toolBar.showBack = true;
        }
    }

    BottomToolbar {
        onHomeClicked: {
            window.showHome();
            Facebook.loadHomeFeed();
        }
        onFriendsClicked: {
            window.hideAllPanels();
            friendsList.state = "shown";
            Facebook.loadFriends();
            toolBar.showBack = true;
        }
        onWallClicked: {
            window.hideAllPanels();
            wallList.state = "shown";
            Facebook.loadUserWall("me");
            toolBar.showBack = false;
        }
        onShareStatusClicked: statusDialog.state = "shown";
        onMessagesClicked: Facebook.loadMessages();
        onEventsClicked: {
            window.hideAllPanels();
            eventsList.state = "shown";
            toolBar.showBack = true;
            Facebook.loadEvents();
        }
        onPhotosClicked: {
            window.hideAllPanels();
            albumsList.state = "shown";
            toolBar.showBack = true;
            Facebook.loadAlbums("me");
        }
        onPlacesClicked: {
            window.hideAllPanels();
            places.state = "shown";
            toolBar.showBack = false;
            positionSource.active = true;
            Facebook.loadRecentCheckins();
            //Facebook.loadPlaces("", window.lat, window.lon);
        }
        onLogoutClicked: {
            window.hideAllPanels();
            Facebook.accessToken = "";
            login.visible = true;
            login.reset();
        }
    }

    MouseArea {
        width: 32
        height: 32
        visible: windowHelper.isMaemo()
        onClicked: {
            console.log("Minimize");
            windowHelper.minimize();
        }
    }

    StatusDialog {
        id: statusDialog
        onClicked: {
            console.log("Update status to '" + text + "' with link '" + link + "'");
            Facebook.shareStatus(text, link);
        }
    }

    CommentDialog {
        id: commentDialog
        onClicked: {
            console.log("Add comment '" + text + "' to " + url);
            Facebook.comment(text, url);
        }
    }

    CustomTextInput {
        id: hiddenInput
        visible: false
    }

    LoginDialog {
        id: login
        anchors.fill: parent
        visible: false
        onFinished: {
            console.log("current URL: " + url);
            if(url.indexOf("code=")>0 && url.indexOf("error_code=")<0) {
                login.visible = false;
                var codeStart = url.indexOf("code=");
                var code = url.substring(codeStart + 5);
                console.log("CODE=[", code, "]");
                Facebook.getAccessToken(appId, appSecret, code);
                hiddenInput.closeVirtualKeyboard();
            }
            else if(url.indexOf("access_token=")>0) {
                console.log("GET ACCESS TOKEN(2)!!!!");
                login.visible = false;
                var tokenStart = url.indexOf("access_token=");
                var token = url.substring(tokenStart + 13);
                var firstSlash = token.indexOf("&");
                token = token.substring(0, firstSlash);

                Facebook.setAccessToken(token);
                Storage.setKeyValue("accesstoken", token);
                hiddenInput.closeVirtualKeyboard();

                homeList.state="shown";
            }
        }

        onLoadFailed: {
            done.label = "Error loading page"
            done.state = "shown"
        }
    }


    DoneIndicator {
        id: done
        label: "Done"

        onStateChanged: {
            //if(done.label.indexOf(" 400 ")>0) {
                //login.visible = true;
                //login.reset();
            //}
        }
    }

    WaitingIndicator {
        id: waiting
    }

    SplashDialog {
        id: splash
        y: window.height - height
    }

}
//}
