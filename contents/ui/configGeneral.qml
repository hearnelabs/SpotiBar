import QtQuick
import QtQuick.Controls as QQC2
import QtQuick.Layouts
import org.kde.kirigami as Kirigami
import org.kde.kcmutils as KCMUtils

KCMUtils.SimpleKCM {
    id: page

    property string cfg_widgetStyle
    property int cfg_maxTitleWidth
    property bool cfg_showArtist
    property bool cfg_showEqualizer

    Kirigami.FormLayout {
        QQC2.ComboBox {
            Kirigami.FormData.label: i18n("Widget Style:")
            id: styleCombo
            model: [
                { text: i18n("Cachy Cyber Wave (Default - Emerald Accent & Equalizer)"), value: "cachyWave" },
                { text: i18n("Native Plasma Breeze (Minimalist Monochrome - Zero Container)"), value: "nativeBreeze" }
            ]
            textRole: "text"
            valueRole: "value"
            Component.onCompleted: {
                currentIndex = (cfg_widgetStyle === "nativeBreeze") ? 1 : 0
            }
            onActivated: {
                cfg_widgetStyle = currentValue
            }
        }

        QQC2.SpinBox {
            Kirigami.FormData.label: i18n("Max Title Width (px):")
            from: 80
            to: 500
            stepSize: 10
            value: cfg_maxTitleWidth
            onValueModified: {
                cfg_maxTitleWidth = value
            }
        }

        QQC2.CheckBox {
            Kirigami.FormData.label: i18n("Artist Info:")
            text: i18n("Show artist name next to song title")
            checked: cfg_showArtist
            onToggled: {
                cfg_showArtist = checked
            }
        }

        QQC2.CheckBox {
            Kirigami.FormData.label: i18n("Visualizer:")
            text: i18n("Show animated equalizer bars in Cachy Wave mode")
            checked: cfg_showEqualizer
            onToggled: {
                cfg_showEqualizer = checked
            }
        }

        Kirigami.Separator {
            Kirigami.FormData.isSection: true
            Kirigami.FormData.label: i18n("Shortcuts & Tips")
        }

        QQC2.Label {
            text: i18n("• Middle-click on the widget in your panel at any time to instantly toggle between Cachy Wave and Native Breeze.\n• Click on the song title or artist to bring Spotify to the front.")
            wrapMode: Text.WordWrap
            color: Kirigami.Theme.disabledTextColor
            font.pixelSize: 11
        }
    }
}
