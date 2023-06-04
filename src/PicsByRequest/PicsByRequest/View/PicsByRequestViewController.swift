
import Foundation
import UIKit

final class PicsByRequestController : UIViewController {
    
    private lazy var searchField: UITextField = {
        let textField = TextFieldWithPadding()
        textField.accessibilityIdentifier = "searchField"
        textField.placeholder = PicsByRequestLocalizer.imageRequestPlaceholder.rawValue.localize(from: .requestImageDictionary)
        textField.backgroundColor = Colors.Common.textFieldBackground
        textField.keyboardType = .emailAddress
        textField.layer.cornerRadius = 22
        textField.addTarget(self, action: #selector(searchFieldTextChanged), for: .editingChanged)
        
        textField.toAutoLayout()
        
        return textField
    }()
    
    private lazy var searchButton: UIButton = {
        let button = UIButton()
        button.accessibilityIdentifier = "searchButton"
        button.setTitle(PicsByRequestLocalizer.searchButtonCaption.rawValue.localize(from: .requestImageDictionary), for: .normal)
        button.setTitleColor(.lightGray, for: .disabled)
        button.titleLabel?.font = Fonts.forButtons
        button.backgroundColor = Colors.Common.buttonBackground
        button.layer.cornerRadius = 21
        button.addTarget(self, action: #selector(searchButtonTouch), for: .touchUpInside)
        
        button.toAutoLayout()
        
        return button
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.accessibilityIdentifier = "imageView"
        imageView.toAutoLayout()
        
        imageView.layer.cornerRadius = 5
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var addToFavoritesButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "Star"), for: .normal)
        button.addTarget(self, action: #selector(addToFavoritesButtonTouched), for: .touchUpInside)
        
        button.toAutoLayout()
        
        return button
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        
        indicator.toAutoLayout()
        
        return indicator
    }()
    
    private let viewModel: PicsByRequestViewModel
    
    private var currrentResponse: ImageResponse?
    
    private var addToFavoritesButtonBottomConstraint: NSLayoutConstraint! = nil
    
    init(viewModel: PicsByRequestViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = PicsByRequestLocalizer.title.rawValue.localize(from: .requestImageDictionary)
        view.backgroundColor = Colors.Common.background
        
        self.viewModel.pictureLoadedAction = pictureLoadedAction(response:)
        self.viewModel.errorAction = { [weak self] error in
            self?.showMessage(title: "Error", message: error.localizedDescription)
        }
        
        setupConstraints()
        
        searchButton.isEnabled = searchField.hasText
        addToFavoritesButton.isEnabled = currrentResponse != nil
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil)

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil)
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
    
    @objc
    private func addToFavoritesButtonTouched() {
        
        guard let response = currrentResponse else {return}
        
        viewModel.addToFavorites(text: response.text, imageData: response.imageData)
    }
    
    @objc func keyboardWillShow(_ notification: NSNotification) {
        moveViewWithKeyboard(notification: notification, keyboardWillShow: true)
    }
    
    @objc func keyboardWillHide(_ notification: NSNotification) {
        moveViewWithKeyboard(notification: notification, keyboardWillShow: false)
    }
    
    func moveViewWithKeyboard(notification: NSNotification, keyboardWillShow: Bool) {
        // Keyboard's size
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        let keyboardHeight = keyboardSize.height
        
        // Keyboard's animation duration
        let keyboardDuration = notification.userInfo![UIResponder.keyboardAnimationDurationUserInfoKey] as! Double
        
        // Keyboard's animation curve
        let keyboardCurve = UIView.AnimationCurve(rawValue: notification.userInfo![UIResponder.keyboardAnimationCurveUserInfoKey] as! Int)!
        
        // Change the constant
        if keyboardWillShow {
            let safeAreaExists = (self.view?.window?.safeAreaInsets.bottom != 0) // Check if safe area exists
            let bottomConstant: CGFloat = 5
            addToFavoritesButtonBottomConstraint.constant = -(keyboardHeight + (safeAreaExists ? 0 : bottomConstant))
        } else {
            addToFavoritesButtonBottomConstraint.constant = -16
        }
        
        // Animate the view the same way the keyboard animates
        let animator = UIViewPropertyAnimator(duration: keyboardDuration, curve: keyboardCurve) { [weak self] in
            // Update Constraints
            self?.view.layoutIfNeeded()
        }
        
        // Perform the animation
        animator.startAnimation()
    }
    
    private func pictureLoadedAction(response: ImageResponse) {
        DispatchQueue.global().async { [weak self] in
            self?.currrentResponse = response
            
            DispatchQueue.main.async { [weak self] in
                guard let self = self else {return}
                
                if let image = UIImage(data: response.imageData) {
                    image.isAccessibilityElement = true
                    image.accessibilityIdentifier = "loadedImage"
                    self.imageView.image = image
                } else {
                    self.showMessage(title: "Error data", message: "Error loading image from data!")
                }
                
                self.activityIndicator.stopAnimating()
                self.addToFavoritesButton.isEnabled = self.currrentResponse != nil
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
        
        view.addSubview(addToFavoritesButton)
        self.addToFavoritesButtonBottomConstraint = addToFavoritesButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        NSLayoutConstraint.activate([
            addToFavoritesButton.widthAnchor.constraint(equalToConstant: 50),
            addToFavoritesButton.heightAnchor.constraint(equalToConstant: 50),
            addToFavoritesButton.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -16),
            self.addToFavoritesButtonBottomConstraint
        ])
    }
}
