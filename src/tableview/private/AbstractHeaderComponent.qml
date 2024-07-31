/*
 * Copyright 2023 Evgeny Chesnokov <echesnokov@astralinux.ru>
 * SPDX-License-Identifier: LGPL-2.0-or-later
 */

import QtQuick
import QtQuick.Controls as QQC2

import org.kde.lingmoui as LingmoUI

/**
 * @brief Abstract header component.
 *
 * Designed to form a set of properties that will be used in the implementation.
 *
 * @inherit QtQml.QtObject
 */
QtObject {
    id: component

    /**
     * @brief Stores the current width of an entire table column.
     */
    property real width

    /**
     * @brief Stores the minimum allowed width of the entire column
     */
    property real minimumWidth: LingmoUI.Units.gridUnit * 2

    /**
     * @brief Column title.
     *
     * Default used in default headerDelegate.
     *
     * @see headerDelegate
     */
    property string title

    /**
     * @brief The name of the role from the model for the current column.
     *
     * Used to access the value that is stored in the model for that role.
     */
    property string textRole

    /**
     * @brief The role value from the model for the current column.
     *
     * By default, used to indicate the column by which the table is sorted.
     */
    property int role

    /**
     * @brief The property is responsible for displaying the entire column in the table.
     */
    property bool visible: true

    /**
     * @brief The flag reflects the ability to change the original column size.
     */
    property bool resizable: true

    /**
     * @brief The flag reflects the ability to move the current column to another place in the table.
     */
    property bool draggable

    /**
     * @brief The element that will be used as the base element to display in all delegates of this column.
     *
     * It can be customized to put any kind of Item in there.
     */
    property Component itemDelegate: __baseDelegate

    /**
     * @brief This property holds an item that will be displayed as the main component of the column.
     *
     * It can be customized to put any kind of Item in there.
     */
    property Component headerDelegate: __baseDelegate

    /**
     * @brief This property holds an item that will be displayed to the left
     * of the headerDelegate contents.
     *
     * It can be customized to put any kind of Item in there.
     *
     * @see headerDelegate
     */
    property Component leading

    readonly property Component __baseDelegate: QQC2.Label {
        id: label
        text: modelData ?? ""
        elide: Text.ElideRight
        verticalAlignment: Qt.AlignVCenter
        horizontalAlignment: Qt.AlignLeft
        leftPadding: LingmoUI.Units.largeSpacing
        rightPadding: LingmoUI.Units.largeSpacing

        QQC2.ToolTip.visible: truncated && handler.hovered
        QQC2.ToolTip.delay: LingmoUI.Units.toolTipDelay
        QQC2.ToolTip.text: text

        HoverHandler {
            id: handler
            enabled: label.truncated
        }
    }
}
