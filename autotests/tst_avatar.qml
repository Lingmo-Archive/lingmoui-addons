/*
 *  SPDX-FileCopyrightText: 2020 Janet Blackquill <uhhadd@gmail.com>
 *  SPDX-FileCopyrightText: 2023 ivan tkachenko <me@ratijas.tk>
 *
 *  SPDX-License-Identifier: LGPL-2.0-or-later
 */

import QtQuick
import QtQuick.Controls as QQC2
import QtQuick.Templates as T
import QtTest

import org.kde.lingmoui as LingmoUI
import org.kde.lingmouiaddons.components as LingmoUIComponents

Item {
    id: root

    width: 110
    height: 110 * 3

    TestCase {
        name: "AvatarTests"
        function test_latin_name() {
            compare(LingmoUIComponents.NameUtils.isStringUnsuitableForInitials("Nate Martin"), false)
            compare(LingmoUIComponents.NameUtils.initialsFromString("Nate Martin"), "NM")

            compare(LingmoUIComponents.NameUtils.isStringUnsuitableForInitials("Kalanoka"), false)
            compare(LingmoUIComponents.NameUtils.initialsFromString("Kalanoka"), "K")

            compare(LingmoUIComponents.NameUtils.isStringUnsuitableForInitials("Why would anyone use such a long not name in the field of the Name"), false)
            compare(LingmoUIComponents.NameUtils.initialsFromString("Why would anyone use such a long not name in the field of the Name"), "WN")

            compare(LingmoUIComponents.NameUtils.isStringUnsuitableForInitials("Live-CD User"), false)
            compare(LingmoUIComponents.NameUtils.initialsFromString("Live-CD User"), "LU")
        }
        // these are just randomly sampled names from internet pages in the
        // source languages of the name
        function test_jp_name() {
            compare(LingmoUIComponents.NameUtils.isStringUnsuitableForInitials("北里 柴三郎"), false)
            compare(LingmoUIComponents.NameUtils.initialsFromString("北里 柴三郎"), "北")

            compare(LingmoUIComponents.NameUtils.isStringUnsuitableForInitials("小野田 寛郎"), false)
            compare(LingmoUIComponents.NameUtils.initialsFromString("小野田 寛郎"), "小")
        }
        function test_cn_name() {
            compare(LingmoUIComponents.NameUtils.isStringUnsuitableForInitials("蔣經國"), false)
            compare(LingmoUIComponents.NameUtils.initialsFromString("蔣經國"), "蔣")
        }
        function test_cyrillic_name() {
            compare(LingmoUIComponents.NameUtils.isStringUnsuitableForInitials("Нейт Мартин"), false)
            compare(LingmoUIComponents.NameUtils.initialsFromString("Нейт Мартин"), "НМ")

            compare(LingmoUIComponents.NameUtils.isStringUnsuitableForInitials("Каланока"), false)
            compare(LingmoUIComponents.NameUtils.initialsFromString("Каланока"), "К")

            compare(LingmoUIComponents.NameUtils.isStringUnsuitableForInitials("Зачем кому-то использовать такое длинное не имя в поле Имя"), false)
            compare(LingmoUIComponents.NameUtils.initialsFromString("Зачем кому-то использовать такое длинное не имя в поле Имя"), "ЗИ")

            compare(LingmoUIComponents.NameUtils.isStringUnsuitableForInitials("Пользователь Лайв-СИДИ"), false)
            compare(LingmoUIComponents.NameUtils.initialsFromString("Лайв-СИДИ Пользователь"), "ЛП")
        }
        function test_bad_names() {
            compare(LingmoUIComponents.NameUtils.isStringUnsuitableForInitials("151231023"), true)
        }
    }

    TestCase {
        name: "AvatarActions"

        width: 110
        height: 110 * 1
        visible: true
        when: windowShown

        LingmoUIComponents.AvatarButton {
            id: avatarButton

            x: 5
            y: 5
            width: 100
            height: 100

            activeFocusOnTab: true
        }

        function test_avatar_type() {
            // Implies that it is clickable, keyboard-interactible, and supports actions.
            verify(avatarButton instanceof T.AbstractButton)
        }
    }

    TestCase {
        name: "AvatarColors"
        y: 110 * 1
        width: 110
        height: 110 * 2
        visible: true
        when: windowShown

        LingmoUIComponents.Avatar {
            id: avatarWithDefaultInitialsColor

            x: 5
            y: 5
            width: 100
            height: 100
        }

        LingmoUIComponents.Avatar {
            id: avatarWithNonWritableColors

            x: 5
            y: 110 + 5
            width: 100
            height: 100
        }

        function checkInitialsColorIsDefault(avatar) {
            compare(avatar.initialsColor, avatar.defaultInitialsColor);
        }

        function test_initialsColors() {
            checkInitialsColorIsDefault(avatarWithDefaultInitialsColor);
            avatarWithDefaultInitialsColor.initialsColor = "red";
            verify(Qt.colorEqual(avatarWithDefaultInitialsColor.initialsColor, "red"));
            // Test reset
            avatarWithDefaultInitialsColor.initialsColor = Qt.binding(() => avatarWithDefaultInitialsColor.defaultInitialsColor);
            checkInitialsColorIsDefault(avatarWithDefaultInitialsColor);
        }

        function test_defaultColorIsNotWritable() {
            let failed = false;
            try {
                avatarWithNonWritableColors.defaultInitialsColor = "red";
            } catch (ex) {
                failed = true;
            }
            verify(failed);
            checkInitialsColorIsDefault(avatarWithNonWritableColors);
        }
    }
}
