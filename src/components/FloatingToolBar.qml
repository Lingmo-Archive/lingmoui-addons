// SPDX-FileCopyrightText: 2024 Mathis Brüchert <mbb@kaidan.im>
// SPDX-FileCopyrightText: 2024 Carl Schwan <carl@carlschwan.eu>
// SPDX-License-Identifier: LGPL-2.0-only OR LGPL-3.0-only OR LicenseRef-KDE-Accepted-LGPL

import QtQuick
import org.kde.lingmoui as LingmoUI
import QtQuick.Controls

/**
 * A floating toolbar to use for example in a canvas.
 *
 * The toolbar should be positioned with LingmoUI.Units.largeSpacing from
 * the border of the page.
 *
 * @code{qml}
 * import org.kde.lingmouiaddons.components
 * import org.kde.lingmoui as LingmoUI
 *
 * FloatingToolBar {
 *     contentItem: LingmoUI.ActionToolBar {
 *         actions: [
 *             LingmoUI.Action {
 *                 ...
 *             }
 *         ]
 *     }
 * }
 * @endcode{}
 *
 * @image html floatingtoolbar.png
 */
ToolBar {
    background: LingmoUI.ShadowedRectangle {
        color: LingmoUI.Theme.backgroundColor
        radius: 5

        shadow {
            size: 15
            yOffset: 3
            color: Qt.rgba(0, 0, 0, 0.2)
        }

        border {
            color: LingmoUI.ColorUtils.tintWithAlpha(LingmoUI.Theme.backgroundColor, LingmoUI.Theme.textColor, LingmoUI.Theme.frameContrast)
            width: 1
        }

        LingmoUI.Theme.inherit: false
        LingmoUI.Theme.colorSet: LingmoUI.Theme.Window
    }
}
