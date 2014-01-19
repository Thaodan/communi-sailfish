/*
  Copyright (C) 2013-2014 Robin Burchell <robin+git@viroteck.net>
  Copyright (C) 2013-2014 J-P Nurmi <jpnurmi@gmail.com>

  You may use this file under the terms of BSD license as follows:

  Redistribution and use in source and binary forms, with or without
  modification, are permitted provided that the following conditions are met:
    * Redistributions of source code must retain the above copyright
      notice, this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright
      notice, this list of conditions and the following disclaimer in the
      documentation and/or other materials provided with the distribution.
    * Neither the name of the Jolla Ltd nor the
      names of its contributors may be used to endorse or promote products
      derived from this software without specific prior written permission.

  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
  ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
  WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
  DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDERS OR CONTRIBUTORS BE LIABLE FOR
  ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
  (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
  LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
  ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
  SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

import QtQuick 2.1
import Sailfish.Silica 1.0

CoverBackground {
    id: cover
    anchors.fill: parent

    // Number of unread highlights
    property int unreadHighlights: 0

    // Resets the cover (called when the app goes to the foreground)
    function resetCover() {
        // Clear unread highlights
        cover.unreadHighlights = 0;
        // Clear top active buffers
        topActiveBuffers.clear();
    }

    // Adds a new name to display in the top active buffers list
    function addActiveBuffer(bufferName) {
        // Check if bufferName is already in the top
        for (var i = 0; i < topActiveBuffers.count; i++) {
            var item = topActiveBuffers.get(i);
            if (item.bufferName === bufferName) {
                // If bufferName is found, remove it
                topActiveBuffers.remove(i, 1);
                break;
            }
        }
        // If the top contains more than 5 items, remove the last
        if (topActiveBuffers.count >= 5) {
            topActiveBuffers.remove(4, 1);
        }

        // Insert bufferName into the front
        topActiveBuffers.insert(0, { bufferName: bufferName });
    }

    ListModel {
        id: topActiveBuffers
    }

    Image {
        source: "../images/cover.png"
        opacity: 0.15
        anchors {
            horizontalCenter: parent.horizontalCenter
        }
    }
    Label {
        id: unreadCount
        text: cover.unreadHighlights
        x: Theme.paddingLarge
        y: Theme.paddingMedium
        font.pixelSize: Theme.fontSizeHuge
        font.family: Theme.fontFamilyHeading
    }
    Label {
        id: unreadLabel
        text: qsTr("Unread highlights")
        font.pixelSize: Theme.fontSizeExtraSmall
        font.family: Theme.fontFamilyHeading
        font.weight: Font.Light
        elide: Text.ElideRight
        wrapMode: Text.Wrap
        maximumLineCount: 2
        lineHeight: 0.8
        height: implicitHeight + Theme.paddingLarge
        anchors {
            right: parent.right
            left: unreadCount.right
            leftMargin: Theme.paddingMedium
            baseline: unreadCount.baseline
            baselineOffset: -implicitHeight/2
        }
    }
    OpacityRampEffect {
        sourceItem: unreadLabel
    }

    Column {
        id: recentChannels
        anchors {
            top: unreadCount.bottom
            left: parent.left
            right: parent.right
            bottom: parent.bottom
            margins: Theme.paddingLarge
        }
        Repeater {
            model: topActiveBuffers
            delegate: Label {
                color: Theme.highlightColor
                text: model.bufferName
                elide: Text.ElideRight
                width: recentChannels.width
            }
        }
    }
    OpacityRampEffect {
        sourceItem: recentChannels
    }
}