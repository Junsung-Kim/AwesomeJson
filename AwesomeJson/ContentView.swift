import SwiftUI

struct ContentView: View {
    @State private var jsonString: String = "{\"b\":\"a\",\"d\":{\"c\":\"e\"}}"

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
                        Button(action: prettifyJson, label: { Text("Prettify") })
                        Button(action: minifyJson, label: { Text("Minify") })
                        Button(action: refreshTreeView, label: { Text("Refresh Tree View") })
                    }.padding(5)
                    HStack {
                        Button("Sort Ascending") {
                            jsonString = sortJson(jsonString, order: .orderedAscending)
                        }
                        Button("Sort Descending") {
                            jsonString = sortJson(jsonString, order: .orderedDescending)
                        }
                    }
                    HStack {
                        Button(action: { fontSize += 2 }, label: { Text("+") })
                        Button(action: { fontSize -= 2 }, label: { Text("-") })
                    }
                    .padding(5)
                }
                .padding()
                
                Divider()
                
                
                VStack {
                    Text("Tree View")
                        .font(.headline)
                    HStack {
                        Button(action: expandAll, label: { Text("Expand All") })
                        Button(action: collapseAll, label: { Text("Collapse All") })
                    }.padding()
                    ScrollView {
                        TreeView(data: jsonTree, fontSize: fontSize, parentKey: "", expandCollapseState: $expandCollapseState)
                    }
                    .frame(minWidth: 200, maxWidth: .infinity)
                }
                .padding()
            }
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Invalid JSON"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
            .frame(maxHeight: .infinity)
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
            
            expandCollapseState = [:]
            registerKeys(jsonTree, parentKey: nil) // 모든 depth의 key를 등록
            
        } catch {
            showAlert(with: "The JSON format is incorrect and could not be parsed to Tree View.")
        }
    }

    // 모든 depth의 key를 expandCollapseState에 재귀적으로 등록하는 함수
    private func registerKeys(_ jsonObject: Any, parentKey: String?) {
        if let dictionary = jsonObject as? [String: Any] {
            for (key, value) in dictionary {
                let fullKey = [parentKey, key].compactMap { $0 }.joined(separator: ".")
                expandCollapseState[fullKey] = false
                registerKeys(value, parentKey: fullKey) // 하위 값 재귀 호출
            }
        } else if let array = jsonObject as? [Any] {
            for (index, value) in array.enumerated() {
                let fullKey = [parentKey, "\(index)"].compactMap { $0 }.joined(separator: ".")
                expandCollapseState[fullKey] = false
                registerKeys(value, parentKey: fullKey)
            }
        }
    }


    private func showAlert(with message: String) {
        alertMessage = message
        showAlert = true
    }
    
    private func sortJson(_ jsonString: String, order: ComparisonResult) -> String {
        guard let data = jsonString.data(using: .utf8) else { return jsonString }
        
        do {
            let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
            if let sortedObject = sort(jsonObject, order: order) {
                let sortedData = try JSONSerialization.data(withJSONObject: sortedObject, options: [.prettyPrinted])
                return String(data: sortedData, encoding: .utf8) ?? jsonString
            }
        } catch {
            print("Error sorting JSON")
        }
        
        return jsonString
    }
    private func sort(_ jsonObject: Any, order: ComparisonResult) -> Any? {
        if let dictionary = jsonObject as? [String: Any] {
            let sortedDict = dictionary
                .sorted { order == .orderedAscending ? $0.key < $1.key : $0.key > $1.key }
                .reduce(into: [String: Any]()) { result, element in
                    result[element.key] = sort(element.value, order: order)
                }
            return sortedDict
        } else if let array = jsonObject as? [Any] {
            return array.compactMap { sort($0, order: order) }
        } else {
            return jsonObject
        }
    }
    
    private func expandAll() {
        for key in expandCollapseState.keys {
            expandCollapseState[key] = true
        }
    }

    private func collapseAll() {
        for key in expandCollapseState.keys {
            expandCollapseState[key] = false
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
