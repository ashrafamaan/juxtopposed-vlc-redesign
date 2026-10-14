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
// redesign: Settings > Video ("Video Defaults", video 18:02-18:05, Figma "Settings - video")
import QtQuick
import QtQuick.Layouts

import VLC.MainInterface
import VLC.Style
import VLC.Player
import VLC.Widgets as Widgets
import VLC.Dialogs

SettingsPage {
    id: root

    readonly property bool _videoEnabled: RdEffects.values[RdEffects.optionKey("video")] !== false

    SettingsSection {
        title: qsTr("Output")

        SettingsRow {
            text: qsTr("Enable video")
            description: RdEffects.optionDescription("video")
            keywords: "video enable display"

            Widgets.RdToggle {
                checked: root._videoEnabled
                Accessible.name: qsTr("Enable video")
                onToggled: RdEffects.setOption("video", checked)
            }
        }

        SettingsRow {
            text: qsTr("Hardware-accelerated decoding")
            description: qsTr("Uses GPU acceleration to decode high-resolution video streams smoothly")
            keywords: "hw hardware acceleration d3d11 dxva2 gpu"
            available: root._videoEnabled

            Widgets.RdDropdown {
                readonly property string hw: String(RdEffects.values[RdEffects.optionKey("avcodec-hw")] ?? "any")
                implicitWidth: VLCStyle.dp(320)
                implicitHeight: VLCStyle.dp(36)
                model: [qsTr("Automatic"), qsTr("Direct3D 11"), qsTr("DXVA 2.0"), qsTr("Disable")]
                currentIndex: hw === "d3d11va" ? 1 : hw === "dxva2" ? 2 : hw === "none" ? 3 : 0
                onActivated: (index) => {
                    const values = ["any", "d3d11va", "dxva2", "none"]
                    RdEffects.setOption("avcodec-hw", values[index])
                }
            }
        }

        SettingsRow {
            text: qsTr("Deinterlacing")
            description: qsTr("Removes horizontal combing artifacts from broadcast or DVD video")
            keywords: "deinterlace interlace scan"
            available: root._videoEnabled

            Widgets.RdDropdown {
                readonly property int deint: Number(RdEffects.values[RdEffects.optionKey("deinterlace")] ?? -1)
                implicitWidth: VLCStyle.dp(320)
                implicitHeight: VLCStyle.dp(36)
                model: [qsTr("Automatic"), qsTr("On"), qsTr("Off")]
                currentIndex: deint === 1 ? 1 : deint === 0 ? 2 : 0
                onActivated: (index) => {
                    const values = [-1, 1, 0]
                    RdEffects.setOption("deinterlace", values[index])
                }
            }
        }
    }

    SettingsSection {
        title: qsTr("Display")

        SettingsRow {
            text: qsTr("Start in fullscreen")
            description: qsTr("Always launch videos in fullscreen mode")
            keywords: "fullscreen start startup window"
            available: root._videoEnabled

            Widgets.RdToggle {
                checked: RdEffects.values[RdEffects.optionKey("fullscreen")] === true
                Accessible.name: qsTr("Start in fullscreen")
                onToggled: RdEffects.setOption("fullscreen", checked)
            }
        }

        SettingsRow {
            text: qsTr("Default aspect ratio")
            description: qsTr("Default video aspect ratio scaling")
            keywords: "aspect ratio 16:9 4:3"
            available: root._videoEnabled

            Widgets.RdDropdown {
                readonly property string ratio: String(RdEffects.values[RdEffects.optionKey("aspect-ratio")] ?? "")
                implicitWidth: VLCStyle.dp(320)
                implicitHeight: VLCStyle.dp(36)
                model: [qsTr("Default"), qsTr("16:9"), qsTr("4:3"), qsTr("16:10"), qsTr("21:9"), qsTr("1:1")]
                currentIndex: ratio === "16:9" ? 1 : ratio === "4:3" ? 2 : ratio === "16:10" ? 3 : ratio === "21:9" ? 4 : ratio === "1:1" ? 5 : 0
                onActivated: (index) => {
                    const values = ["", "16:9", "4:3", "16:10", "21:9", "1:1"]
                    RdEffects.setOption("aspect-ratio", values[index])
                }
            }
        }
    }

    SettingsSection {
        title: qsTr("Snapshots")

        SettingsRow {
            text: qsTr("Snapshot format")
            description: qsTr("Image format used when capturing video frame snapshots")
            keywords: "snapshot screenshot png jpg format"
            available: root._videoEnabled

            Widgets.RdDropdown {
                readonly property string fmt: String(RdEffects.values[RdEffects.optionKey("snapshot-format")] ?? "png")
                implicitWidth: VLCStyle.dp(320)
                implicitHeight: VLCStyle.dp(36)
                model: [qsTr("PNG (lossless)"), qsTr("JPEG (compressed)")]
                currentIndex: fmt === "jpg" ? 1 : 0
                onActivated: (index) => {
                    RdEffects.setOption("snapshot-format", index === 1 ? "jpg" : "png")
                }
            }
        }

        SettingsRow {
            text: qsTr("Snapshot prefix")
            description: qsTr("File name prefix prepended to captured frame snapshots")
            keywords: "snapshot prefix filename"
            available: root._videoEnabled

            Widgets.RdTextField {
                implicitWidth: VLCStyle.dp(320)
                text: String(RdEffects.values[RdEffects.optionKey("snapshot-prefix")] ?? "vlcsnap-")
                onEditingFinished: RdEffects.setOption("snapshot-prefix", text)
            }
        }
    }
}
