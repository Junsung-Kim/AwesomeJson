import SwiftUI

struct TreeNode: View {
    var key: String
    var data: Any
    var fontSize: CGFloat
    @Binding var expandCollapseState: [String: Bool]
    
    @State private var isExpanded: Bool = false
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Button(action: toggleExpansion) {
                    Text(isExpanded ? "▼" : "▶") // Expand/Collapse 아이콘
                        .font(.system(size: fontSize, design: .monospaced))
                        .foregroundColor(.blue)
                        .padding(.trailing, 5)
                }
                Text(key)
                    .font(.system(size: fontSize, design: .monospaced))
                    .padding(5)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(5)
            }
            .padding(.vertical, 5)
            
            if isExpanded {
                TreeView(data: data, fontSize: fontSize, expandCollapseState: $expandCollapseState)
                    .padding(.leading)
            }
            
            Divider()
        }
        .onAppear {
            isExpanded = expandCollapseState[key] ?? false
        }
        .onChange(of: isExpanded) { newValue in
            expandCollapseState[key] = newValue
        }
    }
    
    private func toggleExpansion() {
        isExpanded.toggle()
    }
}
