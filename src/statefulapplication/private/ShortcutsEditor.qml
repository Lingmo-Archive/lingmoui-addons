// SPDX-FileCopyrightText: 2024 Carl Schwan <carlschwan@kde.org>
// SPDX-License-Identifier: LGPL-2.1-or-later

import QtQuick
import QtQuick.Controls as QQC2
import QtQuick.Layouts

import org.kde.lingmoui as LingmoUI
import org.kde.lingmouiaddons.formcard as FormCard
import org.kde.lingmouiaddons.delegates as Delegates
import org.kde.lingmouiaddons.components as Components

LingmoUI.ScrollablePage {
    id: root

    property alias model: listView.model

    title: i18ndc("lingmoui-addons6", "@title:window", "Shortcuts")

    actions: LingmoUI.Action {
        displayComponent: LingmoUI.SearchField {
            placeholderText: i18ndc("lingmoui-addons6", "@label:textbox", "Filter…")
        }
    }

    ListView {
        id: listView

        delegate: Delegates.RoundedItemDelegate {
            id: shortcutDelegate

            required property int index
            required property string actionName
            required property var shortcut
            required property string shortcutDisplay
            required property string alternateShortcuts

            text: actionName.replace('&', '')

            contentItem: RowLayout {
                QQC2.Label {
                    text: shortcutDelegate.text
                    Layout.fillWidth: true
                }

                QQC2.Label {
                    text: shortcutDelegate.shortcutDisplay
                }
            }

            onClicked: {
                shortcutDialog.title = i18ndc("krigiami-addons6", "@title:window", "Shortcut: %1",  shortcutDelegate.text);
                shortcutDialog.keySequence = shortcutDelegate.shortcut;
                shortcutDialog.index = shortcutDelegate.index;
                shortcutDialog.alternateShortcuts = shortcutDelegate.alternateShortcuts;
                shortcutDialog.open()
            }
        }

        FormCard.FormCardDialog {
            id: shortcutDialog

            property alias keySequence: keySequenceItem.keySequence
            property var alternateShortcuts
            property int index: -1

            parent: root.QQC2.Overlay.overlay

            KeySequenceItem {
                id: keySequenceItem

                label: i18ndc("krigiami-addons6", "@label", "Shortcut:")
                onKeySequenceModified: {
                    root.model.updateShortcut(shortcutDialog.index, 0, keySequence);
                }

                onErrorOccurred: (title, message) => {
                    root.QQC2.ApplicationWindow.showPassiveNotification(title + '\n' + message);
                }

                onShowStealStandardShortcutDialog: (title, message, sequence) => {
                    stealStandardShortcutDialog.title = title
                    stealStandardShortcutDialog.message = message;
                    stealStandardShortcutDialog.sequence = sequence;
                    stealStandardShortcutDialog.parent = root.QQC2.Overlay.overlay;
                    stealStandardShortcutDialog.sequenceItem = this;
                    stealStandardShortcutDialog.openDialog();
                }
            }

            Components.MessageDialog {
                id: stealStandardShortcutDialog

                property string message
                property var sequence
                property KeySequenceItem sequenceItem

                dialogType: Components.MessageDialog.Warning
                dontShowAgainName: "stealStandardShortcutDialog"

                QQC2.Label {
                    text: stealStandardShortcutDialog.message
                    Layout.fillWidth: true
                    wrapMode: Text.WordWrap
                }

                standardButtons: LingmoUI.PromptDialog.Apply | LingmoUI.PromptDialog.Cancel

                onApplied: {
                    sequenceItem.stealStandardShortcut(sequence);
                    close();
                }

                onRejected: close()
            }

            Repeater {
                id: alternateRepeater

                model: shortcutDialog.alternateShortcuts
                KeySequenceItem {
                    id: alternateKeySequenceItem

                    required property int index
                    required property var modelData

                    label: index === 0 ? i18ndc("krigiami-addons6", "@label", "Alternative:") : ''

                    keySequence: modelData
                    onKeySequenceModified: {
                        const alternates = root.model.updateShortcut(shortcutDialog.index, index + 1, keySequence);
                        if (alternates !== shortcutDialog.alternateShortcuts) {
                            shortcutDialog.alternateShortcuts = alternates;
                        }
                    }

                    onErrorOccurred: (title, message) => {
                        root.QQC2.ApplicationWindow.showPassiveNotification(title + '\n' + message);
                    }

                    onShowStealStandardShortcutDialog: (title, message, sequence) => {
                        stealStandardShortcutDialog.title = title
                        stealStandardShortcutDialog.message = message;
                        stealStandardShortcutDialog.sequence = sequence;
                        stealStandardShortcutDialog.parent = root.QQC2.Overlay.overlay;
                        stealStandardShortcutDialog.sequenceItem = this;
                        stealStandardShortcutDialog.openDialog();
                    }
                }
            }

            KeySequenceItem {
                id: alternateKeySequenceItem

                label: alternateRepeater.count === 0 ? i18ndc("krigiami-addons6", "@label", "Alternative:") : ''

                onKeySequenceModified: {
                    shortcutDialog.alternateShortcuts = root.model.updateShortcut(shortcutDialog.index, alternateRepeater.count + 1, keySequence);
                    keySequence = root.model.emptyKeySequence();
                }

                onErrorOccurred: (title, message) => {
                    root.QQC2.ApplicationWindow.showPassiveNotification(title + '\n' + message);
                }

                onShowStealStandardShortcutDialog: (title, message, sequence) => {
                    stealStandardShortcutDialog.title = title
                    stealStandardShortcutDialog.message = message;
                    stealStandardShortcutDialog.sequence = sequence;
                    stealStandardShortcutDialog.parent = root.QQC2.Overlay.overlay;
                    stealStandardShortcutDialog.sequenceItem = this;
                    stealStandardShortcutDialog.openDialog();
                }
            }

            footer: RowLayout {
                QQC2.DialogButtonBox {
                    Layout.fillWidth: true
                    standardButtons: QQC2.DialogButtonBox.Close | QQC2.DialogButtonBox.Reset
                    onRejected: shortcutDialog.close();
                    onReset: shortcutDialog.alternateShortcuts = root.model.reset(shortcutDialog.index)
                    leftPadding: LingmoUI.Units.largeSpacing + LingmoUI.Units.smallSpacing
                    topPadding: LingmoUI.Units.smallSpacing
                    rightPadding: LingmoUI.Units.largeSpacing + LingmoUI.Units.smallSpacing
                    bottomPadding: LingmoUI.Units.largeSpacing + LingmoUI.Units.smallSpacing
                }
            }
        }

        LingmoUI.PlaceholderMessage {
            width: parent.width - LingmoUI.Units.gridUnit * 4
            anchors.centerIn: parent
            text: i18ndc("lingmoui-addons6", "Placeholder message", "No shortcuts found")
            visible: listView.count === 0
        }
    }

    footer: QQC2.ToolBar {
        padding: 0

        contentItem: QQC2.DialogButtonBox {
            padding: LingmoUI.Units.largeSpacing
            standardButtons: QQC2.Dialog.Save | QQC2.Dialog.Reset

            onAccepted: {
                root.model.save()
                root.closeDialog();
            }
            onReset: root.model.resetAll()
        }
    }
}