import UIKit
import SDWebImage
import Firebase

class ConversationCell:UITableViewCell {
    //Marks:- Properties
    
    var conversation: Message? {
    didSet { configure() }
    }
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 24
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let userNameLabel:UILabel = {
       let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    let timeStampLabel: UILabel = {
       let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .darkGray
        label.text = "2h"
        return label
    }()
    
    let messageTextLabel:UILabel = {
       let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    //Marks:- Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(profileImageView)
        profileImageView.anchor(left:leftAnchor,paddingLeft: 12)
        profileImageView.setDimensions(height: 50, width: 50)
        profileImageView.layer.cornerRadius = 50 / 2
        profileImageView.centerY(inView: self)
        
        let stack = UIStackView(arrangedSubviews: [userNameLabel, messageTextLabel])
        stack.axis = .vertical
        stack.spacing = 4
        addSubview(stack)
        stack.centerY(inView: profileImageView)
        stack.anchor(left:profileImageView.rightAnchor, right: rightAnchor, paddingLeft: 12, paddingRight: 16)
        
        addSubview(timeStampLabel)
        timeStampLabel.anchor(top: topAnchor, right: rightAnchor, paddingTop: 20, paddingRight: 12)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //Marks:- helper
    
    func configure(){
        guard let conversation = conversation else {return}
        let  viewModel = ConversationviewModel(conversation: conversation)
        messageTextLabel.text = conversation.text
        timeStampLabel.text = viewModel.timeStamp
        
        if let id = conversation.chatPartnerId() {
              
            Service.fetchUsernameAndImage(id: id) { snapshot in
            
                    if let dictionary = snapshot.value as? [String: AnyObject] {
                        self.userNameLabel.text = dictionary["userName"] as? String

                        if let profileImageUrl = dictionary["profileImageUrl"] as? String {
                            self.profileImageView.sd_setImage(with: URL(string:profileImageUrl))
                            print(profileImageUrl)
                        }
                    }
                 }
            }
        }
}

