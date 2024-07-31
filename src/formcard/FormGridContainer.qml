// SPDX-FileCopyrightText: 2022 Devin Lin <devin@kde.org>
// SPDX-FileCopyrightText: 2023 Rishi Kumar <rsi.dev17@gmail.com>
// SPDX-FileCopyrightText: 2023 Carl Schwan <carl@carlschwan.eu>
// SPDX-License-Identifier: LGPL-2.0-or-later

import QtQml
import QtQuick
import QtQuick.Controls as QQC2
import QtQuick.Templates as T
import QtQuick.Layouts

import org.kde.lingmoui as LingmoUI

import "private" as Private

/**
 * This component render a grid of small cards.
 *
 * This is used to display multiple information in a FormCard.FormLayout
 * without taking too much vertical space.
 *
 * @code{.qml}
 * import org.kde.lingmouiaddons.formcard as FormCard
 *
 * FormCard.FormGridContainer {
 *     id: container
 *
 *     Layout.topMargin: LingmoUI.Units.largeSpacing
 *     Layout.fillWidth: true
 *
 *     infoCards: [
 *         FormCard.FormGridContainer.InfoCard {
 *             title: "42"
 *             subtitle: i18nc("@info:Number of Posts", "Posts")
 *         },
 *         FormCard.FormGridContainer.InfoCard {
 *             title: "42"
 *             subtitle: i18nc("@info:Number of followers.", "Followers")
 *         }
 *     ]
 * }
 * @endcode
 *
 *
 * @since LingmoUIAddons 0.11.0
 *
 * @inherit QtQuick.Item
 */
