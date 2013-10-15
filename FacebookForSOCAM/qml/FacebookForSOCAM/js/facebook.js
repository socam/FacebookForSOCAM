Qt.include("storage.js")


var oauth;
var accessToken = "";

var commentsModel;
var done;
var waiting;
var notificationsLoaded = false;
var lastReadNotificationID = "";

function setComponents(comments, doneInd, waitInd) {
    commentsModel = comments;
    done = doneInd;
    waiting = waitInd;
}

function setAccessToken(token) {
    accessToken = "access_token=" + token;
}

function getAccessToken(appId, appSecret, code) {
    waiting.state = "shown";
    console.log("getAccessToken code=", code);
    var url = "https://graph.facebook.com/oauth/access_token?client_id=" + appId + "&grant_type=client_credentials&redirect_uri=https://www.facebook.com/connect/login_success.html&client_secret=" + appSecret + "&code=" + code + "&scope=publish_stream,offline_access,read_stream,user_status,user_photos,friends_photos,friends_status,user_checkins,friends_checkins,user_events,publish_checkins,manage_notifications";
    console.log("getAccessToken URL=", url);
    doWebRequest("GET", url, "", parseAccessToken);
}

function parseAccessToken(response) {
    console.log("Parsing access token response=[[" , response, "]]");
    accessToken = "access_token=" + parseParameter(response, "access_token");
    setKeyValue("accesstoken", accessToken);
    console.log("accessToken=" + accessToken);
    loadHomeFeed();
}

function loadHomeFeed() {
    waiting.state = "shown";
    waiting.label = "Loading feed";
    var url = "https://graph.facebook.com/me/home?" + accessToken;
    doWebRequest("GET", url, "", parseHomeFeed);
}

function loadUserWall(id) {
    waiting.state = "shown";
    waiting.label = "Loading user wall";
    wallModel.clear();
    wallList.user_id = id;
    var url = "https://graph.facebook.com/" + id + "/feed?" + accessToken;
    doWebRequest("GET", url, "", parseUserWallFeed);
}

function loadAlbums(id) {
    waiting.state = "shown";
    waiting.label = "Loading albums";
    albumsModel.clear();
    var url = "https://graph.facebook.com/" + id + "/albums?" + accessToken;
    //console.log("Load albums: " + url);
    doWebRequest("GET", url, "", parseAlbums);
}

function parseAlbums(response) {
    var data = eval("[" + response + "]")[0].data;
    var count = 0;
    for(var i in data) {
        var album = data[i];
        var updated = parseDate(album.updated_time);
        var albumUpdated = prettyDate(updated);
        albumsModel.append({
                           "cover": "https://graph.facebook.com/" + album.id + "/picture?type=thumbnail&" + accessToken,
                           "album_id": album.id,
                           "name": album.name,
                           "count": album.count,
                           "updated_time": albumUpdated
        });
        count++;
    }
    waiting.state = "hidden";
    if(count==0) {
        showDone("No visible albums");
    }
}

function loadPhotos(id) {
    waiting.state = "shown";
    waiting.label = "Loading photos";
    photosModel.clear();
    var url = "https://graph.facebook.com/" + id + "/photos?" + accessToken;
    //console.log("Load photos: " + url);
    doWebRequest("GET", url, "", parsePhotos);
}

function loadMorePhotos(url) {
    waiting.state = "shown";
    waiting.label = "Loading photos";
    //console.log("Loading more photos: " + url);
    photosModel.remove( photosModel.count-1 );
    doWebRequest("GET", url, "", parsePhotos);
}

function parsePhotos(response) {
    var data = eval("[" + response + "]")[0];
    for(var i in data.data) {
        var photos = data.data[i];
        photosModel.append({
                           "photo": "https://graph.facebook.com/" + photos.id + "/picture?type=thumbnail&" + accessToken,
                           "photo_id": photos.id,
                           "next_url": ""
        });
    }
    if(typeof(data.paging)!="undefined") {
        console.log("Added new page link");
        photosModel.append({
                           "next_url":data.paging.next,
                           "photo_id":"",
                           "photo": ""
        });
    }

    waiting.state = "hidden";
}

function loadPhoto(id) {
    waiting.state = "shown";
    waiting.label = "Loading photo";
    photoDiscussionModel.clear();
    var url = "https://graph.facebook.com/" + id + "?" + accessToken;
    //console.log("Load photo " + url);
    doWebRequest("GET", url, "", parsePhoto);
}

