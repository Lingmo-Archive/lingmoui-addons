// SPDX-FileCopyrightText: %{CURRENT_YEAR} %{AUTHOR} <%{EMAIL}>
// SPDX-License-Identifier: GPL-2.0-or-later

pragma ComponentBehavior: Bound

import QtQuick
import org.kde.lingmouiaddons.settings as LingmoUISettings

LingmoUISettings.ConfigurationView {
    id: root

    modules: [
        LingmoUISettings.ConfigurationModule {
            moduleId: "general"
            text: i18nc("@action:button", "General")
            icon.name: "preferences-system-symbolic"
            page: () => Qt.createComponent("org.kde.%{APPNAMELC}.settings", "GeneralPage")
        }
    ]
}
