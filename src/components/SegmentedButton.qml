// SPDX-FileCopyrightText: 2023 Carl Schwan <carlschwan@kde.org>
// SPDX-License-Identifier: LGPL-2.0-or-later

import QtQuick 2.15
import QtQuick.Controls 2.15 as QQC2
import QtQuick.Templates 2.15 as T
import QtQuick.Layouts 1.15
import org.kde.lingmoui 2.20 as LingmoUI
import org.kde.lingmouiaddons.delegates 1.0 as Delegates

RowLayout {
    id: root

    property list<T.Action> actions

    spacing: Math.round(LingmoUI.Units.smallSpacing / 2)

    Repeater {
        id: buttonRepeater

        model: root.actions

        delegate: QQC2.AbstractButton {
            id: buttonDelegate

            required property int index
            required property T.Action modelData

            property bool highlightBackground: down || checked
            property bool highlightBorder: enabled && down || checked || visualFocus || hovered

            padding: LingmoUI.Units.mediumSpacing

            focus: index === 0

            action: modelData

            display: modelData.displayHint & LingmoUI.DisplayHint.IconOnly ? QQC2.AbstractButton.IconOnly : QQC2.AbstractButton.TextBesideIcon

            Layout.fillHeight: true
            Layout.minimumWidth: height

            icon {
                width: LingmoUI.Units.iconSizes.smallMedium
                height: LingmoUI.Units.iconSizes.smallMedium
            }

            contentItem: Delegates.DefaultContentItem {
                itemDelegate: buttonDelegate
                iconItem.Layout.fillWidth: buttonDelegate.modelData instanceof LingmoUI.Action
                    ? buttonDelegate.modelData.displayHint & LingmoUI.DisplayHint.IconOnly
                    : true

                labelItem {
                    elide: Text.ElideRight
                    horizontalAlignment: Text.AlignHCenter
                    Layout.fillWidth: true
                    Accessible.ignored: true
                }
            }

            background: LingmoUI.ShadowedRectangle {

                property color flatColor: Qt.rgba(
                    LingmoUI.Theme.backgroundColor.r,
                    LingmoUI.Theme.backgroundColor.g,
                    LingmoUI.Theme.backgroundColor.b,
                    0
                )

                corners {
                    topLeftRadius: buttonDelegate.index === 0 ? LingmoUI.Units.mediumSpacing : 0
                    bottomLeftRadius: buttonDelegate.index === 0 ? LingmoUI.Units.mediumSpacing : 0

                    bottomRightRadius: buttonDelegate.index === buttonRepeater.count - 1 ? LingmoUI.Units.mediumSpacing : 0
                    topRightRadius: buttonDelegate.index === buttonRepeater.count - 1 ? LingmoUI.Units.mediumSpacing : 0
                }

                visible: !buttonDelegate.flat || buttonDelegate.editable || buttonDelegate.down || buttonDelegate.checked || buttonDelegate.highlighted || buttonDelegate.visualFocus || buttonDelegate.hovered

                color: {
                    if (buttonDelegate.highlightBackground) {
                        return LingmoUI.Theme.alternateBackgroundColor
                    } else if (buttonDelegate.flat) {
                        return flatColor
                    } else {
                        return LingmoUI.Theme.backgroundColor
                    }
                }

                border {
                    color: {
                        if (buttonDelegate.highlightBorder) {
                            return LingmoUI.Theme.focusColor
                        } else {
                            return LingmoUI.ColorUtils.linearInterpolation(LingmoUI.Theme.backgroundColor, LingmoUI.Theme.textColor, LingmoUI.Theme.frameContrast);
                        }
                    }
                    width: 1
                }

                Behavior on color {
                    enabled: buttonDelegate.highlightBackground
                    ColorAnimation {
                        duration: LingmoUI.Units.shortDuration
                        easing.type: Easing.OutCubic
                    }
                }
                Behavior on border.color {
                    enabled: buttonDelegate.highlightBorder
                    ColorAnimation {
                        duration: LingmoUI.Units.shortDuration
                        easing.type: Easing.OutCubic
                    }
                }

                LingmoUI.ShadowedRectangle {
                    id: root

                    height: buttonDelegate.height
                    z: -1
                    color: Qt.rgba(0, 0, 0, 0.1)

                    opacity: buttonDelegate.down ? 0 : 1
                    visible: !buttonDelegate.editable && !buttonDelegate.flat && buttonDelegate.enabled

                    corners {
                        topLeftRadius: buttonDelegate.index === 0 ? LingmoUI.Units.mediumSpacing : 0
                        bottomLeftRadius: buttonDelegate.index === 0 ? LingmoUI.Units.mediumSpacing : 0

                        bottomRightRadius: buttonDelegate.index === buttonRepeater.count - 1 ? LingmoUI.Units.mediumSpacing : 0
                        topRightRadius: buttonDelegate.index === buttonRepeater.count - 1 ? LingmoUI.Units.mediumSpacing : 0
                    }

                    anchors {
                        top: parent.top
                        topMargin: 1
                        left: parent.left
                        right: parent.right
                    }
                }
            }
        }
    }
}
