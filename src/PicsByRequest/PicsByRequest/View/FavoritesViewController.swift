
import Foundation
import UIKit

final class FavoritesViewController : UITableViewController {
    private let viewModel: FavoritesViewModel
    
    init(viewModel: FavoritesViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Favorites"
        view.backgroundColor = Colors.Common.background
        
        tableView.register(FavoriteImageTableViewCell.self, forCellReuseIdentifier: FavoriteImageTableViewCell.identifier)
        
        viewModel.favoritesCollectionChangedAction = { [weak self] in
            self?.tableView.reloadData()
        }
        viewModel.deleteRowsAction = { [weak self] indexPath in
            self?.tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return FavoriteImageTableViewCell.topMargin + FavoriteImageTableViewCell.imageHeight + FavoriteImageTableViewCell.bottomMargin
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.favorites.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FavoriteImageTableViewCell.identifier, for: indexPath) as! FavoriteImageTableViewCell
        cell.selectionStyle = .none
        
        let favorite = viewModel.favorites[indexPath.row]
        cell.update(by: favorite)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive,
                                              title: "Del") { [weak self] ( action, view, completionHandler) in
            guard let self = self else {return}
            let favorite = self.viewModel.favorites[indexPath.row]
            self.viewModel.removeFromFavorites(favorite: favorite)
        }
        deleteAction.backgroundColor = .systemRed
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        
        return configuration
    }
}
