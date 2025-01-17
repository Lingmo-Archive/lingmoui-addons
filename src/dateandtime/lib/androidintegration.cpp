/*
​ *  SPDX-FileCopyrightText: 2020 Nicolas Fella <nicolas.fella@gmx.de>
​ *  SPDX-FileCopyrightText: 2022 Volker Krause <vkrause@kde.org>
​ *
​ *  SPDX-License-Identifier: LGPL-2.0-or-later
​ */

#include "androidintegration.h"

#include <QCoreApplication>
#include <QJniObject>
#include <QDebug>

using namespace LingmoUIAddonsDateAndTime;

AndroidIntegration &AndroidIntegration::instance()
{
    static AndroidIntegration instance;
    return instance;
}

static void dateSelected(JNIEnv *env, jobject that, jint day, jint month, jint year)
{
    Q_UNUSED(that);
    Q_UNUSED(env);
    Q_EMIT AndroidIntegration::instance().datePickerFinished(true, QDate(year, month, day).startOfDay());
}

static void dateCancelled(JNIEnv *env, jobject that)
{
    Q_UNUSED(that);
    Q_UNUSED(env);
    Q_EMIT AndroidIntegration::instance().datePickerFinished(false, {});
}

static void timeSelected(JNIEnv *env, jobject that, jint hours, jint minutes)
{
    Q_UNUSED(that);
    Q_UNUSED(env);
    Q_EMIT AndroidIntegration::instance().timePickerFinished(true, QDateTime(QDate::currentDate(), QTime(hours, minutes)));
}

static void timeCancelled(JNIEnv *env, jobject that)
{
    Q_UNUSED(that);
    Q_UNUSED(env);
    Q_EMIT AndroidIntegration::instance().timePickerFinished(false, {});
}

static const JNINativeMethod dateMethods[] = {
    {"dateSelected", "(III)V", (void *)dateSelected},
    {"cancelled", "()V", (void *)dateCancelled}
};

static const JNINativeMethod timeMethods[] = {
    {"timeSelected", "(II)V", (void *)timeSelected},
    {"cancelled", "()V", (void *)timeCancelled}
};

Q_DECL_EXPORT jint JNICALL JNI_OnLoad(JavaVM *vm, void *)
{
    static bool initialized = false;
    if (initialized) {
        return JNI_VERSION_1_6;
    }
    initialized = true;

    JNIEnv *env = nullptr;
    if (vm->GetEnv((void **)&env, JNI_VERSION_1_4) != JNI_OK) {
        qWarning() << "Failed to get JNI environment.";
        return -1;
    }
    jclass theclass = env->FindClass("org/kde/lingmouiaddons/dateandtime/DatePicker");
    if (env->RegisterNatives(theclass, dateMethods, sizeof(dateMethods) / sizeof(JNINativeMethod)) < 0) {
        qWarning() << "Failed to register native functions.";
        return -1;
    }

    jclass timeclass = env->FindClass("org/kde/lingmouiaddons/dateandtime/TimePicker");
    if (env->RegisterNatives(timeclass, timeMethods, sizeof(timeMethods) / sizeof(JNINativeMethod)) < 0) {
        qWarning() << "Failed to register native functions.";
        return -1;
    }

    return JNI_VERSION_1_4;
}

void AndroidIntegration::showDatePicker(qint64 initialDate)
{
#if QT_VERSION >= QT_VERSION_CHECK(6, 7, 0)
    QJniObject picker("org/kde/lingmouiaddons/dateandtime/DatePicker", "(Landroid/app/Activity;J)V", QNativeInterface::QAndroidApplication::context().object<jobject>(), initialDate);
#else
    QJniObject picker("org/kde/lingmouiaddons/dateandtime/DatePicker", "(Landroid/app/Activity;J)V", QNativeInterface::QAndroidApplication::context(), initialDate);
#endif
    picker.callMethod<void>("doShow");
}

void AndroidIntegration::showTimePicker(qint64 initialTime)
{
#if QT_VERSION >= QT_VERSION_CHECK(6, 7, 0)
    QJniObject picker("org/kde/lingmouiaddons/dateandtime/TimePicker", "(Landroid/app/Activity;J)V", QNativeInterface::QAndroidApplication::context().object<jobject>(), initialTime);
#else
    QJniObject picker("org/kde/lingmouiaddons/dateandtime/TimePicker", "(Landroid/app/Activity;J)V", QNativeInterface::QAndroidApplication::context(), initialTime);
#endif
    picker.callMethod<void>("doShow");
}

#include "moc_androidintegration.cpp"
