// SPDX-FileCopyrightText: 2023 Carl Schwan <carl@carlschwan.eu>
// SPDX-License-Identifier: LGPL-2.1-only OR LGPL-3.0-only OR LicenseRef-KDE-Accepted-LGPL

import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15 as QQC2
import QtQuick.Templates 2.15 as T
import org.kde.lingmoui 2.20 as LingmoUI

/**
 * An item delegate providing a modern look and feel. Use a combination of
 * SubtitleContentItem, DefaultContentItem and RowLayout for the contentItem.
 *
 * @image html roundeditemdelegate.html
 */
T.ItemDelegate {
    id: root

    /**
     * This property holds a ListView
     *
     * It is automatically set if the RoundedItemDelegate is the direct delegate
     * of a ListView and must be set otherwise.
     */
    property var listView: ListView

    /**
     * This property holds a GridView
     *
     * It is automatically set if the RoundedItemDelegate is the direct delegate
     * of a GridView and must be set otherwise.
     */
    property var gridView: GridView

    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            implicitContentWidth + leftPadding + rightPadding,
                            implicitIndicatorWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             implicitContentHeight + topPadding + bottomPadding,
                             implicitIndicatorHeight + topPadding + bottomPadding,
                             LingmoUI.Units.gridUnit * 2)

    width: if (listView.view) {
        return listView.view.width;
    } else if (gridView.view) {
        return gridView.view.cellWidth;
    } else {
        implicitWidth
    }

    height: if (gridView.view) {
        return gridView.view.cellHeight;
    } else {
        return implicitHeight;
    }
    highlighted: listView.isCurrentItem || gridView.isCurrentItem

    spacing: LingmoUI.Units.mediumSpacing

    padding: LingmoUI.Units.mediumSpacing

    horizontalPadding: padding + Math.round(LingmoUI.Units.smallSpacing / 2)
    leftPadding: horizontalPadding
    rightPadding: horizontalPadding

    verticalPadding: padding
    topPadding: verticalPadding
    bottomPadding: verticalPadding

    topInset: if (root.index !== undefined && index === 0 && listView.view && listView.view.topMargin === 0) {
        LingmoUI.Units.smallSpacing;
    } else {
        Math.round(LingmoUI.Units.smallSpacing / 2);
    }
    bottomInset: if (root.index !== undefined && listView.view && index === listView.view.count - 1 && listView.view.bottomMargin === 0) {
        LingmoUI.Units.smallSpacing;
    } else {
        Math.round(LingmoUI.Units.smallSpacing / 2)
    }
    rightInset: LingmoUI.Units.smallSpacing
    leftInset: LingmoUI.Units.smallSpacing

    icon {
        width: if (contentItem instanceof SubtitleContentItem) {
            LingmoUI.Units.iconSizes.large
        } else {
            LingmoUI.Units.iconSizes.sizeForLabels
        }

        height: if (contentItem instanceof SubtitleContentItem) {
            LingmoUI.Units.iconSizes.large
        } else {
            LingmoUI.Units.iconSizes.sizeForLabels
        }
    }

    Accessible.description: if (contentItem instanceof SubtitleContentItem) {
        contentItem.subtitle
    } else {
        ""
    }

    background: Rectangle {
        radius: 5

        color: if (root.highlighted || root.checked || (root.down && !root.checked) || root.visualFocus) {
            const highlight = LingmoUI.ColorUtils.tintWithAlpha(LingmoUI.Theme.backgroundColor, LingmoUI.Theme.highlightColor, 0.3);
            if (root.hovered) {
                LingmoUI.ColorUtils.tintWithAlpha(highlight, LingmoUI.Theme.textColor, 0.10)
            } else {
                highlight
            }
        } else if (root.hovered) {
            LingmoUI.ColorUtils.tintWithAlpha(LingmoUI.Theme.backgroundColor, LingmoUI.Theme.textColor, 0.10)
        } else {
           LingmoUI.Theme.backgroundColor
        }

        border {
            color: LingmoUI.Theme.highlightColor
            width: root.visualFocus || root.activeFocus ? 1 : 0
        }

        Behavior on color {
            ColorAnimation {
                duration: LingmoUI.Units.shortDuration
            }
        }
    }

    contentItem: DefaultContentItem {
        itemDelegate: root
    }
}
