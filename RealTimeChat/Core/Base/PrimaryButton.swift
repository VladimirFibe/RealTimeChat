import UIKit

class PrimaryButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .link
        setTitleColor(.white, for: .normal)
        layer.cornerRadius = 12
        layer.masksToBounds = true
        titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
