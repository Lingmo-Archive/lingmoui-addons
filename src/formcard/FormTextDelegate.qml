/*
 * Copyright 2022 Devin Lin <devin@kde.org>
 * SPDX-License-Identifier: LGPL-2.0-or-later
 */

import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

import org.kde.lingmoui 2.19 as LingmoUI

import "private" as Private

/**
 * @brief A Form delegate that corresponds to a text label and a description.
 *
 * This component is used to create primary text with the inherited
 * QtQuick.Controls.AbstractButton.text property, with an optional
 * ::description that serves as secondary text/subtitle.
 *
 * If you need just a secondary text component, use a FormSectionText
 * instead.
 *
 * @since LingmoUIAddons 0.11.0
 *
 * @see FormSectionText
 * @see QtQuick.Controls.AbstractButton
 *
 * @inherit AbstractFormDelegate
 */
AbstractFormDelegate {
    id: root

    /**
     * @brief A label containing secondary text that appears under the
     * inherited text property.
     *
     * This provides additional information shown in a faint gray color.
     */
    property string description: ""

    /**
     * @brief This property allows for access to the description label item.
     */
    property alias descriptionItem: internalDescriptionItem

    /**
     * @brief This property holds allows for access to the text label item.
     */
    property alias textItem: internalTextItem

    /**
     * @brief This property holds an item that will be displayed before
     * the delegate's contents.
     */
    property var leading: null

    /**
     * @brief This property holds the padding after the leading item.
     */
    property real leadingPadding: LingmoUI.Units.smallSpacing

    /**
     * @brief This property holds an item that will be displayed after
     * the delegate's contents.
     */
    property var trailing: null

    /**
     * @brief This property holds the padding before the trailing item.
     */
    property real trailingPadding: LingmoUI.Units.smallSpacing

    signal linkActivated(string link)

    focusPolicy: Qt.NoFocus

    background: null

    contentItem: RowLayout {
        spacing: 0

        Private.ContentItemLoader {
            Layout.rightMargin: visible ? root.leadingPadding : 0
            visible: root.leading
            implicitHeight: visible ? root.leading.implicitHeight : 0
            implicitWidth: visible ? root.leading.implicitWidth : 0
            contentItem: root.leading
        }

        LingmoUI.Icon {
            visible: root.icon.name !== ""
            source: root.icon.name
            color: root.icon.color
            Layout.rightMargin: (root.icon.name !== "") ? LingmoUI.Units.largeSpacing + LingmoUI.Units.smallSpacing : 0
            implicitWidth: (root.icon.name !== "") ? LingmoUI.Units.iconSizes.small : 0
            implicitHeight: (root.icon.name !== "") ? LingmoUI.Units.iconSizes.small : 0
        }

        ColumnLayout {
            Layout.fillWidth: true
            spacing: LingmoUI.Units.smallSpacing

            Label {
                id: internalTextItem
                Layout.fillWidth: true
                text: root.text
                elide: Text.ElideRight
                onLinkActivated: root.linkActivated(link)
                visible: root.text
                Accessible.ignored: true // base class sets this text on root already
            }

            Label {
                id: internalDescriptionItem
                Layout.fillWidth: true
                text: root.description
                color: LingmoUI.Theme.disabledTextColor
                visible: root.description !== ""
                onLinkActivated: root.linkActivated(link)
                wrapMode: Text.Wrap
            }
        }

        Private.ContentItemLoader {
            Layout.leftMargin: visible ? root.trailingPadding : 0
            visible: root.trailing
            implicitHeight: visible ? root.trailing.implicitHeight : 0
            implicitWidth: visible ? root.trailing.implicitWidth : 0
            contentItem: root.trailing
        }
    }
}

