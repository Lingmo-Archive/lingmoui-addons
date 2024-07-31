/*
 *  SPDX-FileCopyrightText: 2020 Arjen Hiemstra <ahiemstra@heimr.nl>
 *
 *  SPDX-License-Identifier: LGPL-2.0-or-later
 */

#include <QtQuickTest>
#include <QQmlEngine>
#include <QQmlContext>

#include <KLocalizedContext>
#include <KLocalizedString>

#include "example_albummodel.h"

class LingmoUIAddonsSetup : public QObject
{
    Q_OBJECT

public:
    LingmoUIAddonsSetup()
    {
    }

public Q_SLOTS:
    void qmlEngineAvailable(QQmlEngine *engine)
    {
        KLocalizedString::setApplicationDomain("lingmoui-addons");
        engine->rootContext()->setContextObject(new KLocalizedContext(engine));

        qmlRegisterType<ExampleAlbumModel>("test.artefacts", 1, 0, "ExampleAlbumModel");

        engine->rootContext()->setContextProperty(QLatin1String("dataDir"), QVariant(QLatin1String(DATA_DIR)));
    }
};

QUICK_TEST_MAIN_WITH_SETUP(LingmoUIAddons, LingmoUIAddonsSetup)

#include "qmltests.moc"
