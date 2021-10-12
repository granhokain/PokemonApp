//
//  PokeTableViewCell.swift
//  PokemonApp
//
//  Created by Rafael Martins on 12/10/21.
//

import UIKit

class PokeTableViewCell: UITableViewCell {


    @IBOutlet weak var lblPokeName: UILabel!
    @IBOutlet weak var btnFavorite: UIButton!

    var table: HomeViewController?

    class var identifier: String {
        return String(describing: self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String!) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func setFavorite(_ sender: Any) {
        table?.setFavorite(cell: self)
        if btnFavorite.image(for: .normal) == UIImage(named: "fullStar") {
            btnFavorite.setImage(UIImage(named: "emptyStar"), for: .normal)
        } else {
            btnFavorite.setImage(UIImage(named: "fullStar"), for: .normal)
        }
    }

}
