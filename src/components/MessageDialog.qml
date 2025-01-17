// SPDX-FileCopyrightText: 2021 Claudio Cambra <claudio.cambra@gmail.com>
// SPDX-FileCopyrightText: 2023 Carl Schwan <carl@carlschwan.eu>
// SPDX-License-Identifier: LGPL-2.1-or-later

import QtQuick
import QtQuick.Controls as QQC2
import QtQuick.Templates as T
import QtQuick.Layouts
import org.kde.lingmoui as LingmoUI
import org.kde.lingmouiaddons.components as Components
import org.kde.lingmouiaddons.formcard as FormCard
import org.kde.lingmouiaddons.delegates as Delegates

/**
 * A dialog to show a message. This dialog exists has 4 modes: success, warning, error, information.
 *
 * @image html messagedialog.png
 */
T.Dialog {
    id: root

    enum DialogType {
        Success,
        Warning,
        Error,
        Information
    }

    /**
     * This property holds the dialogType. It can be either:
     *
     * - `MessageDialog.Success`: For a sucess message
     * - `MessageDialog.Warning`: For a warning message
     * - `MessageDialog.Error`: For an actual error
     * - `MessageDialog.Information`: For an informational message
     *
     * By default, the dialogType is `MessageDialog.Success`
     */
    property int dialogType: Components.MessageDialog.Success

    /**
     * @brief This property holds the name of setting to store the "dont's show again" preference.
     *
     * If provided, a checkbox is added with which further notifications can be turned off.
     * The string is used to lookup and store the setting in the applications config file.
     * The setting is stored in the "Notification Messages" group.
     *
     * When set use, openDialog() instead of open() to open this dialog.
     *
     * @warning Overwriting the dialog's footer will disable this feature.
     */
    property string dontShowAgainName: ''

    default property alias mainContent: mainLayout.data

    property string iconName: switch (root.dialogType) {
    case MessageDialog.Success:
        return "data-success";
    case MessageDialog.Warning:
        return "data-warning";
    case MessageDialog.Error:
        return "data-error";
    case MessageDialog.Information:
        return "data-information";
    default:
        return "data-warning";
    }

    x: Math.round((parent.width - width) / 2)
    y: Math.round((parent.height - height) / 2)
    z: LingmoUI.OverlayZStacking.z

    parent: applicationWindow().QQC2.Overlay.overlay

    implicitWidth: Math.min(parent.width - LingmoUI.Units.gridUnit * 2, LingmoUI.Units.gridUnit * 20)
    implicitHeight: Math.min(Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             contentHeight + topPadding + bottomPadding
                             + (implicitHeaderHeight > 0 ? implicitHeaderHeight + spacing : 0)
                             + (implicitFooterHeight > 0 ? implicitFooterHeight + spacing : 0)), parent.height - LingmoUI.Units.gridUnit * 2, LingmoUI.Units.gridUnit * 30)

    title: switch (root.dialogType) {
    case MessageDialog.Success:
        return i18ndc("lingmoui-addons6", "@title:dialog", "Success");
    case MessageDialog.Warning:
        return i18ndc("lingmoui-addons6", "@title:dialog", "Warning");
    case MessageDialog.Error:
        return i18ndc("lingmoui-addons6", "@title:dialog", "Error");
    case MessageDialog.Information:
        return i18ndc("lingmoui-addons6", "@title:dialog", "Information");
    default:
        return i18ndc("lingmoui-addons6", "@title:dialog", "Warning");
    }

    padding: LingmoUI.Units.largeSpacing * 2
    bottomPadding: LingmoUI.Units.largeSpacing

    property bool _automaticallyClosed: false

    /**
     * Open the dialog only if the user didn't check the "do not remind me" checkbox
     * previously.
     */
    function openDialog(): void {
        if (root.dontShowAgainName.length > 0) {
            if (root.standardButtons === QQC2.Dialog.Ok) {
                const show = MessageDialogHelper.shouldBeShownContinue(root.dontShowAgainName);
                if (!show) {
                    root._automaticallyClosed = true;
                    root.applied();
                    root.accepted();
                } else {
                    checkbox.checked = false;
                    root._automaticallyClosed = false;
                    root.open();
                }
            } else {
                const result = MessageDialogHelper.shouldBeShownTwoActions(root.dontShowAgainName);
                if (!result.show) {
                    root._automaticallyClosed = true;
                    if (result.result) {
                        root.accepted();
                        root.applied();
                    } else {
                        root.discarded();
                    }
                } else {
                    checkbox.checked = false;
                    root._automaticallyClosed = false;
                    root.open();
                }
            }
        }
    }

    onApplied: {
        if (root.dontShowAgainName && checkbox.checked && !root._automaticallyClosed) {
            if (root.standardButtons === QQC2.Dialog.Ok) {
                MessageDialogHelper.saveDontShowAgainContinue(root.dontShowAgainName);
            } else {
                MessageDialogHelper.saveDontShowAgainTwoActions(root.dontShowAgainName, true);
            }
        }
    }

    onAccepted: {
        if (root.dontShowAgainName && checkbox.checked && !root._automaticallyClosed) {
            if (root.standardButtons === QQC2.Dialog.Ok) {
                MessageDialogHelper.saveDontShowAgainContinue(root.dontShowAgainName);
            } else {
                MessageDialogHelper.saveDontShowAgainTwoActions(root.dontShowAgainName, true);
            }
        }
    }

    onDiscarded: {
        if (root.dontShowAgainName && checkbox.checked && !root._automaticallyClosed) {
            if (root.standardButtons === QQC2.Dialog.Ok) {
                MessageDialogHelper.saveDontShowAgainContinue(root.dontShowAgainName);
            } else {
                MessageDialogHelper.saveDontShowAgainTwoActions(root.dontShowAgainName, false);
            }
        }
    }

    contentItem: GridLayout {
        id: gridLayout

        columns: icon.visible && root.width > LingmoUI.Units.gridUnit * 18 ? 2 : 1
        rowSpacing: LingmoUI.Units.largeSpacing

        LingmoUI.Icon {
            id: icon

            visible: root.iconName.length > 0
            source: root.iconName
            Layout.preferredWidth: LingmoUI.Units.iconSizes.huge
            Layout.preferredHeight: LingmoUI.Units.iconSizes.huge
            Layout.alignment: gridLayout.columns === 2 ? Qt.AlignTop : Qt.AlignHCenter
        }

        ColumnLayout {
            id: mainLayout

            spacing: LingmoUI.Units.smallSpacing

            Layout.fillWidth: true

            LingmoUI.Heading {
                text: root.title
                visible: root.title
                elide: QQC2.Label.ElideRight
                wrapMode: Text.WordWrap
                Layout.fillWidth: true
            }
        }
    }

    footer: RowLayout {
        spacing: LingmoUI.Units.largeSpacing

        FormCard.FormCheckDelegate {
            id: checkbox

            visible: dontShowAgainName.length > 0

            text: i18ndc("lingmoui-addons6", "@label:checkbox", "Do not show again")
            background: null

            Layout.fillWidth: true
        }

        QQC2.DialogButtonBox {
            leftPadding: LingmoUI.Units.largeSpacing + LingmoUI.Units.smallSpacing
            rightPadding: LingmoUI.Units.largeSpacing + LingmoUI.Units.smallSpacing
            bottomPadding: LingmoUI.Units.largeSpacing + LingmoUI.Units.smallSpacing
            topPadding: LingmoUI.Units.largeSpacing + LingmoUI.Units.smallSpacing

            standardButtons: root.standardButtons

            onAccepted: root.accepted();
            onDiscarded: root.discarded();
            onApplied: root.applied();
            onHelpRequested: root.helpRequested();
            onRejected: root.rejected();

            Layout.fillWidth: true
        }
    }

    enter: Transition {
        NumberAnimation {
            property: "opacity"
            from: 0
            to: 1
            easing.type: Easing.InOutQuad
            duration: LingmoUI.Units.longDuration
        }
    }

    exit: Transition {
        NumberAnimation {
            property: "opacity"
            from: 1
            to: 0
            easing.type: Easing.InOutQuad
            duration: LingmoUI.Units.longDuration
        }
    }

    modal: true
    focus: true

    background: Components.DialogRoundedBackground {}

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
