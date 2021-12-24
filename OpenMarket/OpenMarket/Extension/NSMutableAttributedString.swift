import UIKit

extension NSMutableAttributedString {
    func strikethroughStyle(string: String) -> NSMutableAttributedString {
        let attributeString = NSMutableAttributedString(string: string)
        attributeString.addAttribute(.strikethroughStyle, value: NSUnderlineStyle.single.rawValue, range: NSMakeRange(0, attributeString.length))

        return attributeString
    }
}
