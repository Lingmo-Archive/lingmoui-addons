/*
 * Copyright 2022 Devin Lin <devin@kde.org>
 * SPDX-License-Identifier: LGPL-2.0-or-later
 */

import QtQml 2.15
import QtQuick 2.15
import QtQuick.Layouts 1.15
import org.kde.lingmoui 2.4 as LingmoUI

/**
 * @brief A context-aware separator.
 *
 * This is a standard LingmoUI.Separator that can be hidden upon hovering
 * the mouse over the ::above or ::below delegate, allowing for a subtle
 * but smooth animation feedback.
 *
 * Its two properties are particularly useful when it is not immediately known
 * which delegate will fill the ::above or ::below position, such as delegates
 * provided from a model or managed by a Loader.
 *
 * @see LingmoUI.Separator
 *
 * @inherit LingmoUI.Separator
 */
LingmoUI.Separator {
    id: root

    /**
     * @brief The delegate immediately above the separator.
     */
    property Item above
    /**
     * @brief The delegate immediately below the separator.
     */
    property Item below

    Layout.leftMargin: parent._internal_formcard_margins ? parent._internal_formcard_margins : LingmoUI.Units.largeSpacing
    Layout.rightMargin: parent._internal_formcard_margins ? parent._internal_formcard_margins : LingmoUI.Units.largeSpacing
    Layout.fillWidth: true

    // We need to initialize above and below later otherwise nextItemInFocusChain
    // will return the element itself
    Timer {
        interval: 500
        running: !root.above || !root.below
        onTriggered: {
            if (!root.above) {
                root.above = root.nextItemInFocusChain(true);
            }
            if (!root.below) {
                root.below = root.nextItemInFocusChain(false);
            }
        }
    }

    opacity: (!above || above.background === null || !(above.enabled && ((above.visualFocus || above.hovered && !LingmoUI.Settings.tabletMode) || above.pressed))) &&
        (!below || below.background === null || !(below.enabled && ((below.visualFocus || below.hovered && !LingmoUI.Settings.tabletMode) || below.pressed))) ? 0.5 : 0
}
