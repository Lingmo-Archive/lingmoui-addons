// SPDX-FileCopyrightText: 2021 Carl Schwan <carl@carlschwan.eu>
// SPDX-License-Identifier: LGPL-2.1-only OR LGPL-3.0-only OR LicenseRef-KDE-Accepted-LGPL

import QtQuick
import QtQuick.Controls as QQC2
import QtQuick.Layouts
import org.kde.lingmoui as LingmoUI
import org.kde.lingmouiaddons.delegates as Delegates
import org.kde.lingmouiaddons.components as Components
import org.kde.lingmouiaddons.statefulapp as StatefulApp
import QtQuick.Templates as T

LingmoUI.SearchDialog {
    id: root

    required property StatefulApp.AbstractLingmoUIApplication application

    background: Components.DialogRoundedBackground {}

    onTextChanged: root.application.actionsModel.filterString = text

    model: root.application.actionsModel
    delegate: Delegates.RoundedItemDelegate {
        id: commandDelegate

        required property int index
        required property string decoration
        required property string displayName
        required property string shortcut
        required property var qaction

        icon.name: decoration
        text: displayName

        contentItem: RowLayout {
            spacing: LingmoUI.Units.smallSpacing

            Delegates.DefaultContentItem {
                itemDelegate: commandDelegate
                Layout.fillWidth: true
            }

            QQC2.Label {
                text: commandDelegate.shortcut
                color: LingmoUI.Theme.disabledTextColor
            }
        }

        onClicked: {
            qaction.trigger()
            root.close()
        }
    }

    emptyText: i18ndc("lingmoui-addons6", "@info:placeholder", "No results found")
}
