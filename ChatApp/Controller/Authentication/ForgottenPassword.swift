import UIKit

class ForgottenPassword:UIViewController{
    
    //Marks:-Properties
    private var viewModel = ForgotViewModel()
    
    private let iconImage: UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage(systemName: "questionmark.circle.fill")
        imgView.tintColor = .systemPurple
        return imgView
    }()
    
    private let setPassword: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Send Link", for: .normal)
        button.layer.cornerRadius = 20
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.backgroundColor = #colorLiteral(red: 1, green: 0.5212053061, blue: 1, alpha: 1)
        button.setTitleColor(.white, for: .normal)
        button.setHeight(height: 50)
        button.isEnabled = false
        button.addTarget(self, action: #selector(handeForgotPassword), for: .touchUpInside)
        return button
    }()
    
    private let backButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .systemPurple
        button.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        button.addTarget(self, action: #selector(handelDismissal), for: .touchUpInside)
        return button
    }()
    
    
    private lazy var emailContainerView: UIView = {
        return InputContainerView(image: UIImage(systemName: "envelope")!, textField: emailTextField)
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
        Service.forgotPassword(email: email, completion: { (error) in
            if let error = error {
                print(error.localizedDescription)
                self.showLoader(false)
                return
            }
            print("Password reset link sent")
            self.showLoader(false)
            self.navigationController?.popViewController(animated: true)
        })
    }
    
    @objc func textDidChange(sender: UITextField){
        if sender == emailTextField {
            viewModel.email = sender.text
        }
        checkFormStatus()
    }
    
    @objc func handelDismissal(){
        navigationController?.popViewController(animated: true)
    }
    
    
    //Marks:- Helper
    
    func configureUI(){
        view.backgroundColor = .white
        view.addSubview(backButton)
        backButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, paddingTop: 16, paddingLeft: 16)
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
            setPassword.backgroundColor = .systemPurple
        }else{
            setPassword.isEnabled = false
            setPassword.backgroundColor = #colorLiteral(red: 1, green: 0.5212053061, blue: 1, alpha: 1)
        }
    }
}
