// Copyright (C) 2013 BlackBerry Limited. All rights reserved.
// SPDX-License-Identifier: LicenseRef-Qt-Commercial OR BSD-3-Clause

import QtQuick

Text {
    property string textContent: ""
    font.pointSize: 20
    color: colorMain
    horizontalAlignment: Text.AlignHCenter
    elide: Text.ElideMiddle
    width: parent.width
    wrapMode: Text.Wrap
    text: textContent
}
