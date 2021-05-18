import UIKit

class ForgottenPassword:UIViewController{
    
    //Marks:-Properties
    private var viewModel = ForgotViewModel()
    
    private let iconImage: UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage(systemName: "questionmark.circle.fill")
        imgView.tintColor = .white
        return imgView
    }()
    
    private let setPassword: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Send Link", for: .normal)
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.backgroundColor = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)
        button.setTitleColor(.white, for: .normal)
        button.setHeight(height: 50)
        button.isEnabled = false
        button.addTarget(self, action: #selector(handeForgotPassword), for: .touchUpInside)
        return button
    }()
    
    
    private lazy var emailContainerView: UIView = {
        return InputContainerView(image: #imageLiteral(resourceName: "ic_mail_outline_white_2x"), textField: emailTextField)
    }()
    
    private let emailTextField = CustomTextField(placeholder: "Email")
    
    //Marks:-LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    //Marks:- Selector
    
    @objc func handeForgotPassword(){
        guard let email = emailTextField.text else{return}
        showLoader(true,withText: "Sending Link")
        AuthService.shared.forgotPassword(withEmail: email) { error in
            if let error = error {
                print(error.localizedDescription)
                self.showLoader(false)
                return
            }
            self.showLoader(false)
            self.navigationController?.popViewController(animated: true)
        }
    }
    @objc func textDidChange(sender: UITextField){
        if sender == emailTextField {
            viewModel.email = sender.text
        }
       checkFormStatus()
    }
    
    
    //Marks:- Helper
    
    func configureUI(){
        configureGradiantLayer()
        view.addSubview(iconImage)
        iconImage.centerX(inView: view)
        iconImage.anchor(top:view.safeAreaLayoutGuide.topAnchor, paddingTop: 32)
        iconImage.setDimensions(height: 120, width: 120)
        
        
        let stack = UIStackView(arrangedSubviews: [emailContainerView, setPassword])
        stack.axis = .vertical
        stack.spacing = 24
        
        view.addSubview(stack)
        stack.anchor(top:iconImage.bottomAnchor, left: view.leftAnchor,right: view.rightAnchor, paddingTop: 32, paddingLeft: 32, paddingRight: 32)
        
        
        emailTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
    }
    
}

extension ForgottenPassword: AuthenticationControllerProtocol {
    
    func checkFormStatus(){
        if viewModel.formIsValid{
            setPassword.isEnabled = true
            setPassword.backgroundColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
        }else{
            setPassword.isEnabled = false
            setPassword.backgroundColor = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)
        }
    }
}
