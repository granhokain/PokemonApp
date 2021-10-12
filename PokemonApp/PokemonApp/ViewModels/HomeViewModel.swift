//
//  HomeViewModel.swift
//  PokemonApp
//
//  Created by Rafael Martins on 12/10/21.
//

import Foundation
import PokemonAPI

final class HomeViewModel {

    var pagedObjectResult: ((PKMPagedObject<PKMPokemon>?) -> Void)?
    var showError: ((String, String) -> Void)?

    let pokemonAPI = PokemonAPI()

    func fetchPokemon(paginationState: PaginationState<PKMPokemon> = .initial(pageLimit: 20)) {
        pokemonAPI.pokemonService.fetchPokemonList(paginationState: paginationState) { result in
            switch result {
            case .success(let pagedObject):
                self.pagedObjectResult?(pagedObject)
            case .failure(let error):
                self.showError?("Something wrong!", error.localizedDescription)
            }
        }
    }
}
