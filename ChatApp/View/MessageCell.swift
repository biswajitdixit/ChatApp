import UIKit

class MessageCell: UICollectionViewCell {
    
    //Mark:- Properties
    
    var message : Message? {
        didSet {
            configure()
        }
    }
    
    var bubbleLeftAnchor: NSLayoutConstraint!
    var bubbleRightAnchor: NSLayoutConstraint!
    
    private let profileImageView:UIImageView = {
       let imgView = UIImageView()
        imgView.backgroundColor = .lightGray
       imgView.contentMode = .scaleAspectFill
       imgView.clipsToBounds = true
        return imgView
    }()
    
     let textView: UITextView = {
       let txtView = UITextView()
        txtView.backgroundColor = .clear
        txtView.font = .systemFont(ofSize: 16)
        txtView.isScrollEnabled = false
        txtView.isEditable = false
        txtView.textColor = .white
        //txtView.text = "chat application conversation"
        return txtView
    }()
    
    let messageImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 16
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
     let bubbleContainer: UIView = {
       let view = UIView()
        view.backgroundColor = .systemPurple
        return view
    }()
    
    //Mark:- LifeCycle
    
    override init(frame: CGRect){
        super.init(frame: frame)
        
        addSubview(profileImageView)
        profileImageView.anchor(left: leftAnchor, bottom: bottomAnchor, paddingLeft: 8, paddingBottom: -4 )
        profileImageView.setDimensions(height: 32, width: 32)
        profileImageView.layer.cornerRadius = 32/2
        
        addSubview(bubbleContainer)
        bubbleContainer.layer.cornerRadius = 12
        bubbleContainer.anchor(top: topAnchor, bottom: bottomAnchor)
        bubbleContainer.widthAnchor.constraint(lessThanOrEqualToConstant: 250).isActive = true
        
        bubbleLeftAnchor = bubbleContainer.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 12)
        bubbleLeftAnchor.isActive = false
        
        bubbleRightAnchor = bubbleContainer.rightAnchor.constraint(equalTo: rightAnchor, constant: -12)
        bubbleRightAnchor.isActive = false
        
        bubbleContainer.addSubview(textView)
        textView.anchor(top: bubbleContainer.topAnchor, left: bubbleContainer.leftAnchor, bottom: bubbleContainer.bottomAnchor, right: bubbleContainer.rightAnchor, paddingTop: 4, paddingLeft: 12, paddingBottom: 4, paddingRight: 12)
        bubbleContainer.addSubview(messageImageView)
        messageImageView.anchor(top: bubbleContainer.topAnchor, left: bubbleContainer.leftAnchor, bottom: bubbleContainer.bottomAnchor, right: bubbleContainer.rightAnchor, paddingTop: 4, paddingLeft: 12, paddingBottom: 4, paddingRight: 12)
        
        }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //Marks:- Helpers
    func configure(){
        guard let message = message else {return}
        let viewModel = MessageViewModel(message: message)
        
        bubbleContainer.backgroundColor = viewModel.messageBackgroundColor
        bubbleLeftAnchor.isActive = viewModel.leftAnchorActive
        bubbleRightAnchor.isActive = viewModel.rightAnchorActive
        
        profileImageView.isHidden = viewModel.shouldHideProfileImage
        profileImageView.sd_setImage(with: viewModel.profileImageUrl)
        
        textView.text = message.text
        textView.textColor = viewModel.messageTextColor
        textView.text = message.text
    }
}
