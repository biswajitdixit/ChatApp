import UIKit
import SDWebImage

protocol ProfileDelegate:class {
    func dismissController()
}
protocol EditProfileImage:class {
    func editProfileImage()
}

class Profile: UIView{

    //Marks:- Properties
    var user: User? {
        didSet { populateUserData() }
    }
    
    weak var delegate: ProfileDelegate?
    weak var imageDelegate: EditProfileImage?
    
    private let dismissButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.addTarget(self, action: #selector(handelDismissal), for: .touchUpInside)
        button.tintColor = .white
        button.imageView?.setDimensions(height: 22, width: 22)
        return button
    }()
    
     var profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        iv.layer.borderColor = UIColor.white.cgColor
        iv.layer.borderWidth = 4.0
        return iv
    }()
    
    private let editProfileImage: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "camera"), for: .normal)
        button.backgroundColor = .systemPurple
        button.tintColor = .white
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 2.0
        button.imageView?.setDimensions(height: 24, width: 24)
        button.addTarget(self, action: #selector(editImage), for: .touchUpInside)
        return button
    }()
    
    private let fullNameLabel: UILabel = {
       let label = UILabel()
       label.font = UIFont.boldSystemFont(ofSize: 20)
       label.textColor = .white
       label.textAlignment = .center
       return label
        
    }()
    
    private let userNamelabel: UILabel = {
        let label = UILabel()
        label.font =  UIFont.boldSystemFont(ofSize: 16)
        label.textColor = .white
        label.textAlignment = .center
        return label
        
    }()
    
    //Marks:- Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemPurple
        configureUI()
    
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //Marks:-Selector
    @objc func handelDismissal(){
        delegate?.dismissController()
    }
    
    @objc func editImage(){
        imageDelegate?.editProfileImage()
    }
    
    //Marks: - Helpers
    
    func populateUserData(){
        guard let user = user else {return}
        
        fullNameLabel.text = user.fullName
        userNamelabel.text = "@" + user.userName!
        guard let url = URL(string: user.profileImageUrl ?? "") else {return}
        profileImageView.sd_setImage(with: url)
    }
    
    func configureUI(){
        profileImageView.setDimensions(height: 200, width: 200)
        profileImageView.layer.cornerRadius = 200 / 2
        
        addSubview(profileImageView)
        profileImageView.centerX(inView: self)
        profileImageView.anchor(top:topAnchor, paddingTop: 96)
        
        editProfileImage.setDimensions(height: 56, width: 56)
        editProfileImage.layer.cornerRadius = 56 / 2
        
        addSubview(editProfileImage)
        editProfileImage.anchor(bottom: bottomAnchor, right: profileImageView.rightAnchor, paddingBottom: 80)
        
        let stack = UIStackView(arrangedSubviews: [fullNameLabel, userNamelabel])
        stack.axis = .vertical
        stack.spacing = 4
        
        addSubview(stack)
        stack.centerX(inView: self)
        stack.anchor(top: profileImageView.bottomAnchor, paddingTop: 16)
        
        addSubview(dismissButton)
        dismissButton.anchor(top: topAnchor, left: leftAnchor, paddingTop: 44, paddingLeft: 12)
        dismissButton.setDimensions(height: 48, width: 48)
    }
    
}