function parsePhoto(response) {
    var photo = eval("[" + response + "]")[0];
    photoView.photo_id = photo.id;
    photoView.photo_url = "https://graph.facebook.com/" + photo.id + "/picture?type=normal&" + accessToken;
    if(typeof(photo.name)!="undefined") {
        photoView.title = photo.name;
    } else {
        photoView.title = "";
    }

    //console.log("Photo: " + photoView.photo_url);
    if(typeof(photo.comments)!="undefined") {
        for(var i in photo.comments.data) {
            var comment = photo.comments.data[i];
            photoDiscussionModel.append({
                                        "profileImage": "https://graph.facebook.com/" + comment.from.id + "/picture",
                                        "fromName": comment.from.name,
                                        "message": comment.message
            });
        }
    }
    waiting.state = "hidden";
}

function loadSearch() {
    waiting.state = "shown";
    waiting.label = "Searching";
    var url = "https://graph.facebook.com/search?q=watermelon&type=post&" + accessToken;
    doWebRequest("GET", url, "", parseHomeFeed);
}

function nextPage(url) {
    waiting.state = "shown";
    waiting.label = "Loading next";
    url += "&" + accessToken;
    doWebRequest("GET", url, "", parseNextFeed);
}

function nextWallPage(url) {
    waiting.state = "shown";
    waiting.label = "Loading next";
    url += "&" + accessToken;
    doWebRequest("GET", url, "", parseNextWallFeed);
}

function getNotifications() {
    if(notificationsLoaded==false) {
        var url = "https://api.facebook.com/method/notifications.getList?format=JSON&" + accessToken;
        doWebRequest("GET", url, "", parseNotificationCount);
        notificationsLoaded = true;
    }
}

function parseNotificationCount(response) {
    //console.log("Notifications: " + response);
    var data = eval("[" + response + "]")[0];
    var unreadCount = 0;
    if(typeof(data.notifications)!="undefined") {
        unreadCount = data.notifications.length;
    }
    if(unreadCount>0) {
        notification.state = "shown";
        notification.count = String(unreadCount);
    }
}

function markNotificationAsRead(id) {
    if(lastReadNotificationID==id) {
        return;
    }
    var count = parseInt(notification.count, 10);
    lastReadNotificationID = id;
    if(count>=0) {
        count--;
    }
    if(count==0) {
        notification.state = "hidden";
    }

    notification.count = String(count);
    var url = "https://api.facebook.com/method/notifications.markRead?notification_ids=" + id + "&" + accessToken;
    doWebRequest("GET", url, "", doNothing);
}

function doNothing(result) {
    // Do nothing
}


function loadNotifications() {
    if(notificationsModel.count==0) {
        waiting.state = "shown";
        waiting.label = "Loading notifications";
        var url = "https://api.facebook.com/method/notifications.getList?format=json&" + accessToken;
        doWebRequest("GET", url, "", parseNotifications);
    }
}

function parseNotifications(response) {
    //console.log("Notifications: " + response);
    var data = eval("[" + response + "]")[0];
    notificationsModel.clear();
    if(typeof(data.notifications)!="undefined") {
        for(var i in data.notifications) {
            var noti = data.notifications[i];
            notificationsModel.append({
                                      "id": noti.notification_id,
                                      "title": noti.title_text,
                                      "icon_url": noti.icon_url,
                                      "object_type": noti.object_type,
                                      "object_id": noti.object_id
            });
        }
    }
    waiting.state = "hidden";
}

function loadEvents() {
    waiting.state = "shown";
    waiting.label = "Loading events";
    var url = "https://graph.facebook.com/me/events?" + accessToken;
    doWebRequest("GET", url, "", parseEvents);
}

function parseEvents(response) {
    //console.log("Events: " + response);
    var events = eval("[" + response + "]")[0].data;
    eventsModel.clear();
    for(var i in events) {
        var event = events[i];
        //console.log("Event:" + event.id);
        var start_time = parseDate(event.start_time);
        var prettyStart = start_time.toString(); // prettyDate(start_time);
        eventsModel.append({
                                  "id": event.id,
                                  "name": event.name,
                                  "location": event.location,
                                  "start_time": prettyStart
        });
    }
    waiting.state = "hidden";
}

function like(id) {
    waiting.state = "shown";
    waiting.label = "Please wait...";
    var url = "https://graph.facebook.com/" + id + "/likes?" + accessToken;
    doWebRequest("POST", url, "", showDone);
}

function loadComments(id) {
    commentsModel.clear();
    var url = "https://graph.facebook.com/" + id + "/comments?" + accessToken;
    //console.log("Loading comments: " + url);
    doWebRequest("GET", url, "", parseComments);
}

