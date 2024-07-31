// SPDX-FileCopyrightText: 2023 Mathis Brüchert <mbb@kaidan.im>
//
// SPDX-License-Identifier: LGPL-2.0-only OR LGPL-3.0-only OR LicenseRef-KDE-Accepted-GPL

import QtQuick
import QtQuick.Controls as QQC2
import org.kde.lingmoui as LingmoUI
import QtQuick.Layouts

/**
* @brief A bottom drawer component with a drag indicator.
*
* Example:
* @code{.qml}
* import org.kde.lingmouiaddons.delegates 1.0 as Delegates
* import org.kde.lingmouiaddons.components 1.0 as Components
*
* Components.BottomDrawer {
*     id: drawer
*
*     headerContentItem: LingmoUI.Heading {
*         text: "Drawer"
*     }
*
*     Delegates.RoundedItemDelegate {
*         text: "Action 1"
*         icon.name: "list-add"
*         onClicked: {
*             doSomething()
*             drawer.close()
*         }
*     }

*     Delegates.RoundedItemDelegate {
*         text: "Action 1"
*         icon.name: "list-add"
*         onClicked: {
*             doSomething()
*             drawer.close()
*         }
*     }
* }
* @endcode
*
* @image html bottomdrawer.png
*
* @since LingmoUIAddons 0.12.0
*/
QQC2.Drawer {
    id: root

    /**
    * @brief This property holds the content item of the drawer
    */
    default property alias drawerContentItem: drawerContent.contentItem

    /**
    * @brief This property holds the content item of the drawer header
    *
    * when no headerContentItem is set, the header will not be displayed
    */
    property alias headerContentItem: headerContent.contentItem

    component Handle: Rectangle {
        color: LingmoUI.Theme.textColor
        radius: height
        opacity: 0.5

        implicitWidth: Math.round(LingmoUI.Units.gridUnit * 2.5)
        implicitHeight: Math.round(LingmoUI.Units.gridUnit / 4)

        Layout.margins: LingmoUI.Units.mediumSpacing
        Layout.alignment: Qt.AlignHCenter
    }

    edge: Qt.BottomEdge
    width: applicationWindow().width
    height: Math.min(contentItem.implicitHeight, Math.round(applicationWindow().height * 0.8))

    // makes sure the drawer is not able to be opened when not trigered
    interactive : false

    background: LingmoUI.ShadowedRectangle {
        corners {
            topRightRadius: LingmoUI.Units.largeSpacing
            topLeftRadius: LingmoUI.Units.largeSpacing
        }

        shadow {
            size: LingmoUI.Units.gridUnit
            color: Qt.rgba(0, 0, 0, 0.5)
        }

        color: LingmoUI.Theme.backgroundColor
    }

    onAboutToShow: root.interactive = true
    onClosed: root.interactive = false

    contentItem: ColumnLayout {
        spacing: 0

        LingmoUI.ShadowedRectangle {
            id: headerBackground

            visible: headerContentItem
            height: header.implicitHeight

            LingmoUI.Theme.colorSet: LingmoUI.Theme.Window
            color: LingmoUI.Theme.backgroundColor

            Layout.fillWidth: true

            corners {
                topRightRadius: 10
                topLeftRadius: 10
            }

            ColumnLayout{
                id:header

                anchors.fill: parent
                spacing:0
                clip: true

                Handle {
                    // drag indicator displayed when there is a headerContentItem
                    id: handle
                }

                QQC2.Control {
                    id: headerContent

                    topPadding: 0
                    leftPadding: LingmoUI.Units.mediumSpacing + handle.height
                    rightPadding: LingmoUI.Units.mediumSpacing + handle.height
                    bottomPadding: LingmoUI.Units.mediumSpacing + handle.height

                    Layout.fillHeight: true
                    Layout.fillWidth: true
                }
            }
        }

        Handle {
            // drag indecator displayed when there is no headerContentItem
            visible: !headerContentItem
            Layout.topMargin: LingmoUI.Units.largeSpacing
            Layout.bottomMargin: LingmoUI.Units.largeSpacing
        }

        LingmoUI.Separator {
            Layout.fillWidth: true
        }

        QQC2.Control {
            id: drawerContent

            Layout.fillWidth: true
            Layout.fillHeight: true

            leftPadding: 0
            rightPadding: 0
            topPadding: 0
            bottomPadding: 0

            background: Rectangle {
                LingmoUI.Theme.colorSet: LingmoUI.Theme.View
                LingmoUI.Theme.inherit: false
                color: LingmoUI.Theme.backgroundColor
            }
        }
    }
}
