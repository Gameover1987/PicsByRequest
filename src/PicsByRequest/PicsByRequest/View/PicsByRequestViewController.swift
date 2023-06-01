
import Foundation
import UIKit

final class PicsByRequestController : UIViewController {
    
    private lazy var searchField: UITextField = {
        let textField = TextFieldWithPadding()
        textField.placeholder = "Картинка по запросу"
        textField.backgroundColor = Colors.Common.textFieldBackground
        textField.keyboardType = .emailAddress
        textField.layer.cornerRadius = 22
        textField.addTarget(self, action: #selector(searchFieldTextChanged), for: .editingChanged)
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var searchButton: UIButton = {
        let button = UIButton()
        button.setTitle("Search", for: .normal)
        button.setTitleColor(.lightGray, for: .disabled)
        button.titleLabel?.font = Fonts.forButtons
        button.backgroundColor = Colors.Common.buttonBackground
        button.layer.cornerRadius = 21
        button.addTarget(self, action: #selector(searchButtonTouch), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 5
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    private let viewModel: PicsByRequestViewModel
    
    init(viewModel: PicsByRequestViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        title = "Pics by request"
        view.backgroundColor = Colors.Common.background
        
        self.viewModel.pictureLoadedAction = pictureLoadedAction(response:)
        
        setupConstraints()
        
        searchButton.isEnabled = searchField.hasText
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    @objc
    private func searchFieldTextChanged() {
        searchButton.isEnabled = searchField.hasText
    }
    
    @objc
    private func searchButtonTouch() {
        imageView.image = nil
        activityIndicator.startAnimating()
        viewModel.loadPicture(by: searchField.text!)
    }
    
    private func pictureLoadedAction(response: ImageResponse) {
        DispatchQueue.global().async { [weak self] in
            
            if let image = UIImage(data: response.imageData) {
                DispatchQueue.main.async {
                    self?.imageView.image = image
                    self?.activityIndicator.stopAnimating()
                }
            }
        }
        
    }
    
    private func setupConstraints() {
        view.addSubview(searchButton)
        NSLayoutConstraint.activate([
            searchButton.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -16),
            searchButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            searchButton.widthAnchor.constraint(equalToConstant: 70),
            searchButton.heightAnchor.constraint(equalToConstant: 50),
        ])
        
        view.addSubview(searchField)
        NSLayoutConstraint.activate([
            searchField.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 16),
            searchField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            searchField.rightAnchor.constraint(equalTo: searchButton.leftAnchor, constant: -16),
            searchField.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        view.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 16),
            imageView.topAnchor.constraint(equalTo: searchField.bottomAnchor, constant: 16),
            imageView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -16),
            imageView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
        ])
        
        view.addSubview(activityIndicator)
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: imageView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: imageView.centerYAnchor),
            activityIndicator.widthAnchor.constraint(equalToConstant: 50),
            activityIndicator.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}
