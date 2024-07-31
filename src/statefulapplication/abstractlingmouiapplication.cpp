// SPDX-FileCopyrightText: 2023 Carl Schwan <carlschwan@kde.org>
// SPDX-License-Identifier: LGPL-2.1-or-later

#include "abstractlingmouiapplication.h"
#include "commandbarfiltermodel_p.h"
#include "actionsmodel_p.h"
#include "shortcutsmodel_p.h"
#include <KAboutData>
#include <KAuthorized>
#include <KConfigGroup>
#include <KLocalizedString>
#include <KSharedConfig>
#include <QGuiApplication>

using namespace std::chrono_literals;
using namespace Qt::StringLiterals;

class AbstractLingmoUIApplication::Private
{
public:
    KCommandBarModel *actionModel = nullptr;
    QSortFilterProxyModel *proxyModel = nullptr;
    LingmoUIActionCollection *collection = nullptr;
    ShortcutsModel *shortcutsModel = nullptr;
    QObject *configurationView = nullptr;
    QAction *openConfigurationViewAction = nullptr;
};

AbstractLingmoUIApplication::AbstractLingmoUIApplication(QObject *parent)
    : QObject(parent)
    , d(std::make_unique<Private>())
{
    d->collection = new LingmoUIActionCollection(parent);
}

AbstractLingmoUIApplication::~AbstractLingmoUIApplication()
{
    if (d->actionModel) {
        auto lastUsedActions = d->actionModel->lastUsedActions();
        auto cfg = KSharedConfig::openConfig();
        KConfigGroup cg(cfg, QStringLiteral("General"));
        cg.writeEntry("CommandBarLastUsedActions", lastUsedActions);
    }
}

/**
 * A helper function that takes a list of KActionCollection* and converts it
 * to KCommandBar::ActionGroup
 */
static QList<KCommandBarModel::ActionGroup> actionCollectionToActionGroup(const QList<LingmoUIActionCollection *> &actionCollections)
{
    using ActionGroup = KCommandBarModel::ActionGroup;

    QList<ActionGroup> actionList;
    actionList.reserve(actionCollections.size());

    for (const auto collection : actionCollections) {
        const auto collectionActions = collection->actions();
        const auto componentName = collection->componentDisplayName();

        ActionGroup ag;
        ag.name = componentName;
        ag.actions.reserve(collection->count());
        for (const auto action : collectionActions) {
            if (action && !action->text().isEmpty()) {
                ag.actions.append(action);
            }
        }
        actionList.append(ag);
    }
    return actionList;
}

void AbstractLingmoUIApplication::readSettings()
{
    const auto collections = actionCollections();
    for (const auto collection : collections) {
        collection->readSettings();
    }
}

QSortFilterProxyModel *AbstractLingmoUIApplication::actionsModel()
{
    if (!d->proxyModel) {
        d->actionModel = new KCommandBarModel(this);
        d->proxyModel = new CommandBarFilterModel(this);
        d->proxyModel->setSortRole(KCommandBarModel::Score);
        d->proxyModel->setFilterRole(Qt::DisplayRole);
        d->proxyModel->setSourceModel(d->actionModel);
    }

    // setLastUsedActions
    auto cfg = KSharedConfig::openConfig();
    KConfigGroup cg(cfg, QStringLiteral("General"));

    const auto actionNames = cg.readEntry(QStringLiteral("CommandBarLastUsedActions"), QStringList());

    d->actionModel->setLastUsedActions(actionNames);
    d->actionModel->refresh(actionCollectionToActionGroup(actionCollections()));
    return d->proxyModel;
}

QAbstractListModel *AbstractLingmoUIApplication::shortcutsModel()
{
    if (!d->shortcutsModel) {
        d->shortcutsModel = new ShortcutsModel(this);
    }

    d->shortcutsModel->refresh(actionCollections());
    return d->shortcutsModel;
}

