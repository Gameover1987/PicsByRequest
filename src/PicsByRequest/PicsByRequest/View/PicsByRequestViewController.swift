
import Foundation
import UIKit

final class PicsByRequestController : UIViewController {
    
    private lazy var inputFiled: UITextField = {
        let textField = TextFieldWithPadding()
        textField.placeholder = "Картинка по запросу"
        textField.backgroundColor = Colors.Common.textFieldBackground
        textField.keyboardType = .emailAddress
        textField.layer.cornerRadius = 22
        textField.addTarget(self, action: #selector(picsRequestFielChanged), for: .editingChanged)
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var searchButton: UIButton = {
        let button = UIButton()
        button.setTitle("Search", for: .normal)
        button.titleLabel?.font = Fonts.forButtons
        button.backgroundColor = Colors.Common.buttonBackground
        button.layer.cornerRadius = 21
        //button.addTarget(self, action: #selector(loginButtonTouch), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var image: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 5
//        imageView.layer.borderWidth = 1
//        imageView.layer.borderColor = Colors.TabBar.borderColor.cgColor
        return imageView
    }()
    
    override func viewDidLoad() {
        title = "Pics by request"
        view.backgroundColor = Colors.Common.background
        
        setupConstraints()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    @objc
    private func picsRequestFielChanged() {
        //loginViewModel.email = emailTextField.text!
    }
    
    private func setupConstraints() {
        view.addSubview(searchButton)
        NSLayoutConstraint.activate([
            searchButton.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -16),
            searchButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            searchButton.widthAnchor.constraint(equalToConstant: 70),
            searchButton.heightAnchor.constraint(equalToConstant: 50),
        ])
        
        view.addSubview(inputFiled)
        NSLayoutConstraint.activate([
            inputFiled.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 16),
            inputFiled.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            inputFiled.rightAnchor.constraint(equalTo: searchButton.leftAnchor, constant: -16),
            inputFiled.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        view.addSubview(image)
        NSLayoutConstraint.activate([
            image.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 16),
            image.topAnchor.constraint(equalTo: inputFiled.bottomAnchor, constant: 16),
            image.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -16),
            image.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
        ])
    }
}
