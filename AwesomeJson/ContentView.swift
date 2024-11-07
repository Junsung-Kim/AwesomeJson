import SwiftUI

struct ContentView: View {
    @State private var jsonString: String = ""
    @State private var jsonTree: [String: Any] = [:]
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var fontSize: CGFloat = 14
    @State private var expandCollapseState: [String: Bool] = [:]
    
    var body: some View {
        VStack {
            HStack {
                VStack {
                    Text("Input JSON")
                        .font(.headline)
                    TextEditor(text: $jsonString)
                        .font(.system(size: fontSize, design: .monospaced))
                        .border(Color.gray, width: 1)
                        .frame(minWidth: 200, maxWidth: .infinity, minHeight: 300, maxHeight: .infinity)
                    
                    HStack {
                        Button(action: prettifyJson) {
                            Text("Prettify")
                        }
                        .padding(.horizontal)
                        
                        Button(action: minifyJson) {
                            Text("Minify")
                        }
                        .padding(.horizontal)
                        
                        Button(action: refreshTreeView) {
                            Text("Refresh Tree View")
                        }
                        .padding(.horizontal)
                        
                        Button(action: { fontSize += 2 }) {
                            Text("+")
                        }
                        .padding(.horizontal)
                        
                        Button(action: { fontSize -= 2 }) {
                            Text("-")
                        }
                        .padding(.horizontal)
                    }
                    .padding()
                }
                .padding()
                
                Divider()
                
                VStack {
                    Text("Tree View")
                        .font(.headline)
                    
                    HStack {
                        Button(action: expandAll) {
                            Text("Expand All")
                                .font(.subheadline)
                        }
                        .padding(.horizontal)
                        
                        Button(action: collapseAll) {
                            Text("Collapse All")
                                .font(.subheadline)
                        }
                        .padding(.horizontal)
                    }
                    .padding()
                    
                    ScrollView {
                        TreeView(data: jsonTree, fontSize: fontSize, expandCollapseState: $expandCollapseState)
                            .padding()
                    }
                    .frame(minWidth: 200, maxWidth: .infinity) // Ensure the TreeView takes full height
                }
                .padding()
            }
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Invalid JSON"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
            .frame(maxHeight: .infinity) // Ensure the entire layout stretches vertically
        }
    }

    private func prettifyJson() {
        guard let data = jsonString.data(using: .utf8) else { return }
        do {
            let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
            let prettyData = try JSONSerialization.data(withJSONObject: jsonObject, options: [.prettyPrinted])
            jsonString = String(data: prettyData, encoding: .utf8) ?? ""
        } catch {
            showAlert(with: "The JSON format is incorrect and could not be prettified.")
        }
    }
    
    private func minifyJson() {
        guard let data = jsonString.data(using: .utf8) else { return }
        do {
            let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
            let minifiedData = try JSONSerialization.data(withJSONObject: jsonObject, options: [])
            jsonString = String(data: minifiedData, encoding: .utf8) ?? ""
        } catch {
            showAlert(with: "The JSON format is incorrect and could not be minified.")
        }
    }
    
    private func refreshTreeView() {
        guard let data = jsonString.data(using: .utf8) else { return }
        do {
            let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
            jsonTree = jsonObject as? [String: Any] ?? [:]
        } catch {
            showAlert(with: "The JSON format is incorrect and could not be parsed to Tree View.")
        }
    }
    
    private func showAlert(with message: String) {
        alertMessage = message
        showAlert = true
    }
    
    private func expandAll() {
        expandCollapseState = expandCollapseState.mapValues { _ in true }
    }
    
    private func collapseAll() {
        expandCollapseState = expandCollapseState.mapValues { _ in false }
    }
}