Item {
    id: root

    /**
     * This property holds the maximum width of the grid.
     */
    property real maximumWidth: LingmoUI.Units.gridUnit * 30

    /**
     * @brief This property holds the padding used around the content edges.
     *
     * default: `0`
     */
    property real padding: 0
    property real verticalPadding: padding
    property real horizontalPadding: padding
    property real topPadding: verticalPadding
    property real bottomPadding: verticalPadding
    property real leftPadding: horizontalPadding
    property real rightPadding: horizontalPadding

    /**
     * This property holds whether the card's width is being restricted.
     */
    readonly property bool cardWidthRestricted: root.width > root.maximumWidth

    /**
     * This property holds the InfoCards which should be displayed.
     *
     * Each InfoCard contains a title and an optional subtitle
     *
     * @code{.qml}
     * import org.kde.lingmouiaddons.formcard as FormCard
     *
     * FormCard.FormGridContainer {
     *     infoCards: [
     *         FormCard.FormGridContainer.InfoCard {
     *             title: "42"
     *             subtitle: i18nc("@info:Number of Posts", "Posts")
     *         },
     *         FormCard.FormGridContainer.InfoCard {
     *             title: "42"
     *         },
     *         FormCard.FormGridContainer.InfoCard {
     *             title: "Details"
     *             action: LingmoUI.Action {
     *                 onClicked: pageStack.push("Details.qml")
     *             }
     *         }
     *     ]
     * }
     * @endcode
     */
    property list<QtObject> infoCards

    component InfoCard: QtObject {
        property bool visible: true
        property string title
        property string subtitle
        property string buttonIcon
        property string tooltipText
        property int subtitleTextFormat: Text.AutoText
        property LingmoUI.Action action
    }

    LingmoUI.Theme.colorSet: LingmoUI.Theme.View
    LingmoUI.Theme.inherit: false

    implicitHeight: topPadding + bottomPadding + grid.implicitHeight

    Item {
        anchors {
            top: parent.top
            bottom: parent.bottom
            left: parent.left
            right: parent.right

            leftMargin: root.cardWidthRestricted ? Math.round((root.width - root.maximumWidth) / 2) : 0
            rightMargin: root.cardWidthRestricted ? Math.round((root.width - root.maximumWidth) / 2) : 0
        }

        GridLayout {
            id: grid

            readonly property int cellWidth: LingmoUI.Units.gridUnit * 10
            readonly property int visibleChildrenCount: visibleChildren.length - 1

            anchors {
                fill: parent
                leftMargin: root.leftPadding
                rightMargin: root.rightPadding
                topMargin: root.topPadding
                bottomMargin: root.bottomPadding
            }

            columns: root.cardWidthRestricted && grid.visibleChildrenCount % 3 === 0 ? 3 : 2
            columnSpacing: LingmoUI.Units.smallSpacing
            rowSpacing: LingmoUI.Units.smallSpacing

            Repeater {
                id: cardRepeater

                model: root.infoCards

                QQC2.AbstractButton {
                    id: infoCardDelegate

                    required property int index
                    required property QtObject modelData

                    readonly property string title: modelData.title
                    readonly property string subtitle: modelData.subtitle
                    readonly property string buttonIcon: modelData.buttonIcon
                    readonly property string tooltipText: modelData.tooltipText
                    readonly property int subtitleTextFormat: modelData.subtitleTextFormat

                    visible: modelData.visible

                    action: modelData.action

                    leftPadding: LingmoUI.Units.largeSpacing
                    rightPadding: LingmoUI.Units.largeSpacing
                    topPadding: LingmoUI.Units.largeSpacing
                    bottomPadding: LingmoUI.Units.largeSpacing

                    leftInset: root.cardWidthRestricted ? 0 : -infoCardDelegate.background.border.width
                    rightInset: root.cardWidthRestricted ? 0 : -infoCardDelegate.background.border.width

                    hoverEnabled: true

                    Accessible.name: title + " " + subtitle
                    Accessible.role: action ? Accessible.Button : Accessible.Note

                    Layout.preferredWidth: grid.cellWidth
                    Layout.columnSpan: grid.visibleChildrenCount % grid.columns !== 0 && index === grid.visibleChildrenCount - 1 ? 2 : 1
                    Layout.fillWidth: true
                    Layout.fillHeight: true

                    QQC2.ToolTip.text: tooltipText
                    QQC2.ToolTip.visible: tooltipText && hovered
                    QQC2.ToolTip.delay: LingmoUI.Units.toolTipDelay

                    background: Rectangle {
                        radius: root.cardWidthRestricted ? LingmoUI.Units.smallSpacing : 0
                        color: LingmoUI.Theme.backgroundColor

                        border {
                            color: LingmoUI.ColorUtils.linearInterpolation(LingmoUI.Theme.backgroundColor, LingmoUI.Theme.textColor, LingmoUI.Theme.frameContrast)
                            width: 1
                        }

                        Rectangle {
                            anchors.fill: parent
                            radius: root.cardWidthRestricted ? LingmoUI.Units.smallSpacing : 0

                            color: {
                                let alpha = 0;

                                if (!infoCardDelegate.enabled || !infoCardDelegate.action) {
                                    alpha = 0;
                                } else if (infoCardDelegate.pressed) {
                                    alpha = 0.2;
                                } else if (infoCardDelegate.visualFocus) {
                                    alpha = 0.1;
                                } else if (!LingmoUI.Settings.tabletMode && infoCardDelegate.hovered) {
                                    alpha = 0.07;
                                }

                                return Qt.rgba(LingmoUI.Theme.textColor.r, LingmoUI.Theme.textColor.g, LingmoUI.Theme.textColor.b, alpha)
                            }

                            Behavior on color {
                                ColorAnimation { duration: LingmoUI.Units.shortDuration }
                            }
                        }
                    }

                    contentItem: RowLayout {
                        LingmoUI.Icon {
                            id: icon

                            source: infoCardDelegate.buttonIcon
                            visible: source
                            Layout.alignment: Qt.AlignTop
                        }

                        ColumnLayout {
                            spacing: 0

                            // Title
                            LingmoUI.Heading {
                                Layout.fillWidth: true
                                level: 4
                                text: infoCardDelegate.title
                                verticalAlignment: Text.AlignVCenter
                                horizontalAlignment: icon.visible ? Text.AlignLeft : Text.AlignHCenter
                                maximumLineCount: 2
                                elide: Text.ElideRight
                                wrapMode: Text.Wrap
                            }

                            // Subtitle
                            QQC2.Label {
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                                visible: infoCardDelegate.subtitle
                                text: infoCardDelegate.subtitle
                                horizontalAlignment: icon.visible ? Text.AlignLeft : Text.AlignHCenter
                                elide: Text.ElideRight
                                wrapMode: Text.Wrap
                                textFormat: infoCardDelegate.subtitleTextFormat
                                opacity: 0.6
                                verticalAlignment: Text.AlignTop
                                onLinkActivated: (link) => modelData.linkActivated(link)
                            }
                        }
                    }
                }
            }
        }
    }
}
