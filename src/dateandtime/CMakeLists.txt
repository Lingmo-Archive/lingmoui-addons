# SPDX-FileCopyrightText: 2019 David Edmundson <kde@davidedmundson.co.uk>
# SPDX-License-Identifier: BSD-2-Clause

if (ANDROID)
    add_library(KF6LingmoUIDateAndTime)
    add_library(KF6::LingmoUIDateAndTime ALIAS KF6LingmoUIDateAndTime)
    target_sources(KF6LingmoUIDateAndTime PRIVATE
        lib/androidintegration.cpp
    )
    generate_export_header(KF6LingmoUIDateAndTime BASE_NAME LingmoUIDateAndTime)
    target_link_libraries(KF6LingmoUIDateAndTime PUBLIC Qt6::Core)
    add_subdirectory(android)
    install(TARGETS KF6LingmoUIDateAndTime ${KDE_INSTALL_TARGETS_DEFAULT_ARGS})
endif()

ecm_add_qml_module(dateandtimeplugin URI "org.kde.lingmouiaddons.dateandtime" VERSION 1.0)

target_compile_definitions(dateandtimeplugin PRIVATE -DTRANSLATION_DOMAIN=\"lingmoui-addons\")

target_sources(dateandtimeplugin PRIVATE
    lib/yearmodel.cpp
    lib/monthmodel.cpp
    lib/plugin.cpp
    lib/infinitecalendarviewmodel.cpp
)

ecm_target_qml_sources(dateandtimeplugin SOURCES
    DatePopup.qml
    TimePopup.qml
    TimePicker.qml
)

ecm_target_qml_sources(dateandtimeplugin PATH private SOURCES
    private/DatePathView.qml
    private/DatePicker.qml
    private/DatePickerDelegate.qml
)

target_link_libraries(dateandtimeplugin PRIVATE
    Qt6::Quick
    Qt6::Qml
    KF6::I18n
)
if (TARGET KF6LingmoUIDateAndTime)
    target_link_libraries(dateandtimeplugin PRIVATE KF6LingmoUIDateAndTime)
endif()

ecm_finalize_qml_module(dateandtimeplugin DESTINATION ${KDE_INSTALL_QMLDIR})
