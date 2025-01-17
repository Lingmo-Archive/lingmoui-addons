/*
 * Copyright 2023 Evgeny Chesnokov <echesnokov@astralinux.ru>
 * SPDX-License-Identifier: LGPL-2.0-or-later
 */

import QtQuick
import QtQuick.Controls as QQC2
import QtQuick.Layouts

import org.kde.lingmoui as LingmoUI

QQC2.ItemDelegate {
    id: delegate

    Accessible.role: Accessible.Row
    leftPadding: 0
    rightPadding: 0
    topPadding: 0
    bottomPadding: 0

    required property var model
    required property int index

    property bool alternatingRows

    background: Rectangle {
        color: {
            if (delegate.enabled) {
                if (delegate.down || delegate.highlighted) {
                    return LingmoUI.Theme.highlightColor
                }

                if (delegate.hovered && !LingmoUI.Settings.isMobile) {
                    return Qt.alpha(LingmoUI.Theme.hoverColor, 0.3)
                }
            }

            if (delegate.alternatingRows && index % 2) {
                return LingmoUI.Theme.alternateBackgroundColor;
            }

            return "Transparent"
        }
    }

    contentItem: Row {
        spacing: 0

        Repeater {
            model: root.__columnModel

            delegate: ListCellDelegate {
                implicitWidth: root.__columnModel.get(index).headerComponent.width
                implicitHeight: root.__rowHeight
                entry: delegate.model
                rowIndex: delegate.index
            }
        }
    }

    onClicked: delegate.forceActiveFocus()
}
