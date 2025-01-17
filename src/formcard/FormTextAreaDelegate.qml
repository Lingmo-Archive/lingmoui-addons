/*
 * Copyright 2022 Carl Schwan <carl@carlschwan.eu>
 * SPDX-License-Identifier: LGPL-2.0-or-later
 */

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import org.kde.lingmoui as LingmoUI

/**
 * @brief A Form delegate that corresponds to a text area.
 *
 * ```qml
 *
 * FormCard.FormHeader {
 *     title: "Information"
 * }
 *
 * FormCard.FormCard {
 *     FormCard.FormTextAreaDelegate {
 *         label: "Account name"
 *     }
 * }
 * ```
 *
 * @since LingmoUIAddons 0.11.0
 *
 * @inherit AbstractFormDelegate
 */
AbstractFormDelegate {
    id: root

    /**
     * @brief A label containing primary text that appears above and
     * to the left the text field.
     */
    required property string label

    /**
     * @brief set the maximum length of the text inside the TextArea if maxLength > 0
     */
    property int maximumLength: -1

    /**
     * @brief This hold the activeFocus state of the internal TextArea.
    */
    property alias fieldActiveFocus: textArea.activeFocus

    /**
     * @brief This hold the `readOnly` state of the internal TextArea.
     */
    property alias readOnly: textArea.readOnly

    /**
     * @brief This property holds the `inputMethodHints` of the
     * internal TextArea.
     *
     * This consists of hints on the expected content or behavior of
     * the text field, be it sensitive data, in a date format, or whether
     * the characters will be hidden, for example.
     *
     * @see <a href="https://doc.qt.io/qt-6/qml-qtquick-textinput.html#inputMethodHints-prop">TextInput.inputMethodHints</a>
     */
    property alias inputMethodHints: textArea.inputMethodHints

    /**
     * @brief This property holds the `placeholderText` of the
     * internal TextArea.
     *
     * This consists of secondary text shown by default on the text field
     * if no text has been written in it.
     */
    property alias placeholderText: textArea.placeholderText

    /**
     * @brief This property holds the current status message type of
     * the text field.
     *
     * This consists of an inline message with a colorful background
     * and an appropriate icon.
     *
     * The status property will affect the color of ::statusMessage used.
     *
     * Accepted values:
     * - `LingmoUI.MessageType.Information` (blue color)
     * - `LingmoUI.MessageType.Positive` (green color)
     * - `LingmoUI.MessageType.Warning` (orange color)
     * - `LingmoUI.MessageType.Error` (red color)
     *
     * default: `LingmoUI.MessageType.Information` if ::statusMessage is set,
     * nothing otherwise.
     *
     * @see LingmoUI.MessageType
     */
    property var status: LingmoUI.MessageType.Information

    /**
     * @brief This property holds the current status message of
     * the text field.
     *
     * If this property is not set, no ::status will be shown.
     */
    property string statusMessage: ""

    /**
     * @brief This signal is emitted when the Return or Enter key is pressed
     * or the text input loses focus.
     *
     * Note that if there is a validator or inputMask set on the text input
     * and enter/return is pressed, this signal will only be emitted if
     * the input follows the inputMask and the validator returns an
     * acceptable state.
     */
    signal editingFinished();

    /**
     * @brief Clears the contents of the text input and resets partial
     * text input from an input method.
     */
    function clear() {
        textArea.clear();
    }

    /**
     * Inserts text into the TextInput at position.
     */
    function insert(position: int, text: string): void {
        textArea.insert(position, text);
    }

    onActiveFocusChanged: { // propagate focus to the text field
        if (activeFocus) {
            textArea.forceActiveFocus();
        }
    }

    onClicked: textArea.forceActiveFocus()
    background: null
    Accessible.role: Accessible.EditableText

    contentItem: ColumnLayout {
        spacing: LingmoUI.Units.smallSpacing

        RowLayout {
            spacing: LingmoUI.Units.largeSpacing

            Label {
                text: label
                elide: Text.ElideRight
                color: root.enabled ? LingmoUI.Theme.textColor : LingmoUI.Theme.disabledTextColor
                wrapMode: Text.Wrap
                maximumLineCount: 2

                Accessible.ignored: true
                Layout.fillWidth: true
            }

            Label {
                TextMetrics {
                    id: metrics

                    text: label(root.maximumLength, root.maximumLength)
                    font: LingmoUI.Theme.smallFont

                    function label(current: int, maximum: int): string {
                        return i18nc("@label %1 is current text length, %2 is maximum length of text field", "%1/%2", current, maximum)
                    }
                }
                visible:root.maximumLength != -1
                text: metrics.label(textArea.text.length, root.maximumLength)
                font: LingmoUI.Theme.smallFont
                color: textArea.text.length === root.maximumLength
                    ? LingmoUI.Theme.neutralTextColor
                    : LingmoUI.Theme.textColor
                horizontalAlignment: Text.AlignRight

                Layout.margins: LingmoUI.Units.smallSpacing
                Layout.preferredWidth: metrics.advanceWidth
            }
        }

        TextArea {
            id: textArea

            placeholderText: root.placeholderText
            text: root.text
            onTextChanged: root.text = text
            onEditingFinished: root.editingFinished()
            activeFocusOnTab: false
            wrapMode: TextEdit.Wrap

            Accessible.name: root.label
            Layout.fillWidth: true
        }

        LingmoUI.InlineMessage {
            id: formErrorHandler

            visible: root.statusMessage.length > 0
            text: root.statusMessage
            type: root.status

            Layout.topMargin: visible ? LingmoUI.Units.smallSpacing : 0
            Layout.fillWidth: true
        }
    }
}

