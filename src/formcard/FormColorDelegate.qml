// SPDX-FileCopyrightText: 2024 Carl Schwan <carl@carlschwan.eu>
// SPDX-License-Identifier: LGPL-2.0-only OR LGPL-3.0-only OR LicenseRef-KDE-Accepted-LGPL

import QtQuick
import QtQuick.Controls as Controls
import QtQuick.Layouts
import Qt.labs.platform

import org.kde.lingmouiaddons.formcard as FormCard
import org.kde.lingmoui as LingmoUI

/**
 * @brief A FormCard delegate for colors.
 *
 * Allow users to select colors. By default "Color" is the default label
 * but this can be overwritten with the `text` property.
 *
 * @code{qml}
 * FormCard.FormCard {
 *     FormCard.FormColorDelegate {
 *         color: "blue"
 *     }
 *
 *     FormCard.FormDelegateSeparator {}
 *
 *     FormCard.FormColorDelegate {
 *         text: i18nc("@label", "Active color")
 *         color: "blue"
 *     }
 * }
 * @endcode
 * @image html formcardcolor.png
 */
FormCard.AbstractFormDelegate {
    id: root

    property color color: "transparent"

    icon.name: "color-picker"
    onClicked: colorDialog.open()

    text: i18ndc("lingmoui-addons6", "@action:button", "Color")
    Accessible.description: i18ndc("lingmoui-addons6", "Accessible description", "Current color \"%1\"", color)

    contentItem: RowLayout {
        spacing: 0

        LingmoUI.Icon {
            source: "color-picker"
            Layout.rightMargin: LingmoUI.Units.largeSpacing + LingmoUI.Units.smallSpacing
            implicitWidth: LingmoUI.Units.iconSizes.small
            implicitHeight: LingmoUI.Units.iconSizes.small
        }

        Controls.Label {
            Layout.fillWidth: true
            text: root.text
            elide: Text.ElideRight
            wrapMode: Text.Wrap
            maximumLineCount: 2
            Accessible.ignored: true // base class sets this text on root already
        }

        Rectangle {
            id: colorRect
            radius: height
            color: root.color
            Layout.preferredWidth: LingmoUI.Units.iconSizes.small
            Layout.preferredHeight: LingmoUI.Units.iconSizes.small
            Layout.rightMargin: LingmoUI.Units.largeSpacing + LingmoUI.Units.smallSpacing
        }

        FormCard.FormArrow {
            Layout.leftMargin: LingmoUI.Units.smallSpacing
            Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
            direction: Qt.RightArrow
            visible: root.background.visible
        }
    }


    ColorDialog {
        id: colorDialog
        onAccepted: {
            root.color = colorDialog.color;
        }
    }
}