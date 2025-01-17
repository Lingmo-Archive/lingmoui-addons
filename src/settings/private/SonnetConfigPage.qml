// SPDX-FileCopyrightText: 2021 Carl Schwan <carlschwan@kde.org>
// SPDX-License-Identifier: LGPL-2.1-or-later

import QtQml
import QtQuick
import QtQuick.Controls as QQC2
import QtQuick.Layouts
import org.kde.lingmoui as LingmoUI
import org.kde.lingmoui.delegates as LingmoUIDelegates
import org.kde.sonnet as Sonnet
import org.kde.lingmouiaddons.formcard as FormCard
import org.kde.lingmouiaddons.delegates as Delegates

FormCard.FormCardPage {
    id: root

    readonly property Sonnet.Settings settings: Sonnet.Settings {
        id: settings
    }

    readonly property LingmoUI.PageRow pageStack: QQC2.ApplicationWindow.window.pageStack

    function add(word: string): void {
        const dictionary = root.settings.currentIgnoreList;
        dictionary.push(word);
        root.settings.currentIgnoreList = dictionary;
    }

    function remove(word: string): void {
        root.settings.currentIgnoreList = root.settings.currentIgnoreList.filter((value, _, _) => {
            return value !== word;
        });
    }

    FormCard.FormCard {
        Layout.topMargin: LingmoUI.Units.largeSpacing * 2

        FormCard.FormCheckDelegate {
            id: enable
            checked: root.settings.checkerEnabledByDefault
            text: i18ndc("lingmoui-addons6", "@label:checkbox", "Enable automatic spell checking")
            onCheckedChanged: {
                root.settings.checkerEnabledByDefault = checked;
                root.settings.save();
            }
        }

        FormCard.FormDelegateSeparator {
            below: enable; above: skipUppercase
        }

        FormCard.FormCheckDelegate {
            id: skipUppercase
            checked: root.settings.skipUppercase
            text: i18ndc("lingmoui-addons6", "@label:checkbox", "Ignore uppercase words")
            onCheckedChanged: {
                root.settings.skipUppercase = checked;
                root.settings.save();
            }
        }

        FormCard.FormDelegateSeparator {
            below: skipUppercase; above: skipRunTogether
        }

        FormCard.FormCheckDelegate {
            id: skipRunTogether
            checked: root.settings.skipRunTogether
            text: i18ndc("lingmoui-addons6", "@label:checkbox", "Ignore hyphenated words")
            onCheckedChanged: {
                root.settings.skipRunTogether = checked;
                root.settings.save();
            }
        }

        FormCard.FormDelegateSeparator {
            below: skipRunTogether; above: autodetectLanguageCheckbox
        }

        FormCard.FormCheckDelegate {
            id: autodetectLanguageCheckbox
            checked: root.settings.autodetectLanguage
            text: i18ndc("lingmoui-addons6", "@label:checkbox", "Detect language automatically")
            onCheckedChanged: {
                root.settings.autodetectLanguage = checked;
                root.settings.save();
            }
        }

        FormCard.FormDelegateSeparator {
            below: autodetectLanguageCheckbox; above: selectedDefaultLanguage
        }

        FormCard.FormComboBoxDelegate {
            id: selectedDefaultLanguage
            text: i18ndc("lingmoui-addons6", "@label:listbox", "Selected default language:")
            model: isEmpty ? [{"display": i18ndc("lingmoui-addons6", "No selected language", "None")}] : root.settings.dictionaryModel
            textRole: "display"
            valueRole: "languageCode"
            property bool isEmpty: false
            Component.onCompleted: {
                if (root.settings.dictionaryModel.rowCount() === 0) {
                    isEmpty = true;
                } else {
                    currentIndex = indexOfValue(root.settings.defaultLanguage);
                }
            }
            onActivated: root.settings.defaultLanguage = currentValue;
        }

        FormCard.FormDelegateSeparator {
            below: selectedDefaultLanguage; above: spellCheckingLanguage
        }

        FormCard.FormButtonDelegate {
            id: spellCheckingLanguage
            text: i18ndc("lingmoui-addons6", "@label:listbox", "Additional Spell Checking Languages")
            description: i18nd("lingmoui-addons6", "%1 will provide spell checking and suggestions for the languages listed here when autodetection is enabled.", Qt.application.displayName)
            onClicked: root.pageStack.pushDialogLayer(spellCheckingLanguageList, {}, {
                width: root.pageStack.width - LingmoUI.Units.gridUnit * 5,
                height: root.pageStack.height - LingmoUI.Units.gridUnit * 5,
            })
        }

        FormCard.FormDelegateSeparator {
            below: spellCheckingLanguage; above: personalDictionary
        }

        FormCard.FormButtonDelegate {
            id: personalDictionary
            text: i18ndc("lingmoui-addons6", "@action:button", "Open Personal Dictionary")
            onClicked: root.pageStack.pushDialogLayer(dictionaryPage, {}, {
                width: root.pageStack.width - LingmoUI.Units.gridUnit * 5,
                height: root.pageStack.height - LingmoUI.Units.gridUnit * 5,
            })
        }

        data: [
            Component {
                id: spellCheckingLanguageList
                LingmoUI.ScrollablePage {
                    id: scroll
                    title: i18ndc("lingmoui-addons6", "@title:window", "Spell checking languages")
                    enabled: autodetectLanguageCheckbox.checked
                    ListView {
                        clip: true
                        model: root.settings.dictionaryModel
                        delegate: LingmoUIDelegates.CheckSubtitleDelegate {
                            width: ListView.view.width

                            text: model.display
                            action: LingmoUI.Action {
                                onTriggered: model.checked = checked
                            }
                            Accessible.description: model.isDefault ? i18nd("lingmoui-addons6", "Default Language") : ''
                            checked: model.checked

                            icon.source: model.isDefault ? "favorite" : undefined
                        }
                    }
                }
            },

            Component {
                id: dictionaryPage
                LingmoUI.ScrollablePage {
                    title: i18ndc("lingmoui-addons6", "@title:window", "Spell checking dictionary")
                    footer: QQC2.ToolBar {
                        contentItem: RowLayout {
                            QQC2.TextField {
                                id: dictionaryField
                                Layout.fillWidth: true
                                Accessible.name: placeholderText
                                placeholderText: i18ndc("lingmoui-addons6", "Placeholder message", "Add a new word to your personal dictionary…")
                            }
                            QQC2.Button {
                                text: i18ndc("lingmoui-addons6", "@action:button", "Add Word")
                                icon.name: "list-add"
                                enabled: dictionaryField.text.length > 0
                                onClicked: {
                                    root.add(dictionaryField.text);
                                    dictionaryField.clear();
                                    if (instantApply) {
                                        root.settings.save();
                                    }
                                }
                                Layout.rightMargin: LingmoUI.Units.largeSpacing
                            }
                        }
                    }
                    ListView {
                        topMargin: Math.round(LingmoUI.Units.smallSpacing / 2)
                        bottomMargin: Math.round(LingmoUI.Units.smallSpacing / 2)

                        model: root.settings.currentIgnoreList
                        delegate: Delegates.RoundedItemDelegate {
                            id: wordDelegate

                            required property string modelData

                            text: modelData

                            contentItem: RowLayout {
                                spacing: LingmoUI.Units.smallSpacing

                                Delegates.DefaultContentItem {
                                    itemDelegate: wordDelegate
                                    Layout.fillWidth: true
                                }

                                QQC2.ToolButton {
                                    text: i18ndc("lingmoui-addons6", "@action:button", "Delete word")
                                    icon.name: "delete"
                                    display: QQC2.ToolButton.IconOnly
                                    onClicked: {
                                        root.remove(wordDelegate.modelData);
                                        if (instantApply) {
                                            root.settings.save();
                                        }
                                    }

                                    QQC2.ToolTip.text: text
                                    QQC2.ToolTip.visible: hovered
                                    QQC2.ToolTip.delay: LingmoUI.ToolTip.toolTipDelay
                                }
                            }
                        }
                    }
                }
            }
        ]
    }
}