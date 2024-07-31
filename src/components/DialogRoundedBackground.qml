// SPDX-FileCopyrightText: 2023 Carl Schwan <carl@carlschwan.eu>
// SPDX-License-Identifier: LGPL-2.0-or-later

import QtQuick 2.15
import org.kde.lingmoui 2.20 as LingmoUI

/**
 * @brief Stylish background for dialogs
 *
 * This item can be used as background for any dialog in your application
 * and will have a rounded style.
 *
 * @since LingmoUIAddons 0.12
 */
LingmoUI.ShadowedRectangle {
    // perfect concentric border radius
    radius: 5 + LingmoUI.Units.smallSpacing

    color: LingmoUI.Theme.backgroundColor

    border {
        width: 1
        color: LingmoUI.ColorUtils.linearInterpolation(LingmoUI.Theme.backgroundColor, LingmoUI.Theme.textColor, LingmoUI.Theme.frameContrast);
    }

    shadow {
        size: LingmoUI.Units.gridUnit
        yOffset: 0
        color: Qt.rgba(0, 0, 0, 0.2)
    }

    LingmoUI.Theme.inherit: false
    LingmoUI.Theme.colorSet: LingmoUI.Theme.View
}
