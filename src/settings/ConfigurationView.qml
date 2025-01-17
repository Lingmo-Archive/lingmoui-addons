// SPDX-FileCopyrightText: 2024 Carl Schwan <carl@carlschwan.eu>
// SPDX-License-Identifier: LGPL-2.1-only OR LGPL-3.0-only OR LicenseRef-KDE-Accepted-LGPL

import QtQuick
import QtQml
import org.kde.lingmoui as LingmoUI
import org.kde.lingmouiaddons.settings.private as Private

/**
 * This is an abstract view to display the configuration of an application.
 *
 * The various configuration modules can be defined by providing ConfigurationModule
 * to the modules property.
 *
 * On desktop, this will display the modules in a list view and displaying
 * the actual page next to it. On mobile, only the list of modules will be
 * initially displayed.
 *
 * @code
 * import QtQuick.Controls as Controls
 * import org.kde.lingmouiaddons.settings as LingmoUISettings
 *
 * Controls.Button {
 *     id: button
 *
 *     LingmoUISettings.ConfigurationView {
 *         id: configuration
 *
 *         window: button.Controls.ApplicationWindow.window as LingmoUI.ApplicationWindow
 *
 *         modules: [
 *             LingmoUISettings.ConfigurationModule {
 *                 moduleId: "appearance"
 *                 text: i18nc("@action:button", "Appearance")
 *                 icon.name: "preferences-desktop-theme-global"
 *                 page: () => Qt.createComponent("org.kde.tokodon", "AppearancePage")
 *             },
 *             ...
 *             LingmoUISettings.ConfigurationModule {
 *                 moduleId: "about"
 *                 text: i18nc("@action:button", "About Tokodon")
 *                 icon.name: "help-about"
 *                 page: () => Qt.createComponent("org.kde.lingmouiaddons.formcard", "AboutPage")
 *                 category: i18nc("@title:group", "About")
 *             },
 *             LingmoUISettings.ConfigurationModule {
 *                 moduleId: "aboutkde"
 *                 text: i18nc("@action:button", "About KDE")
 *                 icon.name: "kde"
 *                 page: () => Qt.createComponent("org.kde.lingmouiaddons.formcard", "AboutKDE")
 *                 category: i18nc("@title:group", "About")
 *             }
 *         ]
 *     }
 *
 *     icon.name: 'settings-configure-symbolic'
 *     text: i18nc("@action:button", "Settings")
 *
 *     onClicked: configuration.open()
 * }
 * @endcode
 *
 * This will result in the following dialog on desktop.
 *
 * @image html settingsdialogdesktop.png
 *
 * On the following page on mobile.
 *
 * @image html settingsdialogmobile.png
 *
 * @since LingmoUIAddons 1.3.0
 */
QtObject {
    id: root

    /**
     * @brief This property holds the title of the config view.
     *
     * By default this is "Settings"
     */
    property string title: i18ndc("lingmoui-addons6", "@title:window", "Settings")

    /**
     * @brief This property holds the list of pages for the settings.
     */
    property list<ConfigurationModule> modules

    /**
     * @brief This property holds the parent window.
     *
     * This needs to be set before calling open.
     */
    property LingmoUI.ApplicationWindow window

    /**
     * Open the configuration window.
     * @params defaultModule The moduleId of the default configuration that should be preselected when opening the configuration view. By default is not specified, this will choose the first module.
     */
    function open(defaultModule = ''): void {
        if (LingmoUI.Settings.isMobile) {
            const component = Qt.createComponent('org.kde.lingmouiaddons.settings.private', 'ConfigMobilePage');
            if (component.status === Component.Failed) {
                console.error(component.errorString());
                return;
            }
            root.window.pageStack.layers.push(component, {
                defaultModule: defaultModule,
                modules: root.modules,
                title: root.title,
                window: root.window,
            })
        } else {
            const component = Qt.createComponent('org.kde.lingmouiaddons.settings.private', 'ConfigWindow');
            if (component.status === Component.Failed) {
                console.error(component.errorString());
                return;
            }
            component.createObject(null, {
                defaultModule: defaultModule,
                modules: root.modules,
                width: LingmoUI.Units.gridUnit * 50,
                height: LingmoUI.Units.gridUnit * 30,
                minimumWidth: LingmoUI.Units.gridUnit * 50,
                minimumHeight: LingmoUI.Units.gridUnit * 30,
                title: root.title,
            });
        }
    }
}

