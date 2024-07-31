// SPDX-FileCopyrightText: 2023 Carl Schwan <carl@carlschwan.eu>
// SPDX-License-Identifier: LGPL-2.1-only OR LGPL-3.0-only OR LicenseRef-KDE-Accepted-LGPL

import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15 as QQC2
import QtQuick.Templates 2.15 as T
import org.kde.lingmoui 2.20 as LingmoUI

/**
 * Content item which is used by default in the RoundedItemDelegate and IndicatorItemDelegate. Provides a label and an icon.
 *
 * This can be used directly as contentItem or inside a RowLayout if you need to put some content before or after this item.
 *
 * @since LingmoUIAddons 0.10.0
 */
RowLayout {
    id: root

    /**
     * This required property holds the item delegate corresponding to this content item.
     *
     * @since LingmoUIAddons 0.10.0
     */
    required property T.AbstractButton itemDelegate

    /**
     * This property holds the Label containing the text of the item delegate.
     *
     * @since LingmoUIAddons 0.10.1
     */
    readonly property alias labelItem: labelItem

    /**
     * This property holds the LingmoUI.Icon containing the icon of the item delegate.
     *
     * @since LingmoUIAddons 0.10.1
     */
    readonly property alias iconItem: iconItem

    spacing: LingmoUI.Units.smallSpacing

    LingmoUI.Icon {
        id: iconItem

        Layout.alignment: Qt.AlignVCenter
        visible: itemDelegate.icon.name.length > 0 || itemDelegate.icon.source.toString().length > 0
        source: itemDelegate.icon.name.length > 0 ? itemDelegate.icon.name : itemDelegate.icon.source
        Layout.preferredHeight: itemDelegate.icon.width
        Layout.preferredWidth: itemDelegate.icon.height
    }

    QQC2.Label {
        id: labelItem

        leftPadding: itemDelegate.mirrored ? (itemDelegate.indicator ? itemDelegate.indicator.width : 0) + itemDelegate.spacing : 0
        rightPadding: !itemDelegate.mirrored ? (itemDelegate.indicator ? itemDelegate.indicator.width : 0) + itemDelegate.spacing : 0

        text: root.itemDelegate.text
        font: root.itemDelegate.font
        color: root.itemDelegate.enabled ? LingmoUI.Theme.textColor : LingmoUI.Theme.disabledTextColor
        elide: Text.ElideRight
        visible: itemDelegate.text && itemDelegate.display !== QQC2.AbstractButton.IconOnly
        horizontalAlignment: Text.AlignLeft
        verticalAlignment: Text.AlignVCenter
        Layout.alignment: Qt.AlignLeft
        Layout.fillWidth: true

        Accessible.ignored: true
    }
}

