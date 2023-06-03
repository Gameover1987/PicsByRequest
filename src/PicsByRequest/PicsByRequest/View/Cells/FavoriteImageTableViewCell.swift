
import Foundation
import UIKit

final class FavoriteImageTableViewCell : UITableViewCell {
    static let identifier = "FavoriteImageTableViewCell"
    
    static let leftMargin = 8.0
    static let topMargin = 8.0
    static let imageHeight = 50.0
    static let imageWidth = 50.0
    static let bottomMargin = 8.0
    
    private lazy var favoriteImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        imageView.toAutoLayout()
        return imageView
    }()
    
    private lazy var textRequestLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.forCaptions
        label.toAutoLayout()
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(favoriteImageView)
        NSLayoutConstraint.activate([
            favoriteImageView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: FavoriteImageTableViewCell.leftMargin),
            favoriteImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: FavoriteImageTableViewCell.topMargin),
            favoriteImageView.widthAnchor.constraint(equalToConstant: FavoriteImageTableViewCell.imageWidth),
            favoriteImageView.heightAnchor.constraint(equalToConstant: FavoriteImageTableViewCell.imageHeight),
        ])
        
        contentView.addSubview(textRequestLabel)
        NSLayoutConstraint.activate([
            textRequestLabel.leftAnchor.constraint(equalTo: favoriteImageView.rightAnchor, constant: 8),
            textRequestLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -8),
            textRequestLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(by favorite: FavoriteEntity) {
        
        guard let image = UIImage(data: favorite.imageData!) else {return}
        
        favoriteImageView.image = image
        textRequestLabel.text = favorite.text
    }
}
