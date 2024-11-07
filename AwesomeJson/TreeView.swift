import SwiftUI

struct TreeView: View {
    var data: Any
    var fontSize: CGFloat
    @Binding var expandCollapseState: [String: Bool] // 상태를 관리
    
    var body: some View {
        if let dictionary = data as? [String: Any] {
            ForEach(dictionary.keys.sorted(), id: \.self) { key in
                TreeNode(key: key, data: dictionary[key]!, fontSize: fontSize, expandCollapseState: $expandCollapseState)
            }
        } else if let array = data as? [Any] {
            ForEach(0..<array.count, id: \.self) { index in
                TreeNode(key: "Index \(index)", data: array[index], fontSize: fontSize, expandCollapseState: $expandCollapseState)
            }
        } else {
            Text("\(String(describing: data))")
                .font(.system(size: fontSize, design: .monospaced))
                .padding(.leading)
        }
    }
}
