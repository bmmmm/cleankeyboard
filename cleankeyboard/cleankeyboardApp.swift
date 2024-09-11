import SwiftUI
import IOKit.hid

func pressMediaKey(key: Int) {
    let source = CGEventSource(stateID: .hidSystemState)
    let keyDown = CGEvent(keyboardEventSource: source, virtualKey: CGKeyCode(key), keyDown: true)
    let keyUp = CGEvent(keyboardEventSource: source, virtualKey: CGKeyCode(key), keyDown: false)
    
    keyDown?.post(tap: .cghidEventTap)
    keyUp?.post(tap: .cghidEventTap)
}

@main
struct FullscreenApp: App {
    @State private var standardEventMonitor: Any?
    @State private var playPauseKey: Int = NSPauseFunctionKey
    @State private var volumeUpKey: Int32 = NX_KEYTYPE_SOUND_UP
    @State private var volumeDownKey: Int32 = NX_KEYTYPE_SOUND_DOWN
    var body: some Scene {
        WindowGroup {
            ContentView()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                //.frame(width: 100, height: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                .navigationTitle("was")
                .onAppear {
                    if NSApplication.shared.windows.first != nil {
                        //window.toggleFullScreen(nil)
                        print("Starting monitor...")
                        
                        print("automatic key pressed: \(playPauseKey)" )
                        pressMediaKey(key: playPauseKey)
                        standardEventMonitor = NSEvent.addLocalMonitorForEvents(matching: .keyDown) { event in
                            //if let url = URL(string: "x-apple.systempreferences:") {
                            //            NSWorkspace.shared.open(url)
                            //        }
                            
                            //if let characters = event.specialKey?.rawValue {
                            //    print("Key pressed: \(characters)")
                            //}
                            let keyCode = event.keyCode
                            if (0...65535).contains(keyCode) {
                                print("Key pressed: \(keyCode), \(String(describing: event.characters))")
                            }
                            
                            let modifiers: [NSEvent.ModifierFlags.RawValue: String] = [
                                    NSEvent.ModifierFlags.shift.rawValue: "Shift key is pressed",
                                    NSEvent.ModifierFlags.control.rawValue: "Control key is pressed",
                                    NSEvent.ModifierFlags.option.rawValue: "Option key is pressed",
                                    NSEvent.ModifierFlags.command.rawValue: "Command key is pressed",
                                    NSEvent.ModifierFlags.function.rawValue: "Function key is pressed",
                                    NSEvent.ModifierFlags.numericPad.rawValue: "Numeric keypad or an arrow key key is pressed",
                                    NSEvent.ModifierFlags.capsLock.rawValue: "CapslLOCK key is pressed"
                                    
                                ]

                                for (flag, message) in modifiers {
                                    if event.modifierFlags.contains(NSEvent.ModifierFlags(rawValue: flag)) {
                                        //print("\(message) (rawValue: 0x\(String(format: "%02X", flag)))")
                                        print("\(message) rawValue:", flag)
                                    }
                                }

                            return event
                        }
                    }
                }
        }
    }
}