function parseComments(result) {
    try {
        var data = eval("[" + result + "]")[0];
        for(var i in data.data) {
            var comment = data.data[i];
            //console.log("msg: " + comment.message);
            commentsModel.append({
                                 "comment_id": comment.id,
                                 "profileImage":"https://graph.facebook.com/" + comment.from.id + "/picture",
                                 "fromName": comment.from.name,
                                 "message": comment.message
            });
        }
    } catch(ex) {

    }
    waiting.state = "hidden";
}

function loadFriends() {
    waiting.state = "hidden";
    var url = "https://graph.facebook.com/me/friends?" + accessToken;
    doWebRequest("GET", url, "", parseFriends);
}

function sortByName(a, b) {
    var x = a.name.toLowerCase();
    var y = b.name.toLowerCase();
    return ((x < y) ? -1 : ((x > y) ? 1 : 0));
}

function parseFriends(response) {
    var data = eval("[" + response + "]")[0].data;
    data = data.sort(sortByName);
    friendsModel.clear();
    for(var i in data) {
        var user = data[i];
        friendsModel.append({
                            "id": user.id,
                            "name": user.name,
                            "profileImageUrl":"https://graph.facebook.com/" + user.id + "/picture",
        });
    }
   //friendsModel.
    waiting.state = "hidden";
}

function shareStatus(message, link) {
    waiting.state = "shown";
    waiting.label = "Updating status";

    var url = "https://graph.facebook.com/me/feed?" + accessToken + "&message=" + encodeURIComponent(message);
    if(link.length>0) {
        link = link.replace("Http://", "http://");
        link = link.replace("Https://", "https://");
        url += "&link=" + link;
    }
    doWebRequest("POST", url, "", parseShareStatus);
    /*homeModel.insert(0, {
                     "fromName": "",
                     "toName": "",
                     "message": message,
                     "profileImageUrl": "https://graph.facebook.com/me/picture?" + accessToken,
                     "name": "",
                     "description": "",
                     "caption": "",
                     "icon": "",
                     "link": link,
                     "picture": "",
                     "created_time": "Just now",
                     "likes": 0,
                     "comments": 0,
                     "next": "",
                     "type": ""
    });*/
}

function parseShareStatus(data) {
    showDone("Status shared");
    loadHomeFeed();
}

function comment(message, id) {
    waiting.state = "shown";
    waiting.label = "Posting comment";
    var url = "https://graph.facebook.com/" + id;
    if(url.indexOf("/feed")<0) {
        url += "/comments";
    }
    url += "?" + "message=" + encodeURIComponent(message) + "&" + accessToken;
    console.log("CommentURL: " + url);
    doWebRequest("POST", url, "", showDone);
}

function showDone(data) {
    waiting.state = "hidden";
    done.state = "shown";
}

function showError(err) {
    waiting.state = "hidden";
    done.label = "Error " + err;
    done.state = "shown";
    console.log("Error: " + err);
}

function parseFeed(data, model) {
    console.log("data: " + data);
    if(typeof(data)=="undefined" || typeof(data.data)=="undefined") {
        console.log("No data to parse");
        return;
    }
    var feed = data.data;
    for(var i in feed) {
        var status = feed[i];
        var fromName = status.from.name;
        var toName = "";
        if(typeof(status.to)!="undefined") {
            toName = " &rarr; " + status.to.data[0].name;
        }

        var message = status.message;
        if(typeof(message)=="undefined") {
            message = "";
        }
        //console.log("Msg: " + message);

        var icon = status.icon;
        if(typeof(icon)=="undefined") {
            icon = "";
        }

        var description = status.description;
        if(typeof(description)=="undefined") {
            description = "";
        }

        var caption = status.caption;
        if(typeof(caption)=="undefined") {
            caption = "";
        } else {
            description = "<span class='color:#777'>" + caption + "</span><br/>" + description;
        }

        var name = status.name;
        if(typeof(name)=="undefined") {
            name = "";
        } else {
            description = "<span class='color:#3B5998'><b>" + name + "</b></span><br/>" + description;
        }

        var picture = status.picture;
        if(typeof(picture)=="undefined") {
            picture = "";
        } else {
            description = "<img src='" + picture + "' style='float:left;'/>" + description;
        }

        var link = status.link;
        if(typeof(link)=="undefined") {
            link = "";
        }

        var likes = 0;
        var likedBy = "";
        if(typeof(status.likes)!="undefined") {
            likes = status.likes.count;
            if(typeof(likes)=="undefined" || likes==null) {
                likes = parseInt(status.likes,10);
            } else {
                var likedByCount = 0;
                for(var x in status.likes.data) {
                    var likeName = status.likes.data[x].name;
                    if(likedBy.length>0) {
                        likedBy += ", ";
                    } else {
                        likedBy = "Liked by ";
                    }
                    likedBy += likeName;
                    likedByCount++;
                }
                if(likes>1 && likedByCount<likes) {
                    likedBy += " and " + String(likes-likedByCount) + " others";
                }
            }
        }

        var comments = 0;
        var discussion = null;
        if(typeof(status.comments)!="undefined") {
            comments = status.comments.count;
            discussion = status.comments;
        }

        var created = parseDate(status.created_time);
        var prettyCreated = prettyDate(created);

        model.append({
                         "id": status.id,
                         "status_id": status.id,
                         "fromID": status.from.id,
                         "fromName": fromName,
                         "toName": toName,
                         "message": message,
                         "profileImageUrl": "https://graph.facebook.com/" + status.from.id + "/picture",
                         "name": name,
                         "description": description,
                         "caption": caption,
                         "icon": icon,
                         "link": link,
                         "picture": picture,
                         "created_time": prettyCreated,
                         "likes": likes,
                         "likedBy": likedBy,
                         "comments": comments,
                         "discussion": discussion,
                         "actions": status.actions,
                         "type": status.type,
                         "object_id": status.object_id
        });
    }
    model.append({
                     "fromName": "",
                     "toName": "",
                     "message": "Load more...",
                     "profileImageUrl": "",
                     "name": "",
                     "description": "",
                     "caption": "",
                     "icon": "",
                     "link": "",
                     "picture": "",
                     "created_time": "",
                     "likes": 0,
                     "comments": 0,
                     "next": data.paging.next,
                     "type": "next"
    });
}

function parseHomeFeed(response) {
    waiting.label = "Processing";
    var data = eval("[" + response + "]")[0];
    homeModel.clear();
    parseFeed(data, homeModel);
    waiting.state = "hidden";
    getNotifications();
}

function parseNextFeed(response) {
    var last = homeModel.count - 1;
    waiting.state = "hidden";
    var data = eval("[" + response + "]")[0];
    parseFeed(data, homeModel);
    homeModel.remove(last);
}

function parseUserWallFeed(response) {
    waiting.label = "Processing";
    var data = eval("[" + response + "]")[0];
    parseFeed(data, wallModel);
    waiting.state = "hidden";
}

function parseNextWallFeed(response) {
    var last = wallModel.count - 1;
    waiting.state = "hidden";
    var data = eval("[" + response + "]")[0];
    parseFeed(data, wallModel);
    wallModel.remove(last);
}

function loadPlaces(query, lat, lon) {
    var url = "https://graph.facebook.com/search?"+
        "type=place" +
        "&center=" + lat + "," + lon +
        "&distance=2000&" + accessToken;
    if(query.length>0) {
        url += "&q=" + query;
    }
    console.log("Places URL: " + url);
    waiting.state = "shown";
    waiting.label = "Searching places";
    doWebRequest("GET", url, "", parsePlaces);
}

function getValue(value) {
    if(typeof(value)=="undefined") {
        return "";
    } else {
        return value;
    }
}

function parsePlaces(response) {
    waiting.state = "hidden";
    var data = eval("[" + response + "]")[0];
    placesModel.clear();
    for(var i in data.data) {
        var place = data.data[i];
        var name = place.name;
        var category = getValue(place.category);
        var street = getValue(place.location.street);
        var id = place.id;
        placesModel.append({
                           "name": name,
                           "category": category,
                           "street": street,
                           "placeid": id
        });
    }
    if(placesModel.count==0) {
        placesModel.append({
                           "name": "No places found :(",
                           "category": "",
                           "street": "Maybe GPS is still waiting for better satellite connection...",
                           "placeid": ""
        });
    }

/*
      {
         "name": "Tanja Kuulas",
         "category": "Local business",
         "location": {
            "street": "Saunasaarenkatu 10",
            "city": "Tampere",
            "zip": "33250",
            "latitude": 61.50402,
            "longitude": 23.7041
         },
         "id": "195006803876308"
         */
}

function loadRecentCheckins() {
    var url = "https://graph.facebook.com/me/checkins?" + accessToken;
    waiting.state = "shown";
    waiting.label = "Loading checkins";
    doWebRequest("GET", url, "", parseRecentCheckins);
}

