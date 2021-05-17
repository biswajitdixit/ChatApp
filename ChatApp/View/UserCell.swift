import UIKit

class UserCell: UITableViewCell{
    //Marks:- Properties
    private let profileImageView:UIImageView = {
       let imgView = UIImageView()
        imgView.backgroundColor = .systemPurple
       imgView.contentMode = .scaleAspectFill
       imgView.clipsToBounds = true
        return imgView
    }()
    
    private let userNameLabel: UILabel = {
      let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.text = "spiderman"
        return label
    }()
    private let fullNameLabel: UILabel = {
      let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .gray
        label.text = "Peter Parker"
        return label
    }()
    //Marks:- LifeCycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(profileImageView)
        profileImageView.centerY(inView: self, leftAnchor: leftAnchor, paddingLeft: 12)
        profileImageView.setDimensions(height: 56, width: 56)
        profileImageView.layer.cornerRadius = 56 / 2
        
        let stack = UIStackView(arrangedSubviews: [userNameLabel, fullNameLabel])
        stack.axis = .vertical
        stack.spacing = 2
        
        addSubview(stack)
        stack.centerY(inView:self, leftAnchor: profileImageView.rightAnchor, paddingLeft: 12 )
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
