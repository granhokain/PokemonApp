//
//  FavoriteViewController.swift
//  PokemonApp
//
//  Created by Rafael Martins on 11/10/21.
//

import UIKit

class FavoriteViewController: UIViewController {

    @IBOutlet weak var viewNoFavorites: UIView!
    @IBOutlet weak var tableView: UITableView!

    //MARK: Variables
    var favorites: [String] = []
    private let viewModel = FavoriteViewModel()

    //MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        bindViewModel()

    }

    override func viewWillAppear(_ animated: Bool) {
        //viewModel.getFavorites()
        if favorites.isEmpty {
            tableView.isHidden = true
            viewNoFavorites.isHidden = false
        } else {
            tableView.isHidden = false
            viewNoFavorites.isHidden = true
        }
    }

    //MARK: BindViewModel
    private func bindViewModel() {
        viewModel.showFavorites = { [unowned self] favorites in
            self.favorites = favorites
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }

        viewModel.showError = { [unowned self] title, message in
            let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }


}

// MARK: - UITableViewDataSource

extension FavoriteViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.favorites.count
    }


    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "PokeTableViewCell", for: indexPath) as! PokeTableViewCell

            cell.lblPokeName.text = favorites[indexPath.row]

        return cell
    }
}

// MARK: - UITableViewDelegate

extension FavoriteViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
