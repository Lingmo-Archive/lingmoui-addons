// SPDX-FileCopyrightText: 2024 Carl Schwan <carl@carlschwan.eu>
// SPDX-License-Identifier: LGPL-2.1-or-later

import QtQuick
import QtQuick.Controls as QQC2
import QtQuick.Layouts

import org.kde.lingmoui as LingmoUI
import org.kde.lingmouiaddons.components as Components
import org.kde.lingmouiaddons.formcard as FormCard

/**
 * A dialog designed to use FormCard delegates as it's content.
 *
 * \code{.qml}
 * import org.kde.lingmouiaddons.formcard as FormCard
 * import QtQuick.Controls
 *
 * FormCard.FormCardDialog {
 *     title: "Add Thingy"
 *
 *     standardButtons: Dialog.Ok | Dialog.Cancel
 *     FormCard.FormTextFieldDelegate {
 *         label: i18nc("@label:textbox Notebook name", "Name:")
 *     }
 *
 *     FormCard.FormDelegateSeparator {}
 *
 *     FormCard.FormButtonDelegate {
 *         text: i18nc("@action:button", "Color")
 *         icon.name: "color-picker"
 *     }
 *
 *     FormCard.FormDelegateSeparator {}
 *
 *     FormCard.FormButtonDelegate {
 *         text: i18nc("@action:button", "Icon")
 *         icon.name: "preferences-desktop-emoticons"
 *     }
 * }
 * \endcode{}
 *
 * \image html formcarddialog.png
 *
 * \since 1.1.0
 */
QQC2.Dialog {
    id: root

    default property alias content: columnLayout.data

    x: Math.round((parent.width - width) / 2)
    y: Math.round((parent.height - height) / 2)
    z: LingmoUI.OverlayZStacking.z

    background: Components.DialogRoundedBackground {}

    parent: applicationWindow().QQC2.Overlay.overlay

    implicitWidth: Math.min(parent.width - LingmoUI.Units.gridUnit * 2, LingmoUI.Units.gridUnit * 15)

    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             contentHeight + topPadding + bottomPadding
                             + (implicitHeaderHeight > 0 ? implicitHeaderHeight + spacing : 0)
                             + (implicitFooterHeight > 0 ? implicitFooterHeight + spacing : 0))

    modal: true
    focus: true

    padding: 0

    header: LingmoUI.Heading {
        text: root.title
        elide: QQC2.Label.ElideRight
        leftPadding: LingmoUI.Units.largeSpacing + LingmoUI.Units.smallSpacing
        rightPadding: LingmoUI.Units.largeSpacing + LingmoUI.Units.smallSpacing
        topPadding: LingmoUI.Units.largeSpacing + LingmoUI.Units.smallSpacing
        bottomPadding: 0
    }

    contentItem: ColumnLayout {
        id: columnLayout

        spacing: 0
        property int _internal_formcard_margins: LingmoUI.Units.largeSpacing + LingmoUI.Units.smallSpacing
    }

    footer: QQC2.DialogButtonBox {
        leftPadding: LingmoUI.Units.largeSpacing + LingmoUI.Units.smallSpacing
        rightPadding: LingmoUI.Units.largeSpacing + LingmoUI.Units.smallSpacing
        bottomPadding: LingmoUI.Units.largeSpacing + LingmoUI.Units.smallSpacing
        topPadding: LingmoUI.Units.smallSpacing
        spacing: LingmoUI.Units.mediumSpacing

        standardButtons: root.standardButtons
    }
}