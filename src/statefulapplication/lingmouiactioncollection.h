/*
    This file is part of the KDE libraries
    SPDX-FileCopyrightText: 1999 Reginald Stadlbauer <reggie@kde.org>
    SPDX-FileCopyrightText: 1999 Simon Hausmann <hausmann@kde.org>
    SPDX-FileCopyrightText: 2000 Nicolas Hadacek <haadcek@kde.org>
    SPDX-FileCopyrightText: 2000 Kurt Granroth <granroth@kde.org>
    SPDX-FileCopyrightText: 2000 Michael Koch <koch@kde.org>
    SPDX-FileCopyrightText: 2001 Holger Freyther <freyther@kde.org>
    SPDX-FileCopyrightText: 2002 Ellis Whitehead <ellis@kde.org>
    SPDX-FileCopyrightText: 2005-2006 Hamish Rodda <rodda@kde.org>

    SPDX-License-Identifier: LGPL-2.0-only
*/

#pragma once

#include <lingmouiaddonsstatefulapp_export.h>
#include <KStandardActions>

#include <QAction>
#include <QObject>
#include <memory>

class KConfigGroup;
class QActionGroup;
class QString;

/**
 * @class LingmoUIActionCollection lingmouiactioncollection.h LingmoUIActionCollection
 *
 * \short A container for a set of QAction objects.
 *
 * LingmoUIActionCollection manages a set of QAction objects.  It
 * allows them to be grouped for organized presentation of configuration to the user,
 * saving + loading of configuration, and optionally for automatic plugging into
 * specified widget(s).
 *
 * Additionally, LingmoUIActionCollection provides several convenience functions for locating
 * named actions, and actions grouped by QActionGroup.
 *
 * @since LingmoUIAddons 1.4.0
 */
class LINGMOUIADDONSSTATEFULAPP_EXPORT LingmoUIActionCollection : public QObject
{
    Q_OBJECT

    Q_PROPERTY(QString configGroup READ configGroup WRITE setConfigGroup)
    Q_PROPERTY(bool configIsGlobal READ configIsGlobal WRITE setConfigGlobal)

public:
    /**
     * Constructor.  Allows specification of a component name other than the default
     * application name, where needed (remember to call setComponentDisplayName() too).
     */
    explicit LingmoUIActionCollection(QObject *parent, const QString &cName = QString());

    /**
     * Destructor.
     */
    ~LingmoUIActionCollection() override;

    /**
     * Access the list of all action collections in existence for this app
     */
    static const QList<LingmoUIActionCollection *> &allCollections();

    /**
     * Clears the entire action collection, deleting all actions.
     */
    void clear();

    /**
     * Returns the KConfig group with which settings will be loaded and saved.
     */
    QString configGroup() const;

    /**
     * Returns whether this action collection's configuration should be global to KDE ( @c true ),
     * or specific to the application ( @c false ).
     */
    bool configIsGlobal() const;

    /**
     * Sets @p group as the KConfig group with which settings will be loaded and saved.
     */
    void setConfigGroup(const QString &group);

    /**
     * Set whether this action collection's configuration should be global to KDE ( @c true ),
     * or specific to the application ( @c false ).
     */
    void setConfigGlobal(bool global);

    /**
     * Read all key associations from @p config.
     *
     * If @p config is zero, read all key associations from the
     * application's configuration file KSharedConfig::openConfig(),
     * in the group set by setConfigGroup().
     */
    void readSettings(KConfigGroup *config = nullptr);

    /**
     * Write the current configurable key associations to @p config. What the
     * function does if @p config is zero depends. If this action collection
     * belongs to a KXMLGUIClient the setting are saved to the kxmlgui
     * definition file. If not the settings are written to the applications
     * config file.
     *
     * \note @p oneAction and @p writeDefaults have no meaning for the kxmlgui
     * configuration file.
     *
     * \param config Config object to save to, or null (see above)
     * \param writeDefaults set to true to write settings which are already at defaults.
     * \param oneAction pass an action here if you just want to save the values for one action, eg.
     *                  if you know that action is the only one which has changed.
     */
    void writeSettings(KConfigGroup *config = nullptr, bool writeDefaults = false, QAction *oneAction = nullptr) const;

    /**
     * Returns the number of actions in the collection.
     *
     * This is equivalent to actions().count().
     */
    int count() const;

    /**
     * Returns whether the action collection is empty or not.
     */
    bool isEmpty() const;

    /**
     * Return the QAction* at position @p index in the action collection.
     *
     * This is equivalent to actions().value(index);
     */
    QAction *action(int index) const;

    /**
     * Get the action with the given \p name from the action collection.
     *
     * This won't return the action for the menus defined using a "<Menu>" tag
     * in XMLGUI files (e.g. "<Menu name="menuId">" in "applicationNameui.rc").
     * To access menu actions defined like this, use e.g.
     * \code
     * qobject_cast<QMenu *>(guiFactory()->container("menuId", this));
     * \endcode
     * after having called setupGUI() or createGUI().
     *
     * @param name Name of the QAction
     * @return A pointer to the QAction in the collection which matches the parameters or
     * null if nothing matches.
     */
    Q_INVOKABLE QAction *action(const QString &name) const;

    /**
     * Returns the list of QActions which belong to this action collection.
     *
     * The list is guaranteed to be in the same order the action were put into
     * the collection.
     */
    QList<QAction *> actions() const;

    /**
     * Returns the list of QActions without an QAction::actionGroup() which belong to this action collection.
     */
    const QList<QAction *> actionsWithoutGroup() const;

    /**
     * Returns the list of all QActionGroups associated with actions in this action collection.
     */
    const QList<QActionGroup *> actionGroups() const;

    /**
     * Set the @p componentName associated with this action collection.
     *
     * \warning Don't call this method on a LingmoUIActionCollection that contains
     * actions. This is not supported.
     *
     * \param componentData the name which is to be associated with this action collection,
     * or QString() to indicate the app name. This is used to load/save settings into XML files.
     * KXMLGUIClient::setComponentName takes care of calling this.
     */
    void setComponentName(const QString &componentName);

    /** The component name with which this class is associated. */
    QString componentName() const;

    /**
     * Set the component display name associated with this action collection.
     * (e.g. for the toolbar editor)
     * KXMLGUIClient::setComponentName takes care of calling this.
     */
    void setComponentDisplayName(const QString &displayName);

    /** The display name for the associated component. */
    QString componentDisplayName() const;

Q_SIGNALS:
    /**
     * Indicates that @p action was inserted into this action collection.
     */
    void inserted(QAction *action);

    /**
     * Emitted when an action has been inserted into, or removed from, this action collection.
     */
    void changed();

    /**
     * Indicates that @p action was hovered.
     */
    void actionHovered(QAction *action);

    /**
     * Indicates that @p action was triggered
     */
    void actionTriggered(QAction *action);

protected:
    /// Overridden to perform connections when someone wants to know whether an action was highlighted or triggered
    void connectNotify(const QMetaMethod &signal) override;

protected Q_SLOTS:
    virtual void slotActionTriggered();

private Q_SLOTS:
    LINGMOUIADDONSSTATEFULAPP_NO_EXPORT void slotActionHovered();

public:
    /**
     * Add an action under the given name to the collection.
     *
     * Inserting an action that was previously inserted under a different name will replace the
     * old entry, i.e. the action will not be available under the old name anymore but only under
     * the new one.
     *
     * Inserting an action under a name that is already used for another action will replace
     * the other action in the collection (but will not delete it).
     *
     * If KAuthorized::authorizeAction() reports that the action is not
     * authorized, it will be disabled and hidden.
     *
     * The ownership of the action object is not transferred.
     * If the action is destroyed it will be removed automatically from the LingmoUIActionCollection.
     *
     * @param name The name by which the action be retrieved again from the collection.
     * @param action The action to add.
     * @return the same as the action given as parameter. This is just for convenience
     * (chaining calls) and consistency with the other addAction methods, you can also
     * simply ignore the return value.
     */
    Q_INVOKABLE QAction *addAction(const QString &name, QAction *action);

    /**
     * Adds a list of actions to the collection.
     *
     * The objectName of the actions is used as their internal name in the collection.
     *
     * The ownership of the action objects is not transferred.
     * If the action is destroyed it will be removed automatically from the LingmoUIActionCollection.
     *
     * Uses addAction(const QString&, QAction*).
     *
     * @param actions the list of the actions to add.
     *
     * @see addAction()
     */
    void addActions(const QList<QAction *> &actions);

    /**
     * Removes an action from the collection and deletes it.
     * @param action The action to remove.
     */
    void removeAction(QAction *action);

    /**
     * Removes an action from the collection.
     *
     * The ownership of the action object is not changed.
     *
     * @param action the action to remove.
     */
    QAction *takeAction(QAction *action);

#ifdef K_DOXYGEN
    /**
     * Creates a new standard action, adds it to the collection and connects the
     * action's triggered(bool) signal to the specified receiver/member. The
     * newly created action is also returned.
     *
     * The action can be retrieved later from the collection by its standard name as per
     * KStandardActions::stdName.
     *
     * The LingmoUIActionCollection takes ownership of the action object.
     *
     * @param actionType The standard action type of the action to create.
     * @param name The name by which the action be retrieved again from the collection.
     * @param receiver The QObject to connect the triggered(bool) signal to.
     * @param slot The slot or lambda to connect the triggered(bool) signal to.
     * @return new action of the given type ActionType.
     */
    inline QAction *addAction(KStandardActions::StandardAction actionType, const QString &name, const Receiver *receiver, Func slot)
#else
    template<class Receiver, class Func>
    inline typename std::enable_if<!std::is_convertible<Func, const char *>::value, QAction>::type *
    addAction(KStandardActions::StandardAction actionType, const QString &name, const Receiver *receiver, Func slot)
#endif
    {
        QAction *action = KStandardActions::create(actionType, receiver, slot, nullptr);
        action->setParent(this);
        action->setObjectName(name);
        return addAction(name, action);
    }

#ifdef K_DOXYGEN
    /**
     * Creates a new action under the given name, adds it to the collection and
     * connects the action's triggered(bool) signal to the specified
     * receiver/member.
     *
     * The type of the action is specified by the template parameter ActionType.
     *
     * The LingmoUIActionCollection takes ownership of the action object.
     *
     * @param name The internal name of the action (e.g. "file-open").
     * @param receiver The QObject to connect the triggered(bool) signal to.
     * @param slot The slot or lambda to connect the triggered(bool) signal to.
     * @return new action of the given type ActionType.
     *
     * @see add(const QString &, const QObject *, const char *)
     */
    template<class ActionType>
    inline ActionType *add(const QString &name, const Receiver *receiver, Func slot)
#else
    template<class ActionType, class Receiver, class Func>
    inline typename std::enable_if<!std::is_convertible<Func, const char *>::value, ActionType>::type *
    add(const QString &name, const Receiver *receiver, Func slot)
#endif
    {
        ActionType *a = new ActionType(this);
        connect(a, &QAction::triggered, receiver, slot);
        addAction(name, a);
        return a;
    }

#ifdef K_DOXYGEN
    /**
     * Creates a new action under the given name to the collection and connects
     * the action's triggered(bool) signal to the specified receiver/member. The
     * newly created action is returned.
     *
     * @param name The internal name of the action (e.g. "file-open").
     * @param receiver The QObject to connect the triggered(bool) signal to.
     * @param slot The slot or lambda to connect the triggered(bool) signal to.
     * @return new action of the given type ActionType.
     */
    inline QAction *addAction(const QString &name, const Receiver *receiver, Func slot)
#else
    template<class Receiver, class Func>
    inline typename std::enable_if<!std::is_convertible<Func, const char *>::value, QAction>::type *
    addAction(const QString &name, const Receiver *receiver, Func slot)
#endif
    {
        return add<QAction>(name, receiver, slot);
    }

    /**
     * Get the default primary shortcut for the given action.
     *
     * @param action the action for which the default primary shortcut should be returned.
     * @return the default primary shortcut of the given action
     */
    static QKeySequence defaultShortcut(QAction *action);

    /**
     * Get the default shortcuts for the given action.
     *
     * @param action the action for which the default shortcuts should be returned.
     * @return the default shortcuts of the given action
     */
    static QList<QKeySequence> defaultShortcuts(QAction *action);

    /**
     * Set the default shortcut for the given action.
     *
     * @param action the action for which the default shortcut should be set.
     * @param shortcut the shortcut to use for the given action in its specified shortcutContext()
     */
    static void setDefaultShortcut(QAction *action, const QKeySequence &shortcut);

    /**
     * Set the default shortcuts for the given action.
     *
     * @param action the action for which the default shortcut should be set.
     * @param shortcuts the shortcuts to use for the given action in its specified shortcutContext()
     */
    Q_INVOKABLE static void setDefaultShortcuts(QAction *action, const QList<QKeySequence> &shortcuts);

    /**
     * Returns true if the given action's shortcuts may be configured by the user.
     *
     * @param action the action for the hint should be verified.
     */
    static bool isShortcutsConfigurable(QAction *action);

    /**
     * Indicate whether the user may configure the action's shortcuts.
     *
     * @param action the action for the hint should be verified.
     * @param configurable set to true if the shortcuts of the given action may be configured by the user, otherwise false.
     */
    static void setShortcutsConfigurable(QAction *action, bool configurable);

private:
    friend class LingmoUIActionCollectionPrivate;
    std::unique_ptr<class LingmoUIActionCollectionPrivate> const d;
};
