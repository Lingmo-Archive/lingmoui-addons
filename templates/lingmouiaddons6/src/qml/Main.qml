// SPDX-License-Identifier: GPL-2.0-or-later
// SPDX-FileCopyrightText: %{CURRENT_YEAR} %{AUTHOR} <%{EMAIL}>

import QtQuick
import QtQuick.Controls as QQC2
import QtQuick.Layouts

import org.kde.lingmoui as LingmoUI
import org.kde.lingmouiaddons.statefulapp as StatefulApp
import org.kde.lingmouiaddons.formcard as FormCard

import org.kde.%{APPNAMELC}
import org.kde.%{APPNAMELC}.settings as Settings

StatefulApp.StatefulWindow {
    id: root

    property int counter: 0

    title: i18nc("@title:window", "%{APPNAME}")

    windowName: "%{APPNAME}"

    minimumWidth: LingmoUI.Units.gridUnit * 20
    minimumHeight: LingmoUI.Units.gridUnit * 20

    application: %{APPNAME}Application {
        configurationView: Settings.%{APPNAME}ConfigurationView {}
    }

    Connections {
        target: root.application

        function onIncrementCounter(): void {
            root.counter += 1;
        }
    }

    globalDrawer: LingmoUI.GlobalDrawer {
        isMenu: !LingmoUI.Settings.isMobile
        actions: [
            LingmoUI.Action {
                id: incrementCounterAction
                fromQAction: root.application.action("increment_counter")
            },
            LingmoUI.Action {
                separator: true
            },
            LingmoUI.Action {
                fromQAction: root.application.action("options_configure")
            },
            LingmoUI.Action {
                fromQAction: root.application.action("options_configure_keybinding")
            },
            LingmoUI.Action {
                separator: true
            },
            LingmoUI.Action {
                id: aboutAction
                fromQAction: root.application.action("open_about_page")
            },
            LingmoUI.Action {
                fromQAction: root.application.action("open_about_kde_page")
            },
            LingmoUI.Action {
                fromQAction: root.application.action("file_quit")
            }
        ]
    }

    pageStack.initialPage: FormCard.FormCardPage {
        id: page

        title: i18nc("@title", "%{APPNAME}")

        actions: [incrementCounterAction]

        LingmoUI.Icon {
            source: "applications-development"
            implicitWidth: Math.round(LingmoUI.Units.iconSizes.huge * 1.5)
            implicitHeight: Math.round(LingmoUI.Units.iconSizes.huge * 1.5)

            Layout.alignment: Qt.AlignHCenter
            Layout.topMargin: LingmoUI.Units.largeSpacing * 4
        }

        LingmoUI.Heading {
            text: i18nc("@title", "Welcome to %{APPNAME}") + '\n' + i18nc("@info:status", "Counter: %1", root.counter)
            horizontalAlignment: Qt.AlignHCenter

            Layout.topMargin: LingmoUI.Units.largeSpacing
            Layout.fillWidth: true
        }

        FormCard.FormCard {
            Layout.topMargin: LingmoUI.Units.largeSpacing * 4

            FormCard.FormButtonDelegate {
                action: incrementCounterAction
            }

            FormCard.FormDelegateSeparator {}

            FormCard.FormButtonDelegate {
                action: aboutAction
            }
        }
    }
}
