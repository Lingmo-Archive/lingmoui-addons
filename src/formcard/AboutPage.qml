// SPDX-FileCopyrightText: 2018 Aleix Pol Gonzalez <aleixpol@blue-systems.com>
// SPDX-FileCopyrightText: 2021 Carl Schwan <carl@carlschwan.eu>
// SPDX-License-Identifier: LGPL-2.0-or-later

import QtQuick 2.15
import QtQuick.Controls 2.15 as QQC2
import QtQuick.Window 2.15
import QtQuick.Layouts 1.15
import org.kde.lingmoui 2.20 as LingmoUI
import org.kde.lingmouiaddons.components 1.0 as LingmoUIComponents
import org.kde.coreaddons as Core

import "private" as Private

/**
 * @brief An AboutPage that displays the about data using Form components.
 *
 * This component consists of an internationalized "About" page with the
 * metadata of your program.
 *
 * It allows to show the copyright notice of the application together with
 * the contributors and some information of which platform it's running on.
 *
 * @since LingmoUIAddons 0.11.0
 * @inherit org:kde::lingmoui::ScrollablePage
 */
FormCardPage {
    id: page

    /**
     * @brief This property holds an object with the same shape as KAboutData.
     *
     * Set this property to either a KAboutData instance exposed from C++, or directly via a JSON object.
     *
     * Example usage:
     * @code{json}
     * aboutData: {
          "displayName" : "LingmoUIApp",
          "productName" : "lingmoui/app",
          "componentName" : "lingmouiapp",
          "shortDescription" : "A LingmoUI example",
          "homepage" : "",
          "bugAddress" : "submit@bugs.kde.org",
          "version" : "5.14.80",
          "otherText" : "",
          "authors" : [
              {
                  "name" : "...",
                  "task" : "...",
                  "emailAddress" : "somebody@kde.org",
                  "webAddress" : "",
                  "ocsUsername" : ""
              }
          ],
          "credits" : [],
          "translators" : [],
          "licenses" : [
              {
                  "name" : "GPL v2",
                  "text" : "long, boring, license text",
                  "spdx" : "GPL-2.0"
              }
          ],
          "copyrightStatement" : "© 2010-2018 Lingmo Development Team",
          "desktopFileName" : "org.kde.lingmouiapp"
       }
       @endcode
     *
     * @see KAboutData
     */
    property var aboutData: Core.AboutData

    /**
     * @brief This property holds a link to a "Get Involved" page.
     *
     * default: `"https://community.kde.org/Get_Involved" when the
     * application ID starts with "org.kde.", otherwise empty.`
     */
    property url getInvolvedUrl: aboutData.desktopFileName.startsWith("org.kde.") ? "https://community.kde.org/Get_Involved" : ""

    /**
     * @brief This property holds a link to a "Donate" page.
     *
     * default: `"https://www.kde.org/donate" when the application ID starts with "org.kde.", otherwise empty.`
     */
    property url donateUrl: aboutData.desktopFileName.startsWith("org.kde.") ? "https://www.kde.org/donate" : ""

    title: i18nd("lingmoui-addons6", "About %1", page.aboutData.displayName)

    FormCard {
        Layout.topMargin: LingmoUI.Units.largeSpacing * 4

        AbstractFormDelegate {
            id: generalDelegate
            Layout.fillWidth: true
            background: null
            contentItem: RowLayout {
                spacing: LingmoUI.Units.smallSpacing * 2

                LingmoUI.Icon {
                    Layout.rowSpan: 3
                    Layout.preferredHeight: LingmoUI.Units.iconSizes.huge
                    Layout.preferredWidth: height
                    Layout.maximumWidth: page.width / 3;
                    Layout.rightMargin: LingmoUI.Units.largeSpacing
                    source: LingmoUI.Settings.applicationWindowIcon || page.aboutData.programLogo || page.aboutData.programIconName || page.aboutData.componentName
                }

                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: LingmoUI.Units.smallSpacing

                    LingmoUI.Heading {
                        Layout.fillWidth: true
                        text: page.aboutData.displayName + " " + page.aboutData.version
                        wrapMode: Text.WordWrap
                    }

                    LingmoUI.Heading {
                        Layout.fillWidth: true
                        level: 3
                        type: LingmoUI.Heading.Type.Secondary
                        wrapMode: Text.WordWrap
                        text: page.aboutData.shortDescription
                    }
                }
            }
        }

        FormDelegateSeparator {}

        FormTextDelegate {
            id: copyrightDelegate
            text: i18nd("lingmoui-addons6", "Copyright")
            descriptionItem.textFormat: Text.PlainText
            description: aboutData.otherText + (aboutData.otherText.length > 0 ? '\n' : '')
                + aboutData.copyrightStatement
        }
    }

    FormHeader {
        title: i18ndp("lingmoui-addons6", "License", "Licenses", aboutData.licenses.length)
        visible: aboutData.licenses.length
    }

    FormCard {
        visible: aboutData.licenses.length

        Repeater {
            model: aboutData.licenses
            delegate: FormButtonDelegate {
                text: modelData.name
                Layout.fillWidth: true
                onClicked: {
                    licenseSheet.text = modelData.text;
                    licenseSheet.title = modelData.name;
                    licenseSheet.open();
                }
            }
        }

        data: LingmoUIComponents.MessageDialog {
            id: licenseSheet

            property alias text: bodyLabel.text

            parent: QQC2.Overlay.overlay

            leftPadding: 0
            rightPadding: 0
            bottomPadding: 0
            topPadding: 0

            header: LingmoUI.Heading {
                text: licenseSheet.title
                elide: QQC2.Label.ElideRight
                padding: licenseSheet.padding
                topPadding: LingmoUI.Units.largeSpacing
                bottomPadding: LingmoUI.Units.largeSpacing

                LingmoUI.Separator {
                    anchors {
                        left: parent.left
                        right: parent.right
                        bottom: parent.bottom
                    }
                }
            }

            contentItem: QQC2.ScrollView {
                id: scrollView

                LingmoUI.SelectableLabel {
                    id: bodyLabel
                    text: licenseSheet.text
                    textMargin: LingmoUI.Units.gridUnit
                }
            }

            footer: null
        }
    }

    FormCard {
        Layout.topMargin: LingmoUI.Units.gridUnit

        FormButtonDelegate {
            id: getInvolvedDelegate
            text: i18nd("lingmoui-addons6", "Homepage")
            onClicked: Qt.openUrlExternally(aboutData.homepage)
            visible: aboutData.homepage.length > 0
        }

        FormDelegateSeparator {
            above: getInvolvedDelegate
            below: donateDelegate
            visible: aboutData.homepage.length > 0
        }

        FormButtonDelegate {
            id: donateDelegate
            text: i18nd("lingmoui-addons6", "Donate")
            onClicked: Qt.openUrlExternally(donateUrl + "?app=" + page.aboutData.componentName)
            visible: donateUrl.toString().length > 0
        }

        FormDelegateSeparator {
            above: donateDelegate
            below: homepageDelegate
            visible: donateUrl.toString().length > 0
        }

        FormButtonDelegate {
            id: homepageDelegate
            text: i18nd("lingmoui-addons6", "Get Involved")
            onClicked: Qt.openUrlExternally(page.getInvolvedUrl)
            visible: page.getInvolvedUrl != ""
        }

        FormDelegateSeparator {
            above: homepageDelegate
            below: bugDelegate
            visible: page.getInvolvedUrl != ""
        }

        FormButtonDelegate {
            id: bugDelegate
            readonly property string theUrl: {
                if (aboutData.bugAddress !== "submit@bugs.kde.org") {
                    return aboutData.bugAddress
                }
                const elements = aboutData.productName.split('/');
                let url = `https://bugs.kde.org/enter_bug.cgi?format=guided&product=${elements[0]}&version=${aboutData.version}`;
                if (elements.length === 2) {
                    url += "&component=" + elements[1];
                }
                return url;
            }

            text: i18nd("lingmoui-addons6", "Report a Bug")
            onClicked: Qt.openUrlExternally(theUrl)
            visible: theUrl.length > 0
        }
    }

    FormHeader {
        title: i18nd("lingmoui-addons6", "Libraries in use")
        visible: LingmoUI.Settings.information
    }

    FormCard {
        visible: LingmoUI.Settings.information

        Repeater {
            model: LingmoUI.Settings.information
            delegate: FormTextDelegate {
                id: libraries
                Layout.fillWidth: true
                text: modelData
            }
        }

        Repeater {
            model: aboutData.components
            delegate: libraryDelegate
        }
    }

    FormHeader {
        title: i18nd("lingmoui-addons6", "Authors")
        visible: aboutData.authors !== undefined && aboutData.authors.length > 0
    }

    FormCard {
        visible: aboutData.authors !== undefined && aboutData.authors.length > 0

        Repeater {
            id: authorsRepeater
            model: aboutData.authors
            delegate: personDelegate
        }
    }

    FormHeader {
        title: i18nd("lingmoui-addons6", "Credits")
        visible: aboutData.credits !== undefined && aboutData.credits.length > 0
    }

    FormCard {
        visible: aboutData.credits !== undefined && aboutData.credits.length > 0

        Repeater {
            id: repCredits
            model: aboutData.credits
            delegate: personDelegate
        }
    }

    FormHeader {
        title: i18nd("lingmoui-addons6", "Translators")
        visible: aboutData.translators !== undefined && aboutData.translators.length > 0
    }

    FormCard {
        visible: aboutData.translators !== undefined && aboutData.translators.length > 0

        Repeater {
            id: repTranslators
            model: aboutData.translators
            delegate: personDelegate
        }
    }

    data: [
        Component {
            id: personDelegate

            AbstractFormDelegate {
                Layout.fillWidth: true
                background: null
                contentItem: RowLayout {
                    spacing: LingmoUI.Units.smallSpacing * 2

                    LingmoUIComponents.Avatar {
                        id: avatarIcon

                        // TODO FIXME kf6 https://phabricator.kde.org/T15993
                        property bool hasRemoteAvatar: false // (typeof(modelData.ocsUsername) !== "undefined" && modelData.ocsUsername.length > 0)
                        implicitWidth: LingmoUI.Units.iconSizes.medium
                        implicitHeight: implicitWidth
                        name: modelData.name
                        source: if (!!modelData.avatarUrl && modelData.avatarUrl.toString().startsWith('https://')) {
                            const url = new URL(modelData.avatarUrl);
                            const params = new URLSearchParams(url.search);
                            params.append("s", width);
                            url.search = params.toString();
                            return url;
                        } else {
                            return '';
                        }
                    }

                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: LingmoUI.Units.smallSpacing

                        QQC2.Label {
                            Layout.fillWidth: true
                            text: modelData.name
                            elide: Text.ElideRight
                        }

                        QQC2.Label {
                            id: internalDescriptionItem
                            Layout.fillWidth: true
                            text: modelData.task
                            color: LingmoUI.Theme.disabledTextColor
                            font: LingmoUI.Theme.smallFont
                            elide: Text.ElideRight
                            visible: text.length > 0
                        }
                    }

                    QQC2.ToolButton {
                        visible: typeof(modelData.ocsUsername) !== "undefined" && modelData.ocsUsername.length > 0
                        icon.name: "get-hot-new-stuff"
                        QQC2.ToolTip.delay: LingmoUI.Units.toolTipDelay
                        QQC2.ToolTip.visible: hovered
                        QQC2.ToolTip.text: i18nd("lingmoui-addons6", "Visit %1's KDE Store page", modelData.name)
                        onClicked: Qt.openUrlExternally("https://store.kde.org/u/%1".arg(modelData.ocsUsername))
                    }

                    QQC2.ToolButton {
                        visible: typeof(modelData.emailAddress) !== "undefined" && modelData.emailAddress.length > 0
                        icon.name: "mail-sent"
                        QQC2.ToolTip.delay: LingmoUI.Units.toolTipDelay
                        QQC2.ToolTip.visible: hovered
                        QQC2.ToolTip.text: i18nd("lingmoui-addons6", "Send an email to %1", modelData.emailAddress)
                        onClicked: Qt.openUrlExternally("mailto:%1".arg(modelData.emailAddress))
                    }

                    QQC2.ToolButton {
                        visible: typeof(modelData.webAddress) !== "undefined" && modelData.webAddress.length > 0
                        icon.name: "globe"
                        QQC2.ToolTip.delay: LingmoUI.Units.toolTipDelay
                        QQC2.ToolTip.visible: hovered
                        QQC2.ToolTip.text: (typeof(modelData.webAddress) === "undefined" && modelData.webAddress.length > 0) ? "" : modelData.webAddress
                        onClicked: Qt.openUrlExternally(modelData.webAddress)
                    }
                }
            }
        },
        Component {
            id: libraryDelegate

            AbstractFormDelegate {
                id: delegate

                required property var modelData

                Layout.fillWidth: true
                background: null
                contentItem: RowLayout {
                    spacing: LingmoUI.Units.smallSpacing * 2

                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: LingmoUI.Units.smallSpacing

                        QQC2.Label {
                            Layout.fillWidth: true
                            text: delegate.modelData.name + ' ' + delegate.modelData.version
                            elide: Text.ElideRight
                        }

                        QQC2.Label {
                            id: internalDescriptionItem
                            Layout.fillWidth: true
                            text: delegate.modelData.description
                            color: LingmoUI.Theme.disabledTextColor
                            font: LingmoUI.Theme.smallFont
                            elide: Text.ElideRight
                            visible: text.length > 0
                        }
                    }

                    QQC2.ToolButton {
                        visible: modelData.licenses !== 0
                        icon.name: "license"

                        QQC2.ToolTip.delay: LingmoUI.Units.toolTipDelay
                        QQC2.ToolTip.visible: hovered
                        QQC2.ToolTip.text: !visible ? "" : delegate.modelData.licenses.name

                        LingmoUIComponents.MessageDialog {
                            id: licenseSheet

                            parent: root.QQC2.Overlay.overlay
                            title: delegate.modelData.name

                            leftPadding: 0
                            rightPadding: 0
                            bottomPadding: 0
                            topPadding: 0

                            header: LingmoUI.Heading {
                                text: licenseSheet.title
                                elide: QQC2.Label.ElideRight
                                padding: licenseSheet.padding
                                topPadding: LingmoUI.Units.largeSpacing
                                bottomPadding: LingmoUI.Units.largeSpacing

                                LingmoUI.Separator {
                                    anchors {
                                        left: parent.left
                                        right: parent.right
                                        bottom: parent.bottom
                                    }
                                }
                            }

                            contentItem: QQC2.ScrollView {
                                LingmoUI.SelectableLabel {
                                    id: bodyLabel
                                    text: delegate.modelData.licenses.text
                                    textMargin: LingmoUI.Units.gridUnit
                                }
                            }

                            footer: null
                        }

                        onClicked: licenseSheet.open()
                    }

                    QQC2.ToolButton {
                        visible: typeof(modelData.webAddress) !== "undefined" && modelData.webAddress.length > 0
                        icon.name: "globe"
                        QQC2.ToolTip.delay: LingmoUI.Units.toolTipDelay
                        QQC2.ToolTip.visible: hovered
                        QQC2.ToolTip.text: (typeof(modelData.webAddress) === "undefined" && modelData.webAddress.length > 0) ? "" : modelData.webAddress
                        onClicked: Qt.openUrlExternally(modelData.webAddress)
                    }
                }
            }
        }
    ]
}
