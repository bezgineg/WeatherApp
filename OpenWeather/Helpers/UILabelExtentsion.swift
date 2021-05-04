
import UIKit

extension UILabel {
    func setupLabel() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.textColor = Colors.settingsLabelColor
        self.font = UIFont.systemFont(ofSize: 16, weight: .regular)
    }
}
