//
//  FavoriteViewModel.swift
//  PokemonApp
//
//  Created by Rafael Martins on 12/10/21.
//

import Foundation

final class FavoriteViewModel {

    var showFavorites: (([String]) -> Void)?
    var showError: ((String, String) -> Void)?
    var homeFavorites: [String]?

    func getFavorites() {
        guard let favorites = homeFavorites else {
            return
        }
        self.showFavorites?(favorites)
    }

    func setFavoriteList(name: String) {
        let fav = FavoriteViewController()
        homeFavorites?.append(name)
        fav.favorites.append(name)
    }
}
