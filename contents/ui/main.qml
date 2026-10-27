import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import org.kde.plasma.plasmoid
import org.kde.plasma.core as PlasmaCore
import org.kde.plasma.plasma5support as P5Support
import org.kde.kirigami as Kirigami

PlasmoidItem {
    id: root

    // ---------------- Sizing for Panel Containment ----------------
    Layout.fillHeight: true
    Layout.preferredWidth: (widgetStyle === "cachyWave") ? waveView.implicitWidth : breezeView.implicitWidth
    Layout.minimumWidth: 100
    Layout.maximumWidth: 600
    implicitWidth: Layout.preferredWidth
    implicitHeight: Math.min(parent ? parent.height : 30, 30)

    // ---------------- Configuration ----------------
    readonly property var conf: Plasmoid.configuration
    readonly property string widgetStyle: (conf && conf.widgetStyle !== undefined) ? conf.widgetStyle : "cachyWave"
    readonly property int maxTitleWidth: (conf && conf.maxTitleWidth !== undefined) ? conf.maxTitleWidth : 160
    readonly property bool showArtist: (conf && conf.showArtist !== undefined) ? conf.showArtist : true
    readonly property bool showEqualizer: (conf && conf.showEqualizer !== undefined) ? conf.showEqualizer : true
    readonly property string playerTarget: (conf && conf.playerTarget !== undefined) ? conf.playerTarget : "spotify"

    // ---------------- MPRIS Media State ----------------
    property string status: "Stopped"
    property string title: "Connecting..."
    property string artist: ""
    property string album: ""
    property string artUrl: ""
    property real position: 0
    property real length: 0
    readonly property bool isPlaying: status === "Playing"

    // ---------------- Script Path ----------------
    readonly property string scriptPath: decodeURIComponent(Qt.resolvedUrl("../scripts/mpris.sh").toString().replace("file://", ""))

    // ---------------- Shell Runner (P5Support) ----------------
    P5Support.DataSource {
        id: exec
        engine: "executable"
        connectedSources: []
        property var cbs: ({})
        onNewData: function(source, data) {
            exec.disconnectSource(source)
            var cb = cbs[source]
            delete cbs[source]
            if (cb) {
                cb((data["stdout"] || "").trim())
            }
        }
        function run(cmd, cb) {
            if (cb) cbs[cmd] = cb
            connectSource(cmd)
        }
    }

    // ---------------- Refresh & Parsing ----------------
    function refresh() {
        exec.run("bash '" + scriptPath + "' get '" + playerTarget + "'", function(out) {
            if (!out) return
            var parts = out.split("|||")
            if (parts.length >= 3) {
                root.status = parts[0] || "Stopped"
                root.title = parts[1] || "No Track"
                root.artist = parts[2] || ""
                root.album = parts[3] || ""
                root.artUrl = parts[4] || ""
                root.position = parseFloat(parts[5]) || 0
                root.length = parseFloat(parts[6]) || 0
            }
        })
    }

    Component.onCompleted: {
        refresh()
    }

    // ---------------- Player Actions ----------------
    function actionPlayPause() {
        root.status = root.isPlaying ? "Paused" : "Playing"
        exec.run("bash '" + scriptPath + "' play-pause '" + playerTarget + "'")
        afterActionTimer.restart()
    }

    function actionPrevious() {
        exec.run("bash '" + scriptPath + "' previous '" + playerTarget + "'")
        afterActionTimer.restart()
    }

    function actionNext() {
        exec.run("bash '" + scriptPath + "' next '" + playerTarget + "'")
        afterActionTimer.restart()
    }

    function actionRaise() {
        exec.run("bash '" + scriptPath + "' raise '" + playerTarget + "'")
    }

    function toggleStyle() {
        var next = (widgetStyle === "cachyWave") ? "nativeBreeze" : "cachyWave"
        Plasmoid.configuration.widgetStyle = next
    }

    // ---------------- Timers ----------------
    Timer {
        id: pollTimer
        interval: 1200
        running: true
        repeat: true
        onTriggered: root.refresh()
    }

    Timer {
        id: afterActionTimer
        interval: 220
        repeat: false
        onTriggered: root.refresh()
    }

    // ---------------- Tooltip ----------------
    toolTipMainText: root.title !== "" ? root.title : "SpotiBar"
    toolTipSubText: {
        var s = ""
        if (root.artist !== "") s += root.artist
        if (root.album !== "") s += (s !== "" ? " • " : "") + root.album
        if (root.status !== "") s += (s !== "" ? "\nStatus: " : "Status: ") + root.status
        s += "\nStyle: " + (root.widgetStyle === "cachyWave" ? "Cachy Cyber Wave" : "Native Breeze")
        s += "\n(Tip: Middle-click to switch style, click title to open Spotify)"
        return s
    }

    // ---------------- Direct Visual Content ----------------
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

    // Middle-click anywhere on widget to toggle styles
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
