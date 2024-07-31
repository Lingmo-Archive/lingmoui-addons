// SPDX-License-Identifier: LGPL-2.1-only OR LGPL-3.0-only OR LicenseRef-KDE-Accepted-LGPL
// SPDX-FileCopyrightText: 2024 Carl Schwan <carl@carlschwan.eu>

#pragma once

#include <AbstractLingmoUIApplication>
#include <QObject>
#include <QQmlEngine>
#include <QSortFilterProxyModel>

class DefaultLingmoUIApplication : public AbstractLingmoUIApplication
{
    Q_OBJECT
    QML_ELEMENT
    QML_SINGLETON

public:
    explicit DefaultLingmoUIApplication(QObject *parent = nullptr);

private:
    void setupActions() override;
};
