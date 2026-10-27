import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

Item {
    id: waveView
    height: Math.min(parent ? parent.height - 4 : 28, 28)
    width: waveRow.implicitWidth + 24
    implicitHeight: 28
    implicitWidth: waveRow.implicitWidth + 24

    // Explicit Properties
    property string title: "No Track"
    property string artist: ""
    property string album: ""
    property bool isPlaying: false
    property bool showArtist: true
    property bool showEqualizer: true
    property int maxTitleWidth: 160

    // Signals
    signal playPauseClicked()
    signal previousClicked()
    signal nextClicked()
    signal raiseClicked()
    signal middleClicked()

    readonly property color cachyGreen: "#00e5a3"
    readonly property color cachyDark: "#17211e"

    // Background Card
    Rectangle {
        id: bgCard
        anchors.fill: parent
        radius: 6
        color: Qt.rgba(23/255, 33/255, 30/255, 0.90)
        border.color: cachyGreen
        border.width: 1

        // Subtle glow border effect when playing
        Rectangle {
            anchors.fill: parent
            anchors.margins: -1
            radius: parent.radius + 1
            color: "transparent"
            border.color: cachyGreen
            border.width: 1
            opacity: 0.35
            visible: waveView.isPlaying
        }
    }

    RowLayout {
        id: waveRow
        anchors.centerIn: parent
        spacing: 8

        // 1. Animated Equalizer Wave
        Row {
            id: eqBars
            Layout.alignment: Qt.AlignVCenter
            spacing: 2
            visible: waveView.showEqualizer

            // Bar 1
            Rectangle {
                width: 3; radius: 1.5
                color: cachyGreen
                anchors.bottom: parent.bottom
                height: waveView.isPlaying ? 8 : 3
                Behavior on height { NumberAnimation { duration: 180 } }
                SequentialAnimation on height {
                    running: waveView.isPlaying && waveView.showEqualizer
                    loops: Animation.Infinite
                    NumberAnimation { to: 14; duration: 320; easing.type: Easing.InOutQuad }
                    NumberAnimation { to: 4; duration: 280; easing.type: Easing.InOutQuad }
                }
            }
            // Bar 2
            Rectangle {
                width: 3; radius: 1.5
                color: cachyGreen
                anchors.bottom: parent.bottom
                height: waveView.isPlaying ? 12 : 3
                Behavior on height { NumberAnimation { duration: 180 } }
                SequentialAnimation on height {
                    running: waveView.isPlaying && waveView.showEqualizer
                    loops: Animation.Infinite
                    NumberAnimation { to: 18; duration: 420; easing.type: Easing.InOutQuad }
                    NumberAnimation { to: 5; duration: 360; easing.type: Easing.InOutQuad }
                }
            }
            // Bar 3
            Rectangle {
                width: 3; radius: 1.5
                color: cachyGreen
                anchors.bottom: parent.bottom
                height: waveView.isPlaying ? 7 : 3
                Behavior on height { NumberAnimation { duration: 180 } }
                SequentialAnimation on height {
                    running: waveView.isPlaying && waveView.showEqualizer
                    loops: Animation.Infinite
                    NumberAnimation { to: 11; duration: 270; easing.type: Easing.InOutQuad }
                    NumberAnimation { to: 4; duration: 310; easing.type: Easing.InOutQuad }
                }
            }
            // Bar 4
            Rectangle {
                width: 3; radius: 1.5
                color: cachyGreen
                anchors.bottom: parent.bottom
                height: waveView.isPlaying ? 10 : 3
                Behavior on height { NumberAnimation { duration: 180 } }
                SequentialAnimation on height {
                    running: waveView.isPlaying && waveView.showEqualizer
                    loops: Animation.Infinite
                    NumberAnimation { to: 15; duration: 380; easing.type: Easing.InOutQuad }
                    NumberAnimation { to: 3; duration: 250; easing.type: Easing.InOutQuad }
                }
            }
        }

        // 2. Song & Artist Info (Click to open Spotify)
        MouseArea {
            id: infoArea
            Layout.alignment: Qt.AlignVCenter
            implicitWidth: infoRow.implicitWidth
            implicitHeight: Math.max(infoRow.implicitHeight, 20)
            Layout.preferredWidth: implicitWidth
            Layout.maximumWidth: waveView.maxTitleWidth + (artistText.visible ? 140 : 0)
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            acceptedButtons: Qt.LeftButton | Qt.MiddleButton
            onClicked: function(mouse) {
                if (mouse.button === Qt.MiddleButton) {
                    waveView.middleClicked()
                } else {
                    waveView.raiseClicked()
                }
            }

            RowLayout {
                id: infoRow
                anchors.verticalCenter: parent.verticalCenter
                spacing: 6

                Text {
                    id: titleText
                    text: waveView.title
                    color: infoArea.containsMouse ? cachyGreen : "#ffffff"
                    font.pixelSize: 12
                    font.weight: Font.DemiBold
                    elide: Text.ElideRight
                    Layout.maximumWidth: waveView.maxTitleWidth
                }

                Text {
                    id: artistText
                    text: waveView.artist
                    color: cachyGreen
                    font.pixelSize: 11
                    font.weight: Font.Medium
                    elide: Text.ElideRight
                    visible: waveView.showArtist && waveView.artist !== ""
                    Layout.maximumWidth: 140
                }
            }
        }

        // 3. Playback Controls (Prev, Play/Pause, Next)
        RowLayout {
            id: ctrlRow
            Layout.alignment: Qt.AlignVCenter
            spacing: 4

            // Previous Button
            MouseArea {
                id: prevBtn
                width: 24; height: 24
                implicitWidth: 24; implicitHeight: 24
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: waveView.previousClicked()

                Rectangle {
                    anchors.fill: parent
                    radius: 12
                    color: prevBtn.containsMouse ? Qt.rgba(1, 1, 1, 0.15) : "transparent"
                }

                Text {
                    anchors.centerIn: parent
                    text: "⏮"
                    font.pixelSize: 14
                    color: prevBtn.containsMouse ? "#ffffff" : "#abb2bf"
                }
            }

            // Play / Pause Glowing Button
            MouseArea {
                id: playBtn
                width: 26; height: 26
                implicitWidth: 26; implicitHeight: 26
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: waveView.playPauseClicked()

                Rectangle {
                    anchors.fill: parent
                    radius: 13
                    color: cachyGreen
                    scale: playBtn.pressed ? 0.90 : (playBtn.containsMouse ? 1.08 : 1.0)
                    Behavior on scale { NumberAnimation { duration: 120 } }

                    // Glowing pulse halo when playing
                    Rectangle {
                        anchors.fill: parent
                        anchors.margins: -2
                        radius: 15
                        color: "transparent"
                        border.color: cachyGreen
                        border.width: 1
                        opacity: waveView.isPlaying ? 0.5 : 0
                        visible: waveView.isPlaying
                    }
                }

                Text {
                    anchors.centerIn: parent
                    text: waveView.isPlaying ? "⏸" : "▶"
                    font.pixelSize: 13
                    font.weight: Font.Bold
                    color: "#0f1418"
                    anchors.horizontalCenterOffset: waveView.isPlaying ? 0 : 1
                }
            }

            // Next Button
            MouseArea {
                id: nextBtn
                width: 24; height: 24
                implicitWidth: 24; implicitHeight: 24
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: waveView.nextClicked()

                Rectangle {
                    anchors.fill: parent
                    radius: 12
                    color: nextBtn.containsMouse ? Qt.rgba(1, 1, 1, 0.15) : "transparent"
                }

                Text {
                    anchors.centerIn: parent
                    text: "⏭"
                    font.pixelSize: 14
                    color: nextBtn.containsMouse ? "#ffffff" : "#abb2bf"
                }
            }
        }
    }
}
