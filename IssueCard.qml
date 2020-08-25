import QtQuick 2.0

import "methods.js" as JS

Rectangle {
    id: rectangle1
    color: "#f1dada"
    radius: 0
    gradient: Gradient {
        GradientStop {
            position: 0.00;
            color: "#f5f2f2";
        }
        GradientStop {
            position: 1.00;
            color: "#ffffff";
        }
    }
    border.color: "#808285"
    width: 150
    height: 150

    property var issue: null
    onIssueChanged: {
        var self = JS.getValue(issue,"self")
        var re = new RegExp("(https*:\/\/[^\/]+\/).+")
        var key = JS.getValue(issue,"key")
        var url = self.replace(re,'$1')+'browse/'+key
//        keyText.text = '<a href="'+url+'" >'+key+'</a>'
        keyText.text = key
        keyText.url = url
        summaryText.text = JS.getValue(issue,"fields/summary")
        dateText.text = (new Date(JS.getValue(issue,"fields/created"))).toLocaleString('', {
                                                                                           weekday: "short",
                                                                                           year: "numeric",
                                                                                           month: "2-digit",
                                                                                           day: "numeric"
                                                                                       })
        creatorText.text = JS.getValue(issue,"fields/creator/displayName")
        var v = JS.getValue(issue,"fields/assignee/displayName")
        assigneeText.text = v === null ? "(no assigned)" : v
        var img = JS.getValue(issue,"fields/priority/iconUrl")
        var txt = JS.getValue(issue,"fields/priority/name")
        priorityImage.source = typeof img == 'undefined' || img === null ? "" : img
        img = JS.getValue(issue,"fields/issuetype/iconUrl")
        typeImage.source = typeof img == 'undefined' || img === null ? "" : img
        statusText.text = JS.getValue(issue,"fields/status/name")

        progressBar.progress = JS.getValue(issue,"fields/progress/progress");
        progressBar.total = JS.getValue(issue,"fields/timeoriginalestimate");
    }

    Text {
        id: keyText
        text: "JIRASERVER-1001"
        property string url: ""
        anchors.top: parent.top
        anchors.topMargin: 8
        anchors.left: parent.left
        anchors.leftMargin: 8
        font.bold: true
        font.pixelSize: 14
//        onLinkActivated: Qt.openUrlExternally(link)
//        linkColor: color
        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
//            acceptedButtons: Qt.NoButton
            onClicked: Qt.openUrlExternally(parent.url)
        }
    }

    Text {
        id: statusText
        x: 8
        y: 128
        text: "null"
        anchors.top: parent.top
        anchors.topMargin: 8
        anchors.left: keyText.right
        anchors.leftMargin: 8
        font.pixelSize: 10
    }

    Text {
        id: summaryText
        y: 51
        height: 42
        color: "#002f7b"
        text: "Create a Global permission for Auditing teams to have full read only access to the instance"
        anchors.right: parent.right
        anchors.rightMargin: 8
        anchors.left: parent.left
        anchors.leftMargin: 8
        wrapMode: Text.WordWrap
        font.pixelSize: 15
        textFormat: Text.PlainText
    }

    Image {
        id: priorityImage
        x: 276
        width: 16
        height: 16
        anchors.top: parent.top
        anchors.topMargin: 9
        anchors.right: parent.right
        anchors.rightMargin: 8
    }

    Image {
        id: typeImage
        x: 276
        width: 16
        height: 16
        anchors.top: parent.top
        anchors.topMargin: 9
        anchors.right: priorityImage.left
        anchors.rightMargin: 4
        source: ""
    }

    Text {
        id: dateText
        x: 198
        y: 31
        color: "#949090"
        text: "13.03.2018 17:11"
        anchors.right: parent.right
        anchors.rightMargin: 8
        font.pixelSize: 12
    }

    Text {
        id: creatorText
        y: 31
        color: "#949090"
        text: "Chung Park Chan"
        anchors.left: parent.left
        anchors.leftMargin: 8
        font.pixelSize: 12
    }

    Text {
        id: assigneeText
        x: 218
        y: 128
        text: "Kiran Shekhar"
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 8
        anchors.rightMargin: 8
        anchors.right: parent.right
        font.pixelSize: 12
    }


    Rectangle {
        id: progressBar
        anchors.bottom: parent.bottom
        anchors.leftMargin: 8
        anchors.bottomMargin: 8
        anchors.left: parent.left
        width: parent.width / 3
        height: 20
        border.color: "black"
        border.width: 1

        property string progress: null
        property string total: null

        onTotalChanged: {
            updateText()
        }
        onProgressChanged: {
            updateText()
        }

        function updateText() {
            var progressInt = parseInt(progress);
            var totalInt = parseInt(total);
            estimateText.text = JS.toTimeString(progressInt) + "/" + JS.toTimeString(totalInt);
            if (!isNaN(totalInt) && !isNaN(progressInt))
            {
                var aspect = progressInt / totalInt;
                indicator.color = aspect > 1.0 ? overtimeIndicatorColor
                                               : normalIndicatorColor;

                indicator.progress = Math.min(aspect, 1.0);
            }
            else
            {
                indicator.progress = 1.0;
                indicator.color = abnormalIndicatorColor;
            }
        }

        Rectangle {
            id: indicator
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.leftMargin: 2
            anchors.bottomMargin: 2
            anchors.topMargin: 2
            anchors.rightMargin: 2
            width: parent.width * progress - 4
            color: progressBar.normalIndicatorColor
            property real progress: 0.0
        }
        Text {
            id: estimateText
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.leftMargin: 2
            anchors.bottomMargin: 2
            anchors.topMargin: 2
            anchors.rightMargin: 2
            font.pixelSize: 12
        }

        readonly property color normalIndicatorColor: "#55ff55"
        readonly property color overtimeIndicatorColor: "#ff5555"
        readonly property color abnormalIndicatorColor: "#ff9c00"
    }

}

