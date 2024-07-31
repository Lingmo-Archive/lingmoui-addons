// SPDX-FileCopyrightText: 2023 Mathis Brüchert <mbb@kaidan.im>
//
// SPDX-License-Identifier: LGPL-2.0-only OR LGPL-3.0-only OR LicenseRef-KDE-Accepted-GPL

import QtQuick
import QtQuick.Controls as QQC2
import QtQuick.Layouts
import org.kde.lingmoui as LingmoUI
import org.kde.lingmouiaddons.components as Components
import org.kde.lingmouiaddons.delegates as Delegates

QQC2.ApplicationWindow {
    id: root

    height: 800
    width: 600

    visible: true

    Components.FloatingButton {
        icon.name: "configure"
        text: "Open Drawer"

        margins: LingmoUI.Units.largeSpacing

        anchors {
            right: parent.right
            bottom: parent.bottom
        }

        onClicked: drawer.open()
    }

    Components.BottomDrawer {
        id: drawer
        width: root.width

        headerContentItem: RowLayout {
            Components.Avatar {
                name: "World"
            }

            ColumnLayout {
                Layout.leftMargin: LingmoUI.Units.largeSpacing
                Layout.fillWidth: true

                LingmoUI.Heading {
                    text: "John Doe"
                    Layout.fillWidth: true
                }
                QQC2.Label {
                    text: "Last connection: 20.04.2042"
                    Layout.fillWidth: true
                }
            }
        }

        QQC2.ScrollView {
            implicitHeight: Math.max(view.implicitHeight, root.height * 0.8)

            ListView {
                id: view

                model: 40

                delegate: Delegates.RoundedItemDelegate {
                    required property int index

                    text: "Item " + index
                }
            }
        }
    }
}
