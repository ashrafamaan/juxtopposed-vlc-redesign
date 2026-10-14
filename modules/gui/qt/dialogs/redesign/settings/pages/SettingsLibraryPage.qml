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
// redesign: Settings > Library ("Playlists, Folders & Files", video 18:15-18:17, Figma "Settings - library")
import QtQuick
import QtQuick.Layouts

import VLC.MainInterface
import VLC.Style
import VLC.MediaLibrary
import VLC.Widgets as Widgets
import VLC.Dialogs

SettingsPage {
    id: root

    SettingsSection {
        title: qsTr("Media Library Indexing")

        SettingsRow {
            text: qsTr("Auto-scan library folders")
            description: qsTr("Periodically monitor and index new videos and audio tracks from added library folders")
            keywords: "scan index medialibrary folders"

            Widgets.RdToggle {
                checked: MainCtx.mediaLibraryAvailable
                Accessible.name: qsTr("Auto-scan library folders")
            }
        }

        SettingsRow {
            text: qsTr("Generate video thumbnails")
            description: qsTr("Extract high-quality video preview cards during background library indexing")
            keywords: "thumbnails preview extract cards"

            Widgets.RdToggle {
                checked: true
                Accessible.name: qsTr("Generate video thumbnails")
            }
        }

        SettingsRow {
            text: qsTr("Add library folder")
            description: qsTr("Select a folder on your computer to scan into Videos or Music")
            keywords: "add folder directory browse"

            Widgets.RdButton {
                text: qsTr("Browse Folder...")
                onClicked: RdLibraryActions.addFolder()
            }
        }
    }
}
