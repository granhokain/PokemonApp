//
//  HomePageTableViewController.swift
//  PokemonApp
//
//  Created by Rafael Martins on 12/10/21.
//

import UIKit


protocol PageSelectDelegate: class {
    func didSelectPageIndex(_ pageIndex: Int)
}

class HomePageTableViewController: UITableViewController {
    public var pageCount = 0

    public weak var delegate: PageSelectDelegate?

    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        self.preferredContentSize = CGSize(width: 100, height: 400)
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pageCount
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell! = tableView.dequeueReusableCell(withIdentifier: "Cell")

        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "Cell")
        }

        cell.textLabel?.text = "Page \(indexPath.row + 1)"

        return cell
    }

    // MARK: - Table view delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        delegate?.didSelectPageIndex(indexPath.row)
        self.dismiss(animated: true)
    }
}
