/*
 * Copyright 2022 Devin Lin <devin@kde.org>
 * SPDX-License-Identifier: LGPL-2.0-or-later
 */

import QtQuick 2.15
import QtQuick.Templates 2.15 as T
import QtQuick.Controls 2.15 as Controls
import QtQuick.Layouts 1.15

import org.kde.lingmoui 2.19 as LingmoUI

import "private" as Private

/**
 * @brief A Form delegate that corresponds to a switch.
 *
 * This component is used to create a purely on/off toggle for a single
 * setting.
 *
 * Use the inherited QtQuick.Controls.AbstractButton.text property to define
 * the main text of the button.
 *
 * If you need an on/off/tristate toggle, use a FormCheckDelegate instead.
 *
 * If you need multiple values for the same setting, use a
 * FormComboBoxDelegate instead.
 *
 * If you need multiple toggles for the same setting, use a FormRadioDelegate
 * instead.
 *
 * @since LingmoUIAddons 0.11.0
 *
 * @see QtQuick.Controls.AbstractButton
 * @see FormCheckDelegate
 * @see FormComboBoxDelegate
 * @see FormRadioDelegate
 *
 * @inherit QtQuick.Controls.SwitchDelegate
 */
T.SwitchDelegate {
    id: root

    /**
     * @brief A label containing secondary text that appears under the inherited text property.
     *
     * This provides additional information shown in a faint gray color.
     */
    property string description: ""

    /**
     * @brief This property holds an item that will be displayed
     * to the left of the delegate's contents.
     */
    property var leading: null

    /**
     * @brief This property holds the padding after the leading item.
     */
    property real leadingPadding: LingmoUI.Units.smallSpacing

    /**
     * @brief This property holds an item that will be displayed
     * to the right of the delegate's contents.
     */
    property var trailing: null

    /**
     * @brief This property holds the padding before the trailing item.
     */
    property real trailingPadding: LingmoUI.Units.smallSpacing

    topPadding: LingmoUI.Units.largeSpacing + LingmoUI.Units.smallSpacing
    bottomPadding: LingmoUI.Units.largeSpacing + LingmoUI.Units.smallSpacing
    leftPadding: parent._internal_formcard_margins ? parent._internal_formcard_margins : LingmoUI.Units.gridUnit
    rightPadding: parent._internal_formcard_margins ? parent._internal_formcard_margins : LingmoUI.Units.gridUnit

    implicitWidth: contentItem.implicitWidth + leftPadding + rightPadding
    implicitHeight: contentItem.implicitHeight + topPadding + bottomPadding

    focusPolicy: Qt.StrongFocus
    hoverEnabled: true
    background: FormDelegateBackground { control: root }

    Layout.fillWidth: true

    Accessible.description: root.description
    Accessible.role: Accessible.CheckBox
    Accessible.onPressAction: switchItem.toggle()
    Accessible.onToggleAction: switchItem.toggle()

    contentItem: RowLayout {
        spacing: 0

        Private.ContentItemLoader {
            Layout.rightMargin: visible ? root.leadingPadding : 0
            visible: root.leading
            implicitHeight: visible ? root.leading.implicitHeight : 0
            implicitWidth: visible ? root.leading.implicitWidth : 0
            contentItem: root.leading
        }

        ColumnLayout {
            Layout.fillWidth: true
            spacing: LingmoUI.Units.smallSpacing

            Controls.Label {
                Layout.fillWidth: true
                text: root.text
                elide: Text.ElideRight
                wrapMode: Text.Wrap
                maximumLineCount: 2
                color: root.enabled ? LingmoUI.Theme.textColor : LingmoUI.Theme.disabledTextColor
                Accessible.ignored: true
            }

            Controls.Label {
                visible: root.description !== ""
                Layout.fillWidth: true
                text: root.description
                wrapMode: Text.Wrap
                color: LingmoUI.Theme.disabledTextColor
                Accessible.ignored: true
            }
        }

        Controls.Switch {
            id: switchItem
            focusPolicy: Qt.NoFocus // provided by delegate
            Layout.leftMargin: LingmoUI.Units.largeSpacing + LingmoUI.Units.smallSpacing

            enabled: root.enabled
            checked: root.checked

            onToggled: root.toggled()
            onClicked: root.clicked()
            onPressAndHold: root.pressAndHold()
            onDoubleClicked: root.doubleClicked()

            onCheckedChanged: {
                root.checked = checked;
                checked = Qt.binding(() => root.checked);
            }

            Accessible.ignored: true
        }

        Private.ContentItemLoader {
            Layout.leftMargin: visible ? root.trailingPadding : 0
            visible: root.trailing
            implicitHeight: visible ? root.trailing.implicitHeight : 0
            implicitWidth: visible ? root.trailing.implicitWidth : 0
            contentItem: root.trailing
        }
    }
}
