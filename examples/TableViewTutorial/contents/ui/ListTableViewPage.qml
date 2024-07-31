/*
 * Copyright 2023 Evgeny Chesnokov <echesnokov@astralinux.ru>
 * SPDX-License-Identifier: LGPL-2.0-or-later
 */

import QtQuick
import QtQuick.Controls as QQC2

import org.kde.lingmoui as LingmoUI
import org.kde.lingmouiaddons.tableview as Tables
import org.kde.lingmouiaddons.BookListModel

LingmoUI.Page {
    id: root

    title: i18nc("@title:group", "Table View for QAbstractListModel")

    topPadding: 0
    leftPadding: 0
    bottomPadding: 0
    rightPadding: 0

    LingmoUI.Theme.colorSet: LingmoUI.Theme.View
    LingmoUI.Theme.inherit: false

    contentItem: QQC2.ScrollView {
        Tables.ListTableView {
            id: view
            model: bookListModel

            clip: true

            sortOrder: Qt.AscendingOrder
            sortRole: bookListModel.sortRole

            onColumnClicked: function (index, headerComponent) {
                if (view.model.sortRole !== headerComponent.role) {
                    view.model.sortRole = headerComponent.role;
                    view.sortOrder = Qt.AscendingOrder;
                } else {
                    view.sortOrder = view.sortOrder === Qt.AscendingOrder ? Qt.DescendingOrder : Qt.AscendingOrder
                }

                view.model.sort(0, view.sortOrder);

                // After sorting we need update selection
                __resetSelection();
            }

            function __resetSelection() {
                // NOTE: Making a forced copy of the list
                let selectedIndexes = Array(...view.selectionModel.selectedIndexes)
                let currentIndex = view.selectionModel.currentIndex.row;
                view.selectionModel.clear();

                for (let i in selectedIndexes) {
                    view.selectionModel.select(selectedIndexes[i], ItemSelectionModel.Select);
                }

                view.selectionModel.setCurrentIndex(view.model.index(currentIndex, 0), ItemSelectionModel.Select);
            }

            headerComponents: [
                Tables.HeaderComponent {
                    width: 200
                    title: i18nc("@title:column", "Book")
                    textRole: "title"
                    role: BookRoles.TitleRole
                },

                Tables.HeaderComponent {
                    width: 200
                    title: i18nc("@title:column", "Author")
                    textRole: "author"
                    role: BookRoles.AuthorRole
                    draggable: true

                    leading: LingmoUI.Icon {
                        source: "social"
                        implicitWidth: view.compact ? LingmoUI.Units.iconSizes.small : LingmoUI.Units.iconSizes.medium
                        implicitHeight: implicitWidth
                    }
                },

                Tables.HeaderComponent {
                    width: 100
                    title: i18nc("@title:column", "Year")
                    textRole: "year"
                    role: BookRoles.YearRole
                    draggable: true
                },

                Tables.HeaderComponent {
                    width: 100
                    title: i18nc("@title:column", "Rating")
                    textRole: "rating"
                    role: BookRoles.RatingRole
                    draggable: true

                    leading: LingmoUI.Icon {
                        source: "star-shape"
                        implicitWidth: view.compact ? LingmoUI.Units.iconSizes.small : LingmoUI.Units.iconSizes.medium
                        implicitHeight: implicitWidth
                    }
                }
            ]
        }
    }

    ListModel {
        id: __exampleModel

        ListElement {
            title: "Harry Potter and the Philosopher's Stone"
            author: "J.K. Rowling"
            year: 1997
            rating: 4.5
        }

        ListElement {
            title: "Harry Potter and the Philosopher's Stone"
            author: "J.K. Rowling"
            year: 1997
            rating: 4.5
        }

        ListElement {
            title: "Harry Potter and the Philosopher's Stone"
            author: "J.K. Rowling"
            year: 1997
            rating: 4.5
        }

        ListElement {
            title: "Harry Potter and the Philosopher's Stone"
            author: "J.K. Rowling"
            year: 1997
            rating: 4.5
        }
    }
}
