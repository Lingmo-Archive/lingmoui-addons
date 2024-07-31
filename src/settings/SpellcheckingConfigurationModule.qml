// SPDX-FileCopyrightText: 2024 Carl Schwan <carl@carlschwan.eu>
// SPDX-License-Identifier: LGPL-2.1-only OR LGPL-3.0-only OR LicenseRef-KDE-Accepted-LGPL

import QtQuick
import org.kde.lingmouiaddons.settings.private as Private

/**
 * Configuration module for spellchecking.
 *
 * @since LingmoUIAddons 1.3.0
 */
ConfigurationModule {
    moduleId: "spellchecking"
    text: i18ndc("lingmoui-addons6", "@action:button", "Spell Checking")
    icon.name: "tools-check-spelling"
    page: () => Qt.createComponent("org.kde.lingmouiaddons.settings.private", "SonnetConfigPage")
    visible: Qt.platform.os !== "android" && (Private.Helper.styleName === 'org.kde.desktop' || Private.Helper.styleName === 'ocean')
}
