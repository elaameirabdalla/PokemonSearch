//
//  PokemonSearchCell.swift
//  PokemonSearch
//
//  Created by Abdalla Elaameir on 6/6/24.
//

import UIKit

class PokemonSearchCell: UITableViewCell {
    
    // MARK: Custom table view cell for showing Pokemon names. Stores PokemonSearchViewModel with name and url used to load details page when cell is selected
    @IBOutlet weak var nameLabel: UILabel!
    
    var model: PokemonSearchViewModel! {
        didSet {
            nameLabel.text = model.name
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.nameLabel.text = ""
    }


}
