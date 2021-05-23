
import UIKit

class CustomInputView: UIView {
    
    //Marks:- Properties
    private let messageInputTextView: UITextView = {
       let tv = UITextView()
        tv.font = UIFont.systemFont(ofSize: 16)
        tv.isScrollEnabled = false
        return tv
    }()
    
    private let sendButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "filled-sent-2"), for: .normal)
        button.tintColor = .systemPurple
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.setTitleColor(.systemPurple, for: .normal)
        button.addTarget(self, action: #selector(handleSendMessage), for: .touchUpInside)
        return button
    } ()
    private let imageButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "photo"), for: .normal)
        button.tintColor = .systemPurple
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.setTitleColor(.systemPurple, for: .normal)
        button.addTarget(self, action: #selector(handelPhotoMessage), for: .touchUpInside)
      return button
    }()
    private let placeHolderLabel: UILabel = {
       let label = UILabel()
        label.text = "Type a message"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .lightGray
        return label
    }()
    
    //Marks:- LifeCycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        autoresizingMask = .flexibleHeight
        backgroundColor = .white
        
        layer.shadowOpacity = 0.25
        layer.shadowRadius = 10
        layer.shadowOffset = .init(width: 0, height: -8)
        layer.shadowColor = UIColor.lightGray.cgColor
        addSubview(sendButton)
        sendButton.anchor(top: topAnchor, right: rightAnchor, paddingTop: 4, paddingRight: 8)
        sendButton.setDimensions(height: 50, width: 50)
        
        addSubview(imageButton)
        imageButton.anchor(top: topAnchor,bottom: safeAreaLayoutGuide.bottomAnchor,paddingTop:4, paddingLeft: 4)
        imageButton.setDimensions(height: 50, width: 50)
        addSubview(messageInputTextView)
        messageInputTextView.anchor(top: topAnchor, left: leftAnchor, bottom: safeAreaLayoutGuide.bottomAnchor, right: sendButton.leftAnchor, paddingTop: 12, paddingLeft: 40, paddingBottom:  8, paddingRight: 8)
        
        addSubview(placeHolderLabel)
        placeHolderLabel.anchor(left:messageInputTextView.leftAnchor, paddingLeft: 4)
        placeHolderLabel.centerY(inView: messageInputTextView)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handelTextInputChange), name: UITextView.textDidChangeNotification, object: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize{
        return .zero
    }
    
    //Marks:- Selector
    
    @objc func handleSendMessage(){
        print("send message \(messageInputTextView.text)")
    }
    
    @objc func handelTextInputChange(){
        placeHolderLabel.isHidden = !self.messageInputTextView.text.isEmpty
    }
    
    @objc func handelPhotoMessage(){
        
    }
}
