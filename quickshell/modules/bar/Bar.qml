import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Hyprland

Scope {
    id: bar

    property bool show: true

    Variants {
        model: Quickshell.screens
        LazyLoader {
            id: barLoader
            active: true
            component: PanelWindow {
                id: barRoot
                anchors {
                    top: true
                    left: true
                    right: true
                }

                implicitHeight: 30

                Text {
                    id: clock
                    anchors.centerIn: parent

                    Process {
                        id: dateProc
                        command: ["date"]

                        running: true
                        stdout: StdioCollector {
                            onStreamFinished: clock.text = this.text
                        }
                    }
                }

                Timer {
                    interval: 1000
                    running: true
                    repeat: true
                    onTriggered: dateProc.running = true
                }
            }
        }
    }
}