QAction *AbstractLingmoUIApplication::action(const QString &name)
{
    const auto collections = actionCollections();
    for (const auto collection : collections) {
        auto resultAction = collection->action(name);
        if (resultAction) {
            return resultAction;
        }
    }

    qWarning() << "Not found action for name" << name;

    return nullptr;
}

QList<LingmoUIActionCollection *> AbstractLingmoUIApplication::actionCollections() const
{
    return QList{
        d->collection,
    };
}

LingmoUIActionCollection *AbstractLingmoUIApplication::mainCollection() const
{
    return d->collection;
}

void AbstractLingmoUIApplication::setupActions()
{
    auto actionName = QLatin1StringView("open_kcommand_bar");
    if (KAuthorized::authorizeAction(actionName)) {
        auto openKCommandBarAction = d->collection->addAction(actionName, this, &AbstractLingmoUIApplication::openKCommandBarAction);
        openKCommandBarAction->setText(i18n("Open Command Bar"));
        openKCommandBarAction->setIcon(QIcon::fromTheme(QStringLiteral("new-command-alarm")));

        d->collection->addAction(openKCommandBarAction->objectName(), openKCommandBarAction);
        d->collection->setDefaultShortcut(openKCommandBarAction, QKeySequence(Qt::CTRL | Qt::ALT | Qt::Key_I));
    }

    actionName = QLatin1StringView("file_quit");
    if (KAuthorized::authorizeAction(actionName)) {
        auto action = KStandardActions::quit(this, &AbstractLingmoUIApplication::quit, this);
        d->collection->addAction(action->objectName(), action);
    }

    actionName = QLatin1StringView("options_configure_keybinding");
    if (KAuthorized::authorizeAction(actionName)) {
        auto keyBindingsAction = KStandardActions::keyBindings(this, &AbstractLingmoUIApplication::shortcutsEditorAction, this);
        d->collection->addAction(keyBindingsAction->objectName(), keyBindingsAction);
    }

    actionName = QLatin1StringView("open_about_page");
    if (KAuthorized::authorizeAction(actionName)) {
        auto action = d->collection->addAction(actionName, this, &AbstractLingmoUIApplication::openAboutPage);
        action->setText(i18n("About %1", KAboutData::applicationData().displayName()));
        action->setIcon(QIcon::fromTheme(QStringLiteral("help-about")));
    }

    actionName = QLatin1StringView("open_about_kde_page");
    if (KAuthorized::authorizeAction(actionName)) {
        auto action = d->collection->addAction(actionName, this, &AbstractLingmoUIApplication::openAboutKDEPage);
        action->setText(i18n("About KDE"));
        action->setIcon(QIcon::fromTheme(QStringLiteral("kde")));

        if (KAboutData::applicationData().desktopFileName().startsWith(u"org.kde."_s)) {
            action->setVisible(false);
        }
    }
}

void AbstractLingmoUIApplication::quit()
{
    qGuiApp->exit();
}

QObject *AbstractLingmoUIApplication::configurationView() const
{
    return d->configurationView;
}

void AbstractLingmoUIApplication::setConfigurationView(QObject *configurationView)
{
    if (d->configurationView == configurationView) {
        return;
    }

    if (d->configurationView) {
        d->openConfigurationViewAction->setVisible(false);
    }

    d->configurationView = configurationView;
    Q_EMIT configurationViewChanged();

    if (d->configurationView) {
        if (!d->openConfigurationViewAction) {
            // TODO also expose individual ConfigurationModule as action
            d->openConfigurationViewAction = KStandardActions::preferences(this, [this]() {
                QMetaObject::invokeMethod(d->configurationView, "open", Qt::QueuedConnection, QVariant());
            }, this);
            mainCollection()->addAction(d->openConfigurationViewAction->objectName(), d->openConfigurationViewAction);
        }
        d->openConfigurationViewAction->setVisible(true);

        mainCollection()->readSettings();
    }
}

#include "moc_abstractlingmouiapplication.cpp"
