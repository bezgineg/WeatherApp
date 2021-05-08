
import UIKit

extension UIButton {
    func setBackgroundColor(_ color: UIColor, forState controlState: UIControl.State) {
        let colorImage = UIGraphicsImageRenderer(size: CGSize(width: 1, height: 1)).image { _ in
            color.setFill()
            UIBezierPath(rect: CGRect(x: 0, y: 0, width: 1, height: 1)).fill()
        }
        setBackgroundImage(colorImage, for: controlState)
    }
    
    func underline() {
            guard let title = self.titleLabel else { return }
            guard let tittleText = title.text else { return }
            let attributedString = NSMutableAttributedString(string: (tittleText))
            attributedString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(location: 0, length: (tittleText.count)))
            self.setAttributedTitle(attributedString, for: .normal)
        }
}
