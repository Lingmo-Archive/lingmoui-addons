// SPDX-FileCopyrightText: 2024 Carl Schwan <carlschwan@kde.org>
// SPDX-License-Identifier: LGPL-2.1-only or LGPL-3.0-only or LicenseRef-KDE-Accepted-LGPL

#include "defaultapplication.h"

DefaultLingmoUIApplication::DefaultLingmoUIApplication(QObject *parent)
    : AbstractLingmoUIApplication(parent)
{
    setupActions();
}

void DefaultLingmoUIApplication::setupActions()
{
    AbstractLingmoUIApplication::setupActions();

    readSettings();
}

#include "moc_defaultapplication.cpp"
