import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import QtMultimedia 5.12

Window {
    modality: Qt.ApplicationModal
    StackView {
        id: stack
        initialItem: mainView
    }
    Component {
        id: mainView

        Row {
            spacing: 10
            Button {
                text: "Push"
                onClicked: stack.push(mainView)
            }
            Button {
                text: "Pop"
                enabled: stack.depth > 1
                onClicked: stack.pop()

            }
            Text {
                text: stack.depth
            }
        }
    }
}