function parseRecentCheckins(response) {
    waiting.state = "hidden";
    var data = eval("[" + response + "]")[0];
    checkinsModel.clear();
    for(var i in data.data) {
        var checkin = data.data[i];
        var name = checkin.place.name;
        var category = getValue(checkin.place.category);
        var street = getValue(checkin.place.location.street);
        var id = checkin.place.id;
        checkinsModel.append({
                           "name": name,
                           "created": checkin.created_time,
                           "category": category,
                           "street": street,
                           "placeid": id
        });
    }
    if(checkinsModel.count==0) {
        checkinsModel.append({
                             "name": "No recent checkins",
                             "created": "",
                             "category": "",
                             "street": "Search places to check-in by tapping the 'Nearby' button",
                             "placeid": ""
                    });
    }
}

function checkin(placeid, lat, lon, comment, friendIDs) {
    var url = "https://graph.facebook.com/me/checkins?";
    if(comment.length>0) {
        url += "message=" + encodeURIComponent(comment) + "&";
    }
    url += "place=" + placeid + "&coordinates={\"latitude\":\"" + lat + "\", \"longitude\":\"" + lon + "\"}&";
    if(friendIDs.length>0) {
        url += "tags=" + friendIDs + "&";
    }
    url += accessToken;
    waiting.state = "shown";
    waiting.label = "Please wait";
    doWebRequest("POST", url, "", parseCheckin);
}

function parseCheckin(respose) {
    showDone(respose);
}

function doWebRequest(method, url, params, callback) {
    var doc = new XMLHttpRequest();
    console.log("doWebRequest!!!!!!!!!!!!!!!!!!");
    console.log(method + " " + url);
    doc.onreadystatechange = function() {
        var status;
        if (doc.readyState == XMLHttpRequest.HEADERS_RECEIVED) {
            status = doc.status;
            if(status!=200) {
                showError("Facebook API returned " + status + " " + doc.statusText);
            }
        } else if (doc.readyState == XMLHttpRequest.DONE) {
            var data;
            var contentType = doc.getResponseHeader("Content-Type");
            data = doc.responseText;
            callback(data);
        }
    }
    doc.open(method, url);
    doc.send();
}

function prettyDate(date){
    try {
        var diff = (((new Date()).getTime() - date.getTime()) / 1000);
        var day_diff = Math.floor(diff / 86400);

        if ( isNaN(day_diff) || day_diff >= 31 ) {
            //console.log("Days: " + day_diff);
            return "some time ago";
        } else if (day_diff < 0) {
            //console.log("day_diff: " + day_diff);
            return "just now";
        }

        return day_diff == 0 && (
                    diff < 60 && "just now" ||
                    diff < 120 && "1 minute ago" ||
                    diff < 3600 && Math.floor( diff / 60 ) + " min ago" ||
                    diff < 7200 && "1 hour ago" ||
                    diff < 86400 && Math.floor( diff / 3600 ) + " hours ago") ||
                day_diff == 1 && "Yesterday" ||
                day_diff < 7 && day_diff + " days ago" ||
                day_diff < 31 && Math.ceil( day_diff / 7 ) + " weeks ago";
        day_diff >= 31 && Math.ceil( day_diff / 30 ) + " months ago";
    } catch(err) {
        console.log("Error: " + err);
        return "some time ago";
    }
}

// 2011-01-24T18:48:00Z
function parseDate(stamp)
{
    try {
        //console.log("stamp: " + stamp);
        var parts = stamp.split("T");
        var day;
        var time;
        var hours;
        var minutes;
        var seconds = 0;
        var year;
        var month;

        var dates = parts[0].split("-");
        year = parseInt(dates[0]);
        month = parseInt(dates[1])-1;
        day = parseInt(dates[2]);

        var times = parts[1].split(":");
        hours = parseInt(times[0]);
        minutes = parseInt(times[1]);

        var dt = new Date();
        dt.setUTCDate(day);
        dt.setYear(year);
        dt.setUTCMonth(month);
        dt.setUTCHours(hours);
        dt.setUTCMinutes(minutes);
        dt.setUTCSeconds(seconds);

        //console.log("day: " + day + " year: " + year + " month " + month + " hour " + hours);

        return dt;
    } catch(err) {
        console.log("Error while parsing date: " + err);
        return new Date();
    }
}

/** Parse parameter from given URL */
function parseParameter(url, parameter) {
    var parameterIndex = url.indexOf(parameter);
    if(parameterIndex<0) {
        // We didn't find parameter
        return "";
    }
    var equalIndex = url.indexOf("=", parameterIndex);
    if(equalIndex<0) {
        return "";
    }
    var value = "";
    var nextIndex = url.indexOf("&", equalIndex+1);
    if(nextIndex<0) {
        value = url.substring(equalIndex+1);
    } else {
        value = url.substring(equalIndex+1, nextIndex);
    }
    return value;
}
