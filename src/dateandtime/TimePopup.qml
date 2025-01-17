// SPDX-FileCopyrightText: 2023 Carl Schwan <carl@carlschwan.eu>
// SPDX-License-Identifier: LGPL-2.0-or-later

import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15 as QQC2
import org.kde.lingmoui 2.20 as LingmoUI
import org.kde.lingmouiaddons.components 1.0 as Components

QQC2.Dialog {
    id: root

    /**
     * @brief The current date and time selected by the user.
     */
    property date value: new Date()

    /**
     * Emitted when the user accepts the dialog.
     * The selected date is available from the selectedDate property.
     */
    signal accepted()

    /**
     * Emitted when the user cancells the popup
     */
    signal cancelled()

    property date _value: new Date()

    modal: true

    contentItem: TimePicker {
        id: popupContent
        implicitWidth: applicationWindow().width
        minutes: root.value.getMinutes()
        hours: root.value.getHours()
        onMinutesChanged: {
            root._value.setHours(hours, minutes);
        }
        onHoursChanged: {
            root._value.setHours(hours, minutes);
        }
    }

    background: Components.DialogRoundedBackground {}

    footer: QQC2.DialogButtonBox {
        id: box

        QQC2.Button {
            text: i18ndc("lingmoui-addons6", "@action:button", "Cancel")
            icon.name: "dialog-cancel"
            onClicked: {
                root.cancelled()
                root.close()
            }

            QQC2.DialogButtonBox.buttonRole: QQC2.DialogButtonBox.RejectRole
        }

        QQC2.Button {
            text: i18ndc("lingmoui-addons6", "@action:button", "Select")
            icon.name: "dialog-ok-apply"
            onClicked: {
                root.value = root._value;
                root.accepted()
                root.close()
            }

            QQC2.DialogButtonBox.buttonRole: QQC2.DialogButtonBox.AcceptRole
        }
    }

    // black background, fades in and out
    QQC2.Overlay.modal: Rectangle {
        color: Qt.rgba(0, 0, 0, 0.3)

        // the opacity of the item is changed internally by QQuickPopup on open/close
        Behavior on opacity {
            OpacityAnimator {
                duration: LingmoUI.Units.longDuration
                easing.type: Easing.InOutQuad
            }
        }
    }
}
