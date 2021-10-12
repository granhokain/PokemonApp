//
//  HomeViewController.swift
//  PokemonApp
//
//  Created by Rafael Martins on 11/10/21.
//

import UIKit
import PokemonAPI

class HomeViewController: UIViewController {

    //MARK: Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var firstBtn: UIButton!
    @IBOutlet weak var lastBtn: UIButton!
    @IBOutlet weak var prevBtn: UIButton!
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var pageBtn: UIButton!


    //MARK: Variables
    var favorites: [String] = []
    private let viewModel = HomeViewModel()
    private let favModel = FavoriteViewModel()
    private var pagedObject: PKMPagedObject<PKMPokemon>? {
        didSet {
            if let pagedObject = pagedObject {
                DispatchQueue.main.async {
                    self.firstBtn.isEnabled = pagedObject.hasPrevious
                    self.lastBtn.isEnabled = pagedObject.hasNext
                    self.prevBtn.isEnabled = pagedObject.hasPrevious
                    self.nextBtn.isEnabled = pagedObject.hasNext

                    self.pageBtn.isEnabled = pagedObject.pages > 1
                    self.pageBtn.setTitle("Page \(pagedObject.currentPage + 1)", for: .normal)
                }
            }
        }
    }

    //MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.tableView.register(UINib(nibName: PokeTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: PokeTableViewCell.identifier)
        viewModel.fetchPokemon()
        bindViewModel()

    }

    override func viewWillAppear(_ animated: Bool) {
        firstBtn.isEnabled = false
        lastBtn.isEnabled = false
        prevBtn.isEnabled = false
        nextBtn.isEnabled = false
        pageBtn.isEnabled = false
    }


    //MARK: Actions
    @IBAction func goFirst(_ sender: Any) {
        if let pagedObject = pagedObject {
            viewModel.fetchPokemon(paginationState: .continuing(pagedObject, .first))
        }
    }

    @IBAction func goLast(_ sender: Any) {
        if let pagedObject = pagedObject {
            viewModel.fetchPokemon(paginationState: .continuing(pagedObject, .last))
        }
    }

    @IBAction func goPrevious(_ sender: Any) {
        if let pagedObject = pagedObject {
            viewModel.fetchPokemon(paginationState: .continuing(pagedObject, .previous))
        }
    }

    @IBAction func goNext(_ sender: Any) {
        if let pagedObject = pagedObject {
            viewModel.fetchPokemon(paginationState: .continuing(pagedObject, .next))
        }
    }

    @IBAction func showPages(_ sender: Any) {
        guard let pagedObject = pagedObject else {
            return
        }

        let pageVC = HomePageTableViewController()
        pageVC.pageCount = pagedObject.pages
        pageVC.delegate = self

        pageVC.modalPresentationStyle = .popover
        pageVC.preferredContentSize = CGSize(width: 100, height: 400)

        if let popover = pageVC.popoverPresentationController {
            popover.delegate = self
            popover.permittedArrowDirections = .down

            if let button = sender as? UIButton {
                popover.sourceView = button
                popover.sourceRect = button.bounds
            }

            self.present(pageVC, animated: true)
        }
    }

    func setFavorite(cell: UITableViewCell) {
        guard let indexPathTapped = tableView.indexPath(for: cell) else {
            return
        }
        if let pokemon = pagedObject?.results?[indexPathTapped.row] as? PKMNamedAPIResource {
            self.favorites.append(pokemon.name ?? "")
            favModel.setFavoriteList(name: pokemon.name ?? "")
        }
    }


    //MARK: BindViewModel
    private func bindViewModel() {

        viewModel.pagedObjectResult = { [unowned self] pagedObject in
            self.pagedObject = pagedObject
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

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pagedObject?.results?.count ?? 0
    }


    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "PokeTableViewCell", for: indexPath) as! PokeTableViewCell
        cell.table = self
        if let pokemon = pagedObject?.results?[indexPath.row] as? PKMNamedAPIResource {
            cell.lblPokeName.text = pokemon.name
        }
        return cell
    }
}

// MARK: - UITableViewDelegate

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - PageSelectDelegate

extension HomeViewController:  PageSelectDelegate {
    func didSelectPageIndex(_ pageIndex: Int) {
        if let pagedObject = pagedObject {
            viewModel.fetchPokemon(paginationState: .continuing(pagedObject, .page(pageIndex)))
        }
    }
}

// MARK: - UIPopoverPresentationControllerDelegate

extension HomeViewController: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return .none
    }
}
