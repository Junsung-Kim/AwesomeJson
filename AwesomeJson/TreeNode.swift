import SwiftUI

struct TreeNode: View {
    var key: String
    var data: Any
    var fontSize: CGFloat
    var fullKey: String
    @Binding var expandCollapseState: [String: Bool]
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Button(action: {
                    expandCollapseState[fullKey]?.toggle()
                }) {
                    HStack {
                        Text(expandCollapseState[fullKey] == true ? "▼" : "▶")
                            .font(.system(size: fontSize, design: .monospaced))
                            .foregroundColor(.blue)
                        Text(key)
                            .font(.system(size: fontSize, design: .monospaced))
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
                .buttonStyle(BorderlessButtonStyle())
            }
            .frame(maxWidth: .infinity)
            
            if expandCollapseState[fullKey] == true {
                TreeView(data: data, fontSize: fontSize, parentKey: fullKey, expandCollapseState: $expandCollapseState)
                    .padding(.leading)
            }
        }
    }
}
