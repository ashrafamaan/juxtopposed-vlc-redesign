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
// redesign: Settings > Playback ("Playback Preferences", video 17:59-18:01, Figma "Settings - playback")
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
        title: qsTr("Playback Behavior")

        SettingsRow {
            text: qsTr("Resume playback position")
            description: qsTr("Remember playback position and offer to resume when reopening previously played videos")
            keywords: "resume position remember continue"

            Widgets.RdDropdown {
                readonly property int resumeMode: Number(RdEffects.values[RdEffects.optionKey("qt-continue")] ?? 1)
                implicitWidth: VLCStyle.dp(320)
                implicitHeight: VLCStyle.dp(36)
                model: [qsTr("Never"), qsTr("Ask (toast notification)"), qsTr("Always resume automatically")]
                currentIndex: Math.max(0, Math.min(2, resumeMode))
                onActivated: (index) => {
                    RdEffects.setOption("qt-continue", index)
                }
            }
        }

        SettingsRow {
            text: qsTr("Default playback speed")
            description: qsTr("Initial speed rate for audio and video media playback")
            keywords: "speed rate rate-default playback"

            Widgets.RdDropdown {
                readonly property real rate: Number(RdEffects.values[RdEffects.optionKey("rate")] ?? 1.0)
                implicitWidth: VLCStyle.dp(320)
                implicitHeight: VLCStyle.dp(36)
                model: ["0.5x", "0.75x", "1.0x (normal)", "1.25x", "1.5x", "1.75x", "2.0x"]
                currentIndex: rate === 0.5 ? 0 : rate === 0.75 ? 1 : rate === 1.25 ? 3 : rate === 1.5 ? 4 : rate === 1.75 ? 5 : rate === 2.0 ? 6 : 2
                onActivated: (index) => {
                    const rates = [0.5, 0.75, 1.0, 1.25, 1.5, 1.75, 2.0]
                    RdEffects.setOption("rate", rates[index])
                }
            }
        }
    }

    SettingsSection {
        title: qsTr("Caching & Buffering")

        SettingsRow {
            text: qsTr("File buffer cache (ms)")
            description: qsTr("Buffer duration in milliseconds for local disk file playback")
            keywords: "cache buffer latency disk file"

            Widgets.RdValueBox {
                from: 100
                to: 5000
                stepSize: 100
                value: Number(RdEffects.values[RdEffects.optionKey("file-caching")] ?? 1000)
                onValueChanged: RdEffects.setOption("file-caching", value)
            }
        }

        SettingsRow {
            text: qsTr("Network stream cache (ms)")
            description: qsTr("Buffer duration in milliseconds for online HTTP, HLS, or RTSP streaming")
            keywords: "network cache stream buffer latency"

            Widgets.RdValueBox {
                from: 300
                to: 10000
                stepSize: 500
                value: Number(RdEffects.values[RdEffects.optionKey("network-caching")] ?? 1500)
                onValueChanged: RdEffects.setOption("network-caching", value)
            }
        }
    }
}
