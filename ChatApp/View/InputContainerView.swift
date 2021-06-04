import UIKit

class InputContainerView: UIView{
    
    init(image:UIImage, textField:UITextField) {
        super.init(frame: .zero)
        
        setHeight(height: 50)
        
        let imgView = UIImageView()
        imgView.image = image
        imgView.tintColor = .systemPurple
        imgView.alpha = 0.87
        
        addSubview(imgView)
        imgView.centerY(inView: self)
        imgView.anchor(left:leftAnchor, paddingLeft: 8)
        imgView.setDimensions(height: 24, width: 24)
        
        addSubview(textField)
        textField.centerY(inView: self)
        textField.anchor(left: imgView.rightAnchor, bottom: bottomAnchor, right: rightAnchor, paddingLeft: 8, paddingBottom: -8)
        
        let divideView = UIView()
        divideView.backgroundColor = .systemPurple
        addSubview(divideView)
        divideView.anchor(left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingLeft: 8, height: 0.75)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
