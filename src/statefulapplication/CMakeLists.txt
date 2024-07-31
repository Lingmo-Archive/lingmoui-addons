# SPDX-FileCopyrightText: 2024 Carl Schwan <carl@carlschwan.eu>
# SPDX-License-Identifier: LGPL-2.0-or-later

# StatefulApp module

add_library(LingmoUIAddonsStatefulApp SHARED
    abstractlingmouiapplication.cpp
    abstractlingmouiapplication.h
    lingmouiactioncollection.cpp
    lingmouiactioncollection.h
    actionsmodel.cpp
    actionsmodel_p.h
    commandbarfiltermodel.cpp
    commandbarfiltermodel_p.h
    shortcutsmodel.cpp
    shortcutsmodel_p.h
)

set_target_properties(LingmoUIAddonsStatefulApp PROPERTIES
    VERSION     ${PROJECT_VERSION}
    SOVERSION   6
    EXPORT_NAME "LingmoUIAddonsStatefulApp"
)

ecm_setup_version(PROJECT
    VARIABLE_PREFIX LINGMOUIADDONSBASEAPP
    PACKAGE_VERSION_FILE "${CMAKE_CURRENT_BINARY_DIR}/LingmoUIAddonsStatefulAppConfigVersion.cmake"
    SOVERSION 6
)

ecm_generate_export_header(LingmoUIAddonsStatefulApp
    VERSION ${PROJECT_VERSION}
    BASE_NAME LingmoUIAddonsStatefulApp
    DEPRECATION_VERSIONS
)

ecm_qt_declare_logging_category(LingmoUIAddonsStatefulApp
    HEADER debug.h
    IDENTIFIER BASEAPP_LOG
    CATEGORY_NAME org.kde.lingmouiaddons.statefulapp
    DESCRIPTION "Base App"
    EXPORT LINGMOUI_ADDONS
)

ecm_generate_headers(LingmoUIAddonsStatefulApp_HEADERS
    HEADER_NAMES
        LingmoUIActionCollection
        AbstractLingmoUIApplication
    REQUIRED_HEADERS
        LingmoUIAddonsStatefulApp_HEADERS
)

target_link_libraries(LingmoUIAddonsStatefulApp
    PUBLIC
        Qt6::Core
        Qt6::Qml
        Qt6::Quick
        KF6::ConfigGui
    PRIVATE
        KF6::I18n
        KF6::CoreAddons
)

target_include_directories(LingmoUIAddonsStatefulApp
    INTERFACE
        "$<INSTALL_INTERFACE:${KDE_INSTALL_INCLUDEDIR}/LingmoUIAddonsStatefulApp>"
)

# Qml plugin

ecm_add_qml_module(LingmoUIAddonsStatefulApp
    URI "org.kde.lingmouiaddons.statefulapp"
    VERSION 1.0
    GENERATE_PLUGIN_SOURCE
    DEPENDENCIES QtQuick
)

ecm_target_qml_sources(LingmoUIAddonsStatefulApp SOURCES
    StatefulWindow.qml
)

ecm_finalize_qml_module(LingmoUIAddonsStatefulApp DESTINATION ${KDE_INSTALL_QMLDIR})

# Install files

install(TARGETS LingmoUIAddonsStatefulApp EXPORT LingmoUIAddonsTargets ${KF_INSTALL_TARGETS_DEFAULT_ARGS})

install(FILES
    "${CMAKE_CURRENT_BINARY_DIR}/lingmouiaddonsstatefulapp_export.h"
    DESTINATION "${KDE_INSTALL_INCLUDEDIR}/LingmoUIAddonsStatefulApp"
    COMPONENT Devel
)

install(FILES
    ${LingmoUIAddonsStatefulApp_HEADERS}
    DESTINATION "${KDE_INSTALL_INCLUDEDIR}/LingmoUIAddonsStatefulApp"
    COMPONENT Devel
)

add_subdirectory(private)
add_subdirectory(labs)

