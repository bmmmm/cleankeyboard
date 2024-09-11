import SwiftUI
import Carbon

struct ContentView: View {
    @State private var ignoreKeystrokes = false
    @State private var source = CGEventSource(stateID: .hidSystemState)
    
    
    var body: some View {
        VStack {
            TextField("Type something...", text: .constant(""))
                .disabled(ignoreKeystrokes)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            
            Button(action: {
                ignoreKeystrokes.toggle()
                if ignoreKeystrokes {
                    // keys from: https://developer.apple.com/documentation/uikit/uikeyboardhidusage
                    
                    let keyDown = CGEvent(keyboardEventSource: source, virtualKey: 100, keyDown: true)
                    keyDown?.post(tap: .cghidEventTap)
                    CGEvent(keyboardEventSource: source, virtualKey: 0, keyDown: true)?.post(tap: .cghidEventTap)

                    
                    //print(NSEndFunctionKey)
                    
                    let url = URL(string: "x-apple.systempreferences:com.apple.preference.keyboard")!

                    let configuration = NSWorkspace.OpenConfiguration()
                    NSWorkspace.shared.openApplication(at: url, configuration: configuration) { (app, error) in
                        if let error = error {
                            print("Failed to open application: \(error)")
                        } else {
                            print("Application opened successfully")
                            
                            
                            // Use AppleScript to bring the System Preferences to the front
                            let script = """
                            tell application "System Settings"
                                activate
                            end tell
                            """
                            
                            var error: NSDictionary?
                            if let scriptObject = NSAppleScript(source: script) {
                                scriptObject.executeAndReturnError(&error)
                            }
                            
                            if let error = error {
                                print("AppleScript error: \(error)")
                            } else {
                                print("System Preferences brought to front")
                            }
                            
                        }
                    } ///*
                }
                else {
                    
                    let keyUp = CGEvent(keyboardEventSource: source, virtualKey: 120, keyDown: false)
                    keyUp?.post(tap: .cghidEventTap)
                }
                
            }) {
                Text(ignoreKeystrokes ? "Enable Keystrokes" : "Ignore Keystrokes")
            }
            .padding()

            Button(action: {
                NSApplication.shared.terminate(nil)
            
            }) {
                Text("Exit Program")
            }
            .padding()
        }
        .padding()
    }
}

/*struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
        
    }
}
*/
