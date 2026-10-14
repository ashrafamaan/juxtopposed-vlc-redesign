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
// redesign: Settings > Audio ("Audio Defaults", video 18:06-18:08 and 20:33-20:36, Figma "Settings - audio")
import QtQuick
import QtQuick.Layouts

import VLC.MainInterface
import VLC.Style
import VLC.Player
import VLC.Widgets as Widgets
import VLC.Dialogs

SettingsPage {
    id: root

    readonly property bool _audioEnabled: RdEffects.values[RdEffects.optionKey("audio")] !== false
    readonly property bool _normalize: RdEffects.values[RdEffects.optionKey("audio-filter")]?.includes("normvol") ?? false

    SettingsSection {
        title: qsTr("Output")

        SettingsRow {
            text: qsTr("Enable audio")
            description: RdEffects.optionDescription("audio")
            keywords: "audio enable sound"

            Widgets.RdToggle {
                checked: root._audioEnabled
                Accessible.name: qsTr("Enable audio")
                onToggled: RdEffects.setOption("audio", checked)
            }
        }

        SettingsRow {
            text: qsTr("Speaker setup")
            description: qsTr("Speaker layout and stereo mode")
            keywords: "stereo-mode speakers channels surround"
            available: root._audioEnabled

            Widgets.RdDropdown {
                implicitWidth: VLCStyle.dp(320)
                implicitHeight: VLCStyle.dp(36)
                model: [qsTr("Automatic"), qsTr("Stereo"), qsTr("Headphones"), qsTr("5.1 Surround"), qsTr("7.1 Surround")]
                currentIndex: 0
            }
        }
    }

    SettingsSection {
        title: qsTr("Volume")

        SettingsRow {
            text: qsTr("Maximum volume")
            description: qsTr("Maximum volume percentage allowed in the player controls (100% to 300%)")
            keywords: "volume max limit 200"
            available: root._audioEnabled

            Widgets.RdSlider {
                implicitWidth: VLCStyle.dp(320)
                from: 100
                to: 300
                stepSize: 25
                value: Number(RdEffects.values[RdEffects.optionKey("qt-max-volume")] ?? 200)
                onMoved: RdEffects.setOption("qt-max-volume", Math.round(value))
            }
        }

        SettingsRow {
            text: qsTr("Volume step")
            description: qsTr("Volume percentage change on each scroll wheel tick or hotkey press")
            keywords: "volume step delta"
            available: root._audioEnabled

            Widgets.RdValueBox {
                from: 1
                to: 20
                value: Number(RdEffects.values[RdEffects.optionKey("volume-step")] ?? 5)
                onValueChanged: RdEffects.setOption("volume-step", value)
            }
        }
    }

    SettingsSection {
        title: qsTr("Loudness")

        SettingsRow {
            text: qsTr("Normalize loudness")
            description: qsTr("Keeps audio volume consistent across quiet dialogues and loud explosions")
            keywords: "normvol normalize compressor volume"
            available: root._audioEnabled

            Widgets.RdToggle {
                checked: root._normalize
                Accessible.name: qsTr("Normalize loudness")
                onToggled: {
                    let filters = String(RdEffects.values[RdEffects.optionKey("audio-filter")] ?? "")
                    if (checked && !filters.includes("normvol")) {
                        filters = filters ? filters + ":normvol" : "normvol"
                    } else if (!checked && filters.includes("normvol")) {
                        filters = filters.replace(/:?normvol:?/, "")
                    }
                    RdEffects.setOption("audio-filter", filters)
                }
            }
        }

        SettingsRow {
            text: qsTr("Replay gain")
            description: qsTr("Automatically adjusts track gain using embedded ReplayGain metadata")
            keywords: "replaygain replay gain"
            available: root._audioEnabled

            Widgets.RdDropdown {
                readonly property string mode: String(RdEffects.values[RdEffects.optionKey("audio-replay-gain-mode")] ?? "none")
                implicitWidth: VLCStyle.dp(320)
                implicitHeight: VLCStyle.dp(36)
                model: [qsTr("Off"), qsTr("Track"), qsTr("Album")]
                currentIndex: mode === "track" ? 1 : mode === "album" ? 2 : 0
                onActivated: (index) => {
                    const modes = ["none", "track", "album"]
                    RdEffects.setOption("audio-replay-gain-mode", modes[index])
                }
            }
        }
    }
}
