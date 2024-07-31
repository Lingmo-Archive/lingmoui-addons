/*
 * Copyright 2022 Devin Lin <devin@kde.org>
 * SPDX-License-Identifier: LGPL-2.0-or-later
 */

import QtQuick 2.15
import QtQuick.Controls 2.15 as Controls
import QtQuick.Layouts 1.2
import QtQuick.Layouts 1.15

import org.kde.lingmoui 2.20 as LingmoUI
import org.kde.lingmouiaddons.formcard as MobileForm
import org.kde.lingmouiaddons.delegates 1.0 as Delegates
import org.kde.lingmouiaddons.components 1.0 as Components

LingmoUI.ApplicationWindow {
    id: appwindow

    title: "LingmoUI Addons Delegates Test"

    width: LingmoUI.Settings.isMobile ? 400 : 800
    height: LingmoUI.Settings.isMobile ? 550 : 500

    pageStack {
        defaultColumnWidth: LingmoUI.Units.gridUnit * 35
        initialPage: welcomePageComponent

        globalToolBar {
            style: LingmoUI.ApplicationHeaderStyle.ToolBar;
            showNavigationButtons: LingmoUI.ApplicationHeaderStyle.ShowBackButton;
        }
    }


    // Dummy implementation of ki18n
    function i18nd(context, text) {
        return text;
    }

    function i18ndp(context, text1, text2, number) {
        return number === 1 ? text1 : text2;
    }

    function i18ndc(context, text) {
        return text
    }

    function i18nc(context, text) {
        return text;
    }

    LayoutMirroring.enabled: false

    Component {
        id: roundedItemDelegatePageComponent

        LingmoUI.ScrollablePage {
            title: "RoundedItemDelegate"

            header: Components.Banner {
                text: "Hello"
                visible: true
            }

            ListView {
                model: 50
                delegate: Delegates.RoundedItemDelegate {
                    id: delegate

                    required property int modelData

                    icon.name: "kde"
                    text: "Item " + modelData
                }

                Components.DoubleFloatingButton {
                    anchors {
                        right: parent.right
                        rightMargin: LingmoUI.Units.largeSpacing
                        bottom: parent.bottom
                        bottomMargin: LingmoUI.Units.largeSpacing
                    }

                    leadingAction: LingmoUI.Action {
                        text: "Hello"
                        icon.name: "list-add"
                    }

                    trailingAction: LingmoUI.Action {
                        text: "Hello"
                        icon.name: "list-add"
                    }
                }
            }
        }
    }

    Component {
        id: subtitleRoundedItemDelegatePageComponent

        LingmoUI.ScrollablePage {
            title: "RoundedItemDelegate with subtitle"

            header: Components.Banner {
                title: "Hello"
                text: "Hello world"
                visible: true
            }

            ListView {
                model: 50

                delegate: Delegates.RoundedItemDelegate {
                    id: delegate

                    required property int modelData

                    icon.name: "kde"
                    text: "Item " + modelData

                    contentItem: Delegates.SubtitleContentItem {
                        itemDelegate: delegate
                        subtitle: "Subtitle " + delegate.modelData
                    }
                }

                Components.FloatingButton {
                    anchors {
                        right: parent.right
                        rightMargin: LingmoUI.Units.largeSpacing
                        bottom: parent.bottom
                        bottomMargin: LingmoUI.Units.largeSpacing
                    }

                    action: LingmoUI.Action {
                        text: "Hello"
                        icon.name: "list-add"
                    }
                }
            }
        }
    }

    Component {
        id: indicatorItemDelegatePageComponent

        LingmoUI.ScrollablePage {
            title: "IndicatorItemDelegate"

            ListView {
                id: listView

                model: 50
                delegate: Delegates.IndicatorItemDelegate {
                    id: delegate

                    required property int modelData

                    unread: Math.random() > 0.3
                    icon.name: "kde"
                    text: "Item " + modelData
                    onClicked: {
                        unread = false;
                        listView.currentIndex = index;
                    }
                }
            }
        }
    }

    Component {
        id: subtitleIndicatorItemDelegatePageComponent

        LingmoUI.ScrollablePage {
            title: "IndicatorItemDelegate with subtitle"

            ListView {
                id: listView

                model: 50
                delegate: Delegates.IndicatorItemDelegate {
                    id: delegate

                    required property int modelData

                    unread: Math.random() > 0.3
                    icon.name: "kde"
                    text: "Item " + modelData
                    onClicked: {
                        unread = false;
                        listView.currentIndex = index;
                    }

                    contentItem: Delegates.SubtitleContentItem {
                        itemDelegate: delegate
                        subtitle: "Subtitle " + delegate.modelData
                    }
                }
            }
        }
    }

    Component {
        id: welcomePageComponent

        LingmoUI.ScrollablePage {
            id: page
            title: "Mobile Form Layout"

            leftPadding: 0
            rightPadding: 0
            topPadding: LingmoUI.Units.gridUnit
            bottomPadding: LingmoUI.Units.gridUnit

            ColumnLayout {
                spacing: 0

                // Form Grid
                MobileForm.FormGridContainer {
                    id: container

                    Layout.fillWidth: true

                    infoCards: [
                        MobileForm.FormGridContainer.InfoCard {
                            title: "RoundedItemDelegate"
                            action: LingmoUI.Action {
                                onTriggered: applicationWindow().pageStack.push(roundedItemDelegatePageComponent);
                            }
                        },
                        MobileForm.FormGridContainer.InfoCard {
                            title: "ReadIndicatorItemDelegate"
                            action: LingmoUI.Action {
                                onTriggered: applicationWindow().pageStack.push(indicatorItemDelegatePageComponent);
                            }
                        },
                        MobileForm.FormGridContainer.InfoCard {
                            title: "RoundedItemDelegate with subtitle"
                            action: LingmoUI.Action {
                                onTriggered: applicationWindow().pageStack.push(subtitleRoundedItemDelegatePageComponent);
                            }
                        },
                        MobileForm.FormGridContainer.InfoCard {
                            title: "ReadIndicatorItemDelegate with subtitle"
                            action: LingmoUI.Action {
                                onTriggered: applicationWindow().pageStack.push(subtitleIndicatorItemDelegatePageComponent);
                            }
                        }
                    ]
                }
            }
        }
    }
}
