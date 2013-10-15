import Qt 4.7

Rectangle {
    id: photosList
    signal clicked(string photo)
    signal loadMore(string url)
    signal backToAlbums()
    property ListModel model
    property int thumbSize: 90
    property int currentPhoto: 0
    width: parent.width
    color: "#fff"

    function showNext() {
        currentPhoto++;
        if(currentPhoto<model.count) {
            var photo = model.get(currentPhoto);
            photosList.clicked(photo.photo_id);
        }
    }

    MouseArea {
        anchors.fill: parent
        onClicked: { }
    }

    GridView {
        model: photosList.model
        anchors.fill: parent
        anchors.horizontalCenter: parent.horizontalCenter
        delegate: photosListDelegate
        highlightFollowsCurrentItem: true
        cellWidth: photosList.thumbSize
        cellHeight: photosList.thumbSize
    }

    BackButtonEx {
        id: backButtonEx
        //label: "Back"
        x: 10
        y: parent.height - height - 10
        //width: parent.width - 20
        onClicked: photosList.backToAlbums();
    }

    Component {
        id: photosListDelegate

        Item {
            id: albumItem
            width: photosList.thumbSize
            height: photosList.thumbSize
            property string photoID: photo_id
            property string nextURL: next_url

            Rectangle {
                id: albumContainer
                color: "#fff"
                opacity: mouseArea.pressed ? 0.5 : 1.0
                //clip: true
                width: photosList.thumbSize-2
                height: photosList.thumbSize-2
                x: 1
                y: 1
                Image {
                    id: albumCoverImage
                    smooth: true
                    source: next_url.length==0 ? photo : "../pics/br_next.png"
                    width: next_url.length==0 ? photosList.thumbSize - 2 : 48
                    height: next_url.length==0 ? photosList.thumbSize - 2 : 48
                    fillMode: Image.PreserveAspectCrop
                    //scale: next_url.length==0 ? 1.6 : 1.0
                    clip: true
                    anchors.centerIn: parent
                }
            }

            MouseArea {
                id: mouseArea
                anchors.fill: parent
                onClicked: {
                    if(next_url.length==0) {
                        photosList.currentPhoto = index;
                        photosList.clicked( albumItem.photoID );
                    } else {
                        photosList.loadMore( albumItem.nextURL );
                    }
                }
            }

        }
    }

    states: [
        State {
            name: "hidden"
            PropertyChanges {
                target: photosList
                x: parent.width
            }
        },
        State {
            name: "shown"
            PropertyChanges {
                target: photosList
                x: 0
            }
        }
    ]

    transitions: [
        Transition {
            SequentialAnimation {
                PropertyAnimation {
                    target: photosList
                    properties: "x"
                    duration: 300
                    easing.type: "InOutQuad"
                }
            }
        }
    ]
}
