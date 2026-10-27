import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

Item {
    id: breezeView
    height: Math.min(parent ? parent.height : 30, 30)
    width: breezeRow.implicitWidth + 16
    implicitHeight: 30
    implicitWidth: breezeRow.implicitWidth + 16

    // Explicit Properties
    property string title: "No Track"
    property string artist: ""
    property string album: ""
    property bool isPlaying: false
    property bool showArtist: true
    property int maxTitleWidth: 160

    // Signals
    signal playPauseClicked()
    signal previousClicked()
    signal nextClicked()
    signal raiseClicked()
    signal middleClicked()

    readonly property color spotifyGreen: "#1DB954"

    // Breeze-style hover highlight container
    Rectangle {
        id: hoverHighlight
        anchors.fill: parent
        radius: 4
        color: Qt.rgba(1, 1, 1, 0.05)
        visible: breezeArea.containsMouse
    }

    MouseArea {
        id: breezeArea
        anchors.fill: parent
        hoverEnabled: true
        acceptedButtons: Qt.NoButton
    }

    RowLayout {
        id: breezeRow
        anchors.centerIn: parent
        spacing: 10

        // 1. Controls on the Left (Previous, Play/Pause, Next) - Sized up for easy clicking
        RowLayout {
            id: bControls
            spacing: 4
            Layout.alignment: Qt.AlignVCenter

            // Previous
            MouseArea {
                id: prevBtn
                width: 26; height: 26
                implicitWidth: 26; implicitHeight: 26
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: breezeView.previousClicked()

                Rectangle {
                    anchors.fill: parent
                    radius: 5
                    color: prevBtn.containsMouse ? Qt.rgba(1, 1, 1, 0.15) : "transparent"
                }

                Text {
                    anchors.centerIn: parent
                    text: "⏮"
                    font.pixelSize: 16
                    color: prevBtn.containsMouse ? "#ffffff" : "#c5cbd4"
                }
            }

            // Play / Pause
            MouseArea {
                id: playBtn
                width: 28; height: 28
                implicitWidth: 28; implicitHeight: 28
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: breezeView.playPauseClicked()

                Rectangle {
                    anchors.fill: parent
                    radius: 6
                    color: playBtn.containsMouse ? Qt.rgba(1, 1, 1, 0.20) : "transparent"
                }

                Text {
                    anchors.centerIn: parent
                    text: breezeView.isPlaying ? "⏸" : "▶"
                    font.pixelSize: 17
                    font.weight: Font.Bold
                    color: playBtn.containsMouse ? "#ffffff" : "#ffffff"
                    anchors.horizontalCenterOffset: breezeView.isPlaying ? 0 : 1
                }
            }

            // Next
            MouseArea {
                id: nextBtn
                width: 26; height: 26
                implicitWidth: 26; implicitHeight: 26
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: breezeView.nextClicked()

                Rectangle {
                    anchors.fill: parent
                    radius: 5
                    color: nextBtn.containsMouse ? Qt.rgba(1, 1, 1, 0.15) : "transparent"
                }

                Text {
                    anchors.centerIn: parent
                    text: "⏭"
                    font.pixelSize: 16
                    color: nextBtn.containsMouse ? "#ffffff" : "#c5cbd4"
                }
            }
        }

        // 2. Vertical Divider
        Rectangle {
            width: 1
            height: 16
            color: Qt.rgba(1, 1, 1, 0.20)
            Layout.alignment: Qt.AlignVCenter
        }

        // 3. Spotify Logo + Title & Artist (Click to raise Spotify)
        MouseArea {
            id: infoArea
            Layout.alignment: Qt.AlignVCenter
            implicitWidth: contentRow.implicitWidth
            implicitHeight: 24
            Layout.preferredWidth: implicitWidth
            Layout.maximumWidth: breezeView.maxTitleWidth + 140
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            acceptedButtons: Qt.LeftButton | Qt.MiddleButton
            onClicked: function(mouse) {
                if (mouse.button === Qt.MiddleButton) {
                    breezeView.middleClicked()
                } else {
                    breezeView.raiseClicked()
                }
            }

            RowLayout {
                id: contentRow
                anchors.verticalCenter: parent.verticalCenter
                spacing: 6

                // Spotify Brand Icon (crisp, small, exactly 13x13px)
                Image {
                    id: spIcon
                    source: Qt.resolvedUrl("../icons/spotify.svg")
                    width: 13
                    height: 13
                    sourceSize.width: 13
                    sourceSize.height: 13
                    Layout.preferredWidth: 13
                    Layout.preferredHeight: 13
                    Layout.maximumWidth: 13
                    Layout.maximumHeight: 13
                    Layout.alignment: Qt.AlignVCenter
                    fillMode: Image.PreserveAspectFit
                }

                // Title
                Text {
                    id: titleText
                    text: breezeView.title
                    color: infoArea.containsMouse ? spotifyGreen : "#e5e7eb"
                    font.pixelSize: 12
                    font.weight: Font.Medium
                    elide: Text.ElideRight
                    Layout.maximumWidth: breezeView.maxTitleWidth
                }

                // Artist
                Text {
                    id: artistText
                    text: "— " + breezeView.artist
                    color: "#9ca3af"
                    font.pixelSize: 12
                    elide: Text.ElideRight
                    visible: breezeView.showArtist && breezeView.artist !== ""
                    Layout.maximumWidth: 140
                }
            }
        }
    }
}
