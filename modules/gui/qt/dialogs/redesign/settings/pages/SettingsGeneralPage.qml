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
// redesign: Settings > General ("Global Settings", video 17:39-17:43, Figma "Settings - global")
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
        title: qsTr("Instances & Window")

        SettingsRow {
            text: qsTr("Allow only one running instance")
            description: qsTr("Single instance mode: opening new files reuses the active player window")
            keywords: "instance single window running"

            Widgets.RdToggle {
                checked: RdEffects.values[RdEffects.optionKey("one-instance")] !== false
                Accessible.name: qsTr("Allow only one running instance")
                onToggled: RdEffects.setOption("one-instance", checked)
            }
        }

        SettingsRow {
            text: qsTr("Enqueue files in one instance mode")
            description: qsTr("Append opened files to the current queue rather than playing immediately")
            keywords: "enqueue playlist append queue"

            Widgets.RdToggle {
                checked: RdEffects.values[RdEffects.optionKey("playlist-enqueue")] === true
                Accessible.name: qsTr("Enqueue files in one instance mode")
                onToggled: RdEffects.setOption("playlist-enqueue", checked)
            }
        }

        SettingsRow {
            text: qsTr("Pause playback when minimized")
            description: qsTr("Automatically pause video playback when the player window is minimized to the taskbar")
            keywords: "minimize pause background taskbar"

            Widgets.RdToggle {
                checked: RdEffects.values[RdEffects.optionKey("qt-pause-minimized")] === true
                Accessible.name: qsTr("Pause playback when minimized")
                onToggled: RdEffects.setOption("qt-pause-minimized", checked)
            }
        }
    }

    SettingsSection {
        title: qsTr("Privacy & History")

        SettingsRow {
            text: qsTr("Save recently played media items")
            description: qsTr("Keep a history of recently opened audio and video files for quick access")
            keywords: "recent history save privacy items"

            Widgets.RdToggle {
                checked: RdEffects.values[RdEffects.optionKey("save-history")] !== false
                Accessible.name: qsTr("Save recently played media items")
                onToggled: RdEffects.setOption("save-history", checked)
            }
        }
    }
}
