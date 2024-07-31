// Copyright 2023 Carl Schwan <carl@carlschwan.eu>
// SPDX-License-Identifier: LGPL-2.0-or-later

import QtQuick 2.15
import QtQuick.Controls 2.15 as QQC2
import QtQuick.Layouts 1.15
import org.kde.lingmoui 2.20 as LingmoUI
import org.kde.lingmouiaddons.delegates 1.0 as Delegates
import org.kde.lingmouiaddons.components 1.0 as LingmoUIComponents

LingmoUI.Page {

    LingmoUI.PlaceholderMessage {
        text: "This setting is intentionally left blank"
        anchors.centerIn: parent

        LingmoUIComponents.AvatarButton {
            name: "Paul"
            Layout.preferredWidth: LingmoUI.Units.gridUnit * 2
            Layout.preferredHeight: LingmoUI.Units.gridUnit * 2

            onClicked: console.log("Hello")
        }
    }
}
