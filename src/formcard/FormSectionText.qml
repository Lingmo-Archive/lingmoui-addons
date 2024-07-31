/*
 * Copyright 2022 Devin Lin <devin@kde.org>
 * SPDX-License-Identifier: LGPL-2.0-or-later
 */

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import org.kde.lingmoui as LingmoUI

/**
 * @brief A standard delegate label.
 *
 * This is a simple label containing secondary text that was modified to fit
 * the role of Form delegate.
 *
 * If you need a primary text label with optional secondary text, use
 * FormTextDelegate instead.
 *
 * @since LingmoUIAddons 0.11.0
 *
 * @see FormTextDelegate
 *
 * @inherit QtQuick.Controls.Label
 */
Label {
    color: LingmoUI.Theme.disabledTextColor
    wrapMode: Label.Wrap

    Layout.maximumWidth: LingmoUI.Units.gridUnit * 30
    Layout.alignment: Qt.AlignHCenter
    Layout.leftMargin: LingmoUI.Units.gridUnit
    Layout.rightMargin: LingmoUI.Units.gridUnit
    Layout.bottomMargin: LingmoUI.Units.largeSpacing
    Layout.topMargin: LingmoUI.Units.largeSpacing
    Layout.fillWidth: true
}
