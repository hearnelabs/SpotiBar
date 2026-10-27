import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

Item {
    id: compactRoot
    Layout.fillHeight: true
    Layout.preferredWidth: (root.widgetStyle === "cachyWave") ? waveView.implicitWidth : breezeView.implicitWidth
    Layout.minimumWidth: 100
    Layout.maximumWidth: 600
    implicitWidth: Layout.preferredWidth
    implicitHeight: Math.min(parent ? parent.height : 30, 30)

    CachyWaveView {
        id: waveView
        anchors.centerIn: parent
        visible: root.widgetStyle === "cachyWave"
        title: root.title
        artist: root.artist
        album: root.album
        isPlaying: root.isPlaying
        showArtist: root.showArtist
        showEqualizer: root.showEqualizer
        maxTitleWidth: root.maxTitleWidth
        onPlayPauseClicked: root.actionPlayPause()
        onPreviousClicked: root.actionPrevious()
        onNextClicked: root.actionNext()
        onRaiseClicked: root.actionRaise()
        onMiddleClicked: root.toggleStyle()
    }

    NativeBreezeView {
        id: breezeView
        anchors.centerIn: parent
        visible: root.widgetStyle === "nativeBreeze"
        title: root.title
        artist: root.artist
        album: root.album
        isPlaying: root.isPlaying
        showArtist: root.showArtist
        maxTitleWidth: root.maxTitleWidth
        onPlayPauseClicked: root.actionPlayPause()
        onPreviousClicked: root.actionPrevious()
        onNextClicked: root.actionNext()
        onRaiseClicked: root.actionRaise()
        onMiddleClicked: root.toggleStyle()
    }

    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.MiddleButton
        cursorShape: Qt.PointingHandCursor
        onClicked: function(mouse) {
            if (mouse.button === Qt.MiddleButton) {
                root.toggleStyle()
            }
        }
    }
}
