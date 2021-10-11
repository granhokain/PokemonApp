//
//  LoginViewModel.swift
//  PokemonApp
//
//  Created by Rafael Martins on 11/10/21.
//

import Foundation

final class LoginViewModel {

    var showHome: (() -> Void)?
    var showError: ((String, String) -> Void)?






    func login(user: String, password: String) {
        if user != "test" {
            self.showError?("Something wrong!", "Invalid User")
        } else if password != "123456"{
            self.showError?("Something wrong!", "Invalid Password")
        } else {
            self.showHome?()
        }
    }
}

