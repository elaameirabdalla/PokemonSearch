//
//  PokemonDetailsViewController.swift
//  PokemonSearch
//
//  Created by Abdalla Elaameir on 6/6/24.
//

import UIKit
import Kingfisher

class PokemonDetailsViewController: UIViewController {
    
    // MARK: View Controller that displays Pokemon details. Configured by PokemonDetailsViewModel that is stored and called upon viewDidLoad.
    @IBOutlet weak var pokemonImageView: UIImageView!
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var typesLabel: UILabel!
    @IBOutlet weak var statsLabel: UILabel!
    
    var model: PokemonDetailsViewModel? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let model = model {
            configure(model: model)
        }
    }
    
     func configure(model: PokemonDetailsViewModel) {
        pokemonImageView.kf.setImage(with: URL(string: model.href))
        nameLabel.text = "Name: " + model.name
        idLabel.text = "ID: " + String(model.id)
        weightLabel.text = "Weight: " + String(model.weight)
        heightLabel.text = "Height: " + String(model.height)
        statsLabel.text = "Stats: " + model.stats
        typesLabel.text = "Types: " + model.types
    }
}
