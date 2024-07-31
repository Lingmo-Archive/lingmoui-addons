/*
 *  SPDX-FileCopyrightText: 2023 ivan tkachenko <me@ratijas.tk>
 *
 *  SPDX-License-Identifier: LGPL-2.0-or-later
 */

import QtQuick 2.15
import QtQuick.Controls 2.15 as QQC2
import QtQuick.Layouts 1.15
import org.kde.lingmoui 2.20 as LingmoUI
import org.kde.lingmouiaddons.components 1.0 as LingmoUIComponents

QQC2.Pane {
    width: LingmoUI.Units.gridUnit * 15
    height: LingmoUI.Units.gridUnit * 20

    ColumnLayout {
        anchors.fill: parent
        spacing: LingmoUI.Units.largeSpacing

        LingmoUIComponents.AvatarButton {
            id: avatar1

            Layout.preferredWidth: LingmoUI.Units.gridUnit * 6
            Layout.preferredHeight: LingmoUI.Units.gridUnit * 6
            Layout.alignment: Qt.AlignHCenter

            name: "John Due"

            QQC2.Button {
                parent: avatar1.clippedContent
                width: parent.width
                height: Math.round(parent.height * 0.333)
                anchors.bottom: parent.bottom
                anchors.bottomMargin: avatar1.hovered ? 0 : -height

                Behavior on anchors.bottomMargin {
                    NumberAnimation {
                        duration: LingmoUI.Units.shortDuration
                        easing.type: Easing.InOutCubic
                    }
                }

                verticalPadding: Math.round(height * 0.1)
                topPadding: undefined
                bottomPadding: undefined

                HoverHandler {
                    cursorShape: Qt.PointingHandCursor
                }

                contentItem: Item {
                    LingmoUI.Icon {
                        height: parent.height
                        width: height
                        anchors.horizontalCenter: parent.horizontalCenter
                        source: "camera-photo-symbolic"
                    }
                }
                background: Rectangle {
                    color: Qt.rgba(0, 0, 0, 0.6)
                }

                onClicked: print("Select photo")
            }

            onClicked: print("Show photo fullscreen")
        }
    }
}
