# SPDX-FileCopyrightText: 2022 Volker Krause <vkrause@kde.org>
# SPDX-License-Identifier: BSD-2-Clause

gradle_add_aar(datetime_aar BUILDFILE ${CMAKE_CURRENT_SOURCE_DIR}/build.gradle NAME KF6LingmoUIDateAndTime)
gradle_install_aar(datetime_aar DESTINATION jar)

install(
    FILES KF6LingmoUIDateAndTime-android-dependencies.xml
    DESTINATION ${KDE_INSTALL_LIBDIR}
    RENAME KF6LingmoUIDateAndTime_${CMAKE_ANDROID_ARCH_ABI}-android-dependencies.xml
)
