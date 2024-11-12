import SwiftUI

struct TreeView: View {
    var data: Any
    var fontSize: CGFloat
    var parentKey: String
    @Binding var expandCollapseState: [String: Bool]
    
    var body: some View {
        VStack {
            VStack(alignment: .leading) {
                if let dictionary = data as? [String: Any] {
                    ForEach(dictionary.keys.sorted(), id: \.self) { key in
                        let fullKey = parentKey.isEmpty ? key : "\(parentKey).\(key)"
                        TreeNode(key: key, data: dictionary[key]!, fontSize: fontSize, fullKey: fullKey, expandCollapseState: $expandCollapseState)
                    }
                } else if let array = data as? [Any] {
                    ForEach(array.indices, id: \.self) { index in
                        let fullKey = parentKey.isEmpty ? "\(index)" : "\(parentKey).\(index)"
                        TreeNode(key: "\(index)", data: array[index], fontSize: fontSize, fullKey: fullKey, expandCollapseState: $expandCollapseState)
                    }
                } else {
                    Text("\(String(describing: data))")
                        .font(.system(size: fontSize, design: .monospaced))
                        .padding(.leading)
                }
            }
        }
    }
}
