import QtQuick 2.12
import QtQuick.Dialogs 1.3

FileDialog {
    id: fileDialog
    title: "Please choose a file"
    folder: shortcuts.home
    onAccepted: {
        console.log("You chose: " + fileDialog.fileUrls)
        //Qt.quit()
    }
    onRejected: {
        console.log("Canceled")
        //Qt.quit()
    }
    Component.onCompleted: visible = false
}
