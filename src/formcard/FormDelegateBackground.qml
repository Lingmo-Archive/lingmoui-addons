/*
 * Copyright 2022 Devin Lin <devin@kde.org>
 * SPDX-License-Identifier: LGPL-2.0-or-later
 */

import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Templates 2.15 as T
import org.kde.lingmoui 2.20 as LingmoUI

/**
 * @brief A background for Form delegates.
 *
 * This is a simple background that provides opacity feedback to the user
 * when the control has focus or is currently being pressed, for example.
 *
 * This is used in AbstractFormDelegate so that new delegates provide this
 * feedback by default, and can be easily overriden with a QtQuick.Item.
 *
 * @since LingmoUIAddons 0.11.0
 *
 * @see AbstractFormDelegate
 *
 * @inherit QtQuick.Rectangle
 */
LingmoUI.ShadowedRectangle {
    id: root

    /**
     * @brief The control to which the background will be assigned.
     */
    required property T.Control control

    readonly property bool _roundCorners: control.parent._roundCorners === true
    readonly property bool _isFirst: _roundCorners && control.parent.children[0] === control
    readonly property bool _isLast: _roundCorners && control.parent.children[control.parent.children.length - 1] === control

    color: {
        let colorOpacity = 0;

        if (!control.enabled) {
            colorOpacity = 0;
        } else if (control.pressed) {
            colorOpacity = 0.2;
        } else if (control.visualFocus) {
            colorOpacity = 0.1;
        } else if (!LingmoUI.Settings.tabletMode && control.hovered) {
            colorOpacity = 0.07;
        }

        return Qt.rgba(LingmoUI.Theme.textColor.r, LingmoUI.Theme.textColor.g, LingmoUI.Theme.textColor.b, colorOpacity)
    }

    corners {
        topLeftRadius: _isFirst ? LingmoUI.Units.smallSpacing : 0
        topRightRadius: _isFirst ? LingmoUI.Units.smallSpacing : 0
        bottomLeftRadius: _isLast ? LingmoUI.Units.smallSpacing : 0
        bottomRightRadius: _isLast ? LingmoUI.Units.smallSpacing : 0
    }

    Behavior on color {
        ColorAnimation { duration: LingmoUI.Units.shortDuration }
    }
}
