/*****************************************************************************
 * Copyright (C) 2026 VLC authors and VideoLAN
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * ( at your option ) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston MA 02110-1301, USA.
 *****************************************************************************/
// redesign: Settings > Interface ("Interface Settings", video 17:50-17:51, Figma "Settings - interface")
import QtQuick
import QtQuick.Layouts

import VLC.MainInterface
import VLC.Style
import VLC.Player
import VLC.Widgets as Widgets
import VLC.Dialogs

SettingsPage {
    id: root

    SettingsSection {
        title: qsTr("Appearance")

        SettingsRow {
            text: qsTr("Theme")
            description: qsTr("Switch between dark and light appearance modes")
            keywords: "theme dark light mode appearance color"

            Widgets.RdDropdown {
                implicitWidth: VLCStyle.dp(320)
                implicitHeight: VLCStyle.dp(36)
                model: [qsTr("Dark (recommended)"), qsTr("Light")]
                currentIndex: MainCtx.colorScheme.scheme === ColorSchemeModel.Day ? 1 : 0
                onActivated: (index) => {
                    MainCtx.colorScheme.scheme = (index === 1) ? ColorSchemeModel.Day : ColorSchemeModel.Night
                }
            }
        }

        SettingsRow {
            text: qsTr("Accent color")
            description: qsTr("Select primary color used across seek bars, active toggles, and buttons")
            keywords: "accent color orange red teal blue purple"

            Row {
                spacing: VLCStyle.dp(10)

                readonly property var colors: [
                    "#D37918", // Orange (Default)
                    "#E15032", // Red
                    "#C49E23", // Olive
                    "#19A234", // Green
                    "#18AAD3", // Teal
                    "#185DD3", // Blue
                    "#8E42FF", // Purple
                    "#F052B3"  // Pink
                ]

                Repeater {
                    model: parent.colors

                    Rectangle {
                        required property string modelData
                        width: VLCStyle.dp(24)
                        height: VLCStyle.dp(24)
                        radius: width / 2
                        color: modelData
                        border.color: modelData === VLCStyle.palette.rdAccentMain ? "#FFFFFF" : "transparent"
                        border.width: VLCStyle.dp(2)

                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                VLCStyle.palette.customAccentColor = modelData
                            }
                        }
                    }
                }
            }
        }

        SettingsRow {
            text: qsTr("Floating control bar")
            description: qsTr("Controls float over the video with smooth blur and fade")
            keywords: "pin controls float overlay"

            Widgets.RdToggle {
                checked: !MainCtx.pinVideoControls
                Accessible.name: qsTr("Floating control bar")
                onToggled: MainCtx.pinVideoControls = !checked
            }
        }
    }

    SettingsSection {
        title: qsTr("On-Screen Display")

        SettingsRow {
            text: qsTr("Show title on media start")
            description: qsTr("Display title overlay when playback begins")
            keywords: "title osd banner overlay"

            Widgets.RdToggle {
                checked: RdEffects.values[RdEffects.optionKey("video-title-show")] !== false
                Accessible.name: qsTr("Show title on media start")
                onToggled: RdEffects.setOption("video-title-show", checked)
            }
        }

        SettingsRow {
            text: qsTr("Title display timeout")
            description: qsTr("Duration in milliseconds to display the title overlay")
            keywords: "title timeout duration osd"

            Widgets.RdValueBox {
                from: 1000
                to: 10000
                stepSize: 500
                value: Number(RdEffects.values[RdEffects.optionKey("video-title-timeout")] ?? 5000)
                onValueChanged: RdEffects.setOption("video-title-timeout", value)
            }
        }
    }
}
