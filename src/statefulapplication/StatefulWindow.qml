// SPDX-FileCopyrightText: 2021 Carl Schwan <carlschwan@kde.org>
// SPDX-FileCopyrightText: 2021 Claudio Cambra <claudio.cambra@gmail.com>
//
// SPDX-License-Identifier: LGPL-2.1-or-later

import QtQuick
import QtQuick.Controls as QQC2
import QtQuick.Layouts

import org.kde.lingmoui as LingmoUI
import org.kde.lingmouiaddons.formcard as FormCard
import org.kde.lingmouiaddons.statefulapp as StatefulApp
import org.kde.lingmouiaddons.statefulapp.private as Private
import org.kde.coreaddons as Core

/**
 * @brief StatefulWindow takes care of providing standard functionalities
 * for your application main window.
 *
 * This includes:
 * * Restoration of the window size accross restarts
 * * Handling some of the standard actions defined in your LingmoUIAbstractApplication
 *   (AboutKDE and AboutApp)
 * * A command bar to access all the defined actions
 * * A shortcut editor
 *
 * @code
 * import org.kde.lingmouiaddons.statefulapp as StatefulApp
 * import org.kde.lingmouiaddons.settings as Settings
 *
 * StatefulApp.StatefulWindow {
 *     id: root
 *
 *     windowName: 'Main'
 *     application: MyApplication {
 *         configurationView: Settings.ConfigurationView { ... }
 *     }
 * }
 * @endcode
 *
 * @since LingmoUIAddons 1.4.0
 */
LingmoUI.ApplicationWindow {
    id: root

    /**
     * This property holds the window's name.
     *
     * This needs to be an unique identifier for your application and will be used to store
     * the state of the window in your application config.
     */
    property alias windowName: windowStateSaver.configGroupName

    /**
     * This property holds the AbstractLingmoUIApplication of your application.
     *
     * The default AbstractLingmoUIApplication provides the following actions:
     * * KStandardActions::quit
     * * KStandardActions::keyBindings
     * * "Open Command Bar"
     * * "About App"
     * * "About KDE" (if your application id starts with org.kde.)
     *
     * If you need more actions provide your own AbstractLingmoUIApplication and overwrite
     * AbstractLingmoUIApplication::setupActions.
     *
     * @see AbstractLingmoUIApplication
     */
    property StatefulApp.AbstractLingmoUIApplication application: Private.DefaultLingmoUIApplication

    Private.WindowStateSaver {
        id: windowStateSaver
    }

    Connections {
        target: root.application

        function onOpenKCommandBarAction(): void {
            kcommandbarLoader.active = true;
        }

        function onShortcutsEditorAction(): void {
            const openDialogWindow = pageStack.pushDialogLayer(Qt.createComponent("org.kde.lingmouiaddons.statefulapp.private", 'ShortcutsEditor'), {
                width: root.width,
                model: root.application.shortcutsModel,
            }, {
                width: LingmoUI.Units.gridUnit * 30,
                height: LingmoUI.Units.gridUnit * 30,
                title: i18ndc("lingmoui-addons6", "@title:window", "Shortcuts"),
            });
        }

        function onOpenAboutPage(): void {
            const openDialogWindow = pageStack.pushDialogLayer(Qt.createComponent("org.kde.lingmouiaddons.formcard", "AboutPage"), {
                width: root.width
            }, {
                width: LingmoUI.Units.gridUnit * 30,
                height: LingmoUI.Units.gridUnit * 30,
                title: i18ndc("lingmoui-addons6", "@title:window", "About %1", Core.AboutData.displayName),
            });
            openDialogWindow.Keys.escapePressed.connect(function() {
                openDialogWindow.closeDialog();
            });
        }

        function onOpenAboutKDEPage(): void {
            const openDialogWindow = pageStack.pushDialogLayer(Qt.createComponent("org.kde.lingmouiaddons.formcard", "AboutKDE"), {
                width: root.width
            }, {
                width: LingmoUI.Units.gridUnit * 30,
                height: LingmoUI.Units.gridUnit * 30,
                title: i18ndc("lingmoui-addons6", "@title:window", "About KDE"),
            });
            openDialogWindow.Keys.escapePressed.connect(function() {
                openDialogWindow.closeDialog();
            });
        }
    }

    Loader {
        id: kcommandbarLoader
        active: false
        sourceComponent: Private.KQuickCommandBarPage {
            application: root.application
            onClosed: kcommandbarLoader.active = false
            parent: root.QQC2.Overlay.overlay
        }
        onActiveChanged: if (active) {
            item.open()
        }
    }
}