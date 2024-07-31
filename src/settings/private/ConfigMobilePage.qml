/*
 * SPDX-FileCopyrightText: 2011-2014 Sebastian Kügler <sebas@kde.org>
 * SPDX-FileCopyrightText: 2021 Devin Lin <devin@kde.org>
 * SPDX-License-Identifier: GPL-2.0-or-later
*/

import QtQuick
import QtQuick.Layouts
import QtQuick.Controls as Controls
import org.kde.lingmoui as LingmoUI
import org.kde.lingmouiaddons.formcard as FormCard
import org.kde.lingmouiaddons.settings

FormCard.FormCardPage {
    id: root

    required property string defaultModule
    required property list<ConfigurationModule> modules
    required property LingmoUI.ApplicationWindow window

    // Do not use Map, it crashes very frequently
    property var pageCache: Object.create(null)

    title: i18ndc("lingmoui-addons6", "@title", "Settings")

    // search bar
    FormCard.FormCard {
        Layout.fillWidth: true
        Layout.topMargin: LingmoUI.Units.gridUnit

        FormCard.AbstractFormDelegate {
            Layout.fillWidth: true
            background: null

            topPadding: LingmoUI.Units.smallSpacing
            bottomPadding: LingmoUI.Units.smallSpacing

            contentItem: LingmoUI.SearchField {
                id: searchField
                Layout.fillWidth: true
                autoAccept: true
                onTextChanged: repeater.filterText = text.toLowerCase();
                background: null
            }
        }
    }

    Repeater {
        id: repeater

        property string filterText: ""

        model: {
            const isFiltering = filterText.length !== 0;
            let filteredCategories = new Array();

            for (let i in root.modules) {
                const module = modules[i];
                const modulePassesFilter = module.text.toLowerCase().includes(filterText);
                if (module.visible && (isFiltering ? modulePassesFilter : true)) {
                    const category = filteredCategories.find((category) => category.name === module.category);
                    if (category) {
                        category.modules.push(module);
                    } else {
                        filteredCategories.push({
                            name: module.category,
                            modules: [module],
                        });
                    }
                }
            }
            return filteredCategories;
        }

        ColumnLayout {
            id: categoryDelegate

            required property var modelData

            spacing: 0

            FormCard.FormHeader {
                title: categoryDelegate.modelData.name === "_main_category" ? i18ndc("lingmoui-addons6", "@title:group", "Settings") : modelData.name
            }

            // settings categories
            FormCard.FormCard {
                id: settingsCard

                Repeater {
                    id: repeater

                    model: categoryDelegate.modelData.modules
                    delegate: ColumnLayout {
                        id: moduleDelegate

                        required property int index
                        required property ConfigurationModule modelData

                        Layout.fillWidth: true

                        FormCard.FormDelegateSeparator {
                            visible: moduleDelegate.index !== 0
                        }

                        FormCard.AbstractFormDelegate {
                            id: delegateItem

                            onClicked: {
                                root.window.pageStack.layers.push(pageForModule(modelData));
                            }

                            contentItem: RowLayout {
                                LingmoUI.Icon {
                                    source: moduleDelegate.modelData.icon.name
                                    Layout.rightMargin: LingmoUI.Units.largeSpacing
                                    implicitWidth: LingmoUI.Units.iconSizes.medium
                                    implicitHeight: LingmoUI.Units.iconSizes.medium
                                }

                                Controls.Label {
                                    Layout.fillWidth: true
                                    text: moduleDelegate.modelData.text
                                    elide: Text.ElideRight
                                }

                                LingmoUI.Icon {
                                    Layout.alignment: Qt.AlignRight
                                    source: "arrow-right"
                                    implicitWidth: Math.round(LingmoUI.Units.iconSizes.small * 0.75)
                                    implicitHeight: Math.round(LingmoUI.Units.iconSizes.small * 0.75)
                                }
                            }
                        }
                    }
                }
            }

        }
    }

    function pageForModule(module: ConfigurationModule) {
        if (pageCache[module.moduleId]) {
            return pageCache[module.moduleId];
        } else {
            const component = module.page();
            if (component.status === Component.Error) {
                console.error(component.errorString());
            }
            const page = component.createObject(root, module.initialProperties());
            if (page.title.length === 0) {
                page.title = module.text;
            }
            pageCache[module.moduleId] = page;
            return page;
        }
    }

    function getModuleByName(moduleId: string): ConfigurationModule {
        return modules.find(module => module.moduleId == moduleId) ?? null;
    }
}
