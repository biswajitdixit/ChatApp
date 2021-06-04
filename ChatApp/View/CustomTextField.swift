import UIKit

class CustomTextField: UITextField{
    
    init(placeholder: String) {
        super.init(frame: .zero)
        
        borderStyle = .none
        font = UIFont.systemFont(ofSize: 16)
        textColor = .black
        keyboardAppearance = .dark
        attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [.foregroundColor : UIColor.systemPurple])
    }
    
    required init?(coder: NSCoder){
        fatalError("init(Coder:) has not been implemented")
    }
}
