// Copyright 2023 Carl Schwan <carl@carlschwan.eu>
// SPDX-License-Identifier: LGPL-2.0-or-later

import QtQuick 2.15
import QtQuick.Controls 2.15 as QQC2
import QtQuick.Layouts 1.15
import org.kde.lingmoui 2.20 as LingmoUI
import org.kde.lingmouiaddons.delegates 1.0 as Delegates
import org.kde.lingmouiaddons.settings 1.0 as Settings

LingmoUI.ApplicationWindow {
    id: root

    function i18nc(context, text) {
        return text;
    }

    pageStack.initialPage: LingmoUI.Page {
        QQC2.Button {
            text: i18nc("@action:button", "Open settings")
            onClicked: root.pageStack.pushDialogLayer(settings);
        }
    }

    Component {
        id: settings
        Settings.CategorizedSettings {
            actions: [
                Settings.SettingAction {
                    actionName: "general"
                    icon.name: "preferences-desktop-theme-global"
                    text: i18nc("@window:title", "General")
                    page: Qt.resolvedUrl("TestSettingPage.qml#2")
                },
                Settings.SettingAction {
                    actionName: "appearance"
                    icon.name: "preferences-desktop-theme-global"
                    text: i18nc("@window:title", "Appeareance")
                    page: Qt.resolvedUrl("TestSettingPage.qml#1")
                }
            ]
        }
    }
}
