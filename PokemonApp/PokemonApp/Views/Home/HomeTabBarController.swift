//
//  HomeTabBarController.swift
//  PokemonApp
//
//  Created by Rafael Martins on 12/10/21.
//

import Foundation
import UIKit

class HomeTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let image = UIImage(named: "pokeballIcon")!
        tabBar.items![0].image = image
    }
}
