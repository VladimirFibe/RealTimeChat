import UIKit

class SecondaryButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setTitleColor(.link, for: .normal)
        layer.cornerRadius = 12
        layer.masksToBounds = true
        layer.borderWidth = 2
        layer.borderColor = UIColor.link.cgColor
        titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
