/*
 * SPDX-FileCopyrightText: 2022 Devin Lin <devin@kde.org>
 * SPDX-FileCopyrightText: 2023 James Graham <james.h.graham@protonmail.com>
 * SPDX-License-Identifier: LGPL-2.0-or-later
 */

import QtQuick 2.15
import QtQuick.Controls 2.15 as QQC2
import QtQuick.Templates 2.15 as T
import QtQuick.Layouts 1.15

import org.kde.lingmoui 2.19 as LingmoUI

/**
 * @brief A header item for a form card.
 *
 * @note The header should be placed above the card in a layout not as a child.
 */
Item {
    id: root

    /**
     * @brief This property holds the header title.
     *
     * @property string title
     */
    property alias title: headerContent.text

    property alias trailing: header.data

    /**
     * @brief The maximum width of the header.
     */
    property real maximumWidth: LingmoUI.Units.gridUnit * 30

    property list<T.Action> actions

    /**
     * @brief These properties hold the padding around the heading.
     */
    property real topPadding: LingmoUI.Units.largeSpacing + LingmoUI.Units.smallSpacing
    property real bottomPadding: LingmoUI.Units.smallSpacing
    property real leftPadding: cardWidthRestricted ? LingmoUI.Units.smallSpacing : LingmoUI.Units.largeSpacing + LingmoUI.Units.smallSpacing
    property real rightPadding: cardWidthRestricted ? LingmoUI.Units.smallSpacing : LingmoUI.Units.largeSpacing + LingmoUI.Units.smallSpacing

    /**
     * @brief Whether the card's width is being restricted.
     */
    readonly property bool cardWidthRestricted: root.width > root.maximumWidth

    LingmoUI.Theme.colorSet: LingmoUI.Theme.View
    LingmoUI.Theme.inherit: false

    Layout.fillWidth: true

    implicitHeight: header.implicitHeight
    implicitWidth: header.implicitWidth + header.anchors.leftMargin + header.anchors.rightMargin

    RowLayout {
        id: header

        anchors {
            fill: parent
            leftMargin: root.cardWidthRestricted ? Math.round((root.width - root.maximumWidth) / 2) : 0
            rightMargin: root.cardWidthRestricted ? Math.round((root.width - root.maximumWidth) / 2) : 0
        }

        QQC2.Label {
            id: headerContent

            topPadding: root.topPadding
            bottomPadding: root.bottomPadding
            leftPadding: root.leftPadding
            rightPadding: root.rightPadding

            font.weight: Font.DemiBold
            wrapMode: Text.WordWrap
            Accessible.role: Accessible.Heading
            Layout.fillWidth: true
        }

        Repeater {
            model: root.actions

            QQC2.ToolButton {
                required property var modelData

                action: modelData
                visible: modelData
            }
        }
    }
}
