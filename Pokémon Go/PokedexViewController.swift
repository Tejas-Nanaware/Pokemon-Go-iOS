//
//  PokedexViewController.swift
//  Pokémon Go
//
//  Created by admin on 06/04/17.
//  Copyright © 2017 ACE. All rights reserved.
//

import UIKit

class PokedexViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var caughtPokemon : [Pokemon] = []
    var uncaughtPokemon : [Pokemon] = []
    
    @IBOutlet weak var pokeBag: UITableView!
    @IBAction func viewPokeMap(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        caughtPokemon = getAllCaughtPokemon()
        uncaughtPokemon = getAllUncaughtPokemon()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // Hidden Status Bar
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    
    // UITableViewDataSource functions
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Caught Pokémons"
        } else {
            return "Uncaught Pokémons"
        }
    }
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (section == 0) {
            return caughtPokemon.count
        } else {
            return uncaughtPokemon.count
        }
    }
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        var pokemon : Pokemon
        if indexPath.section == 0 {
            pokemon = self.caughtPokemon[indexPath.row]
        } else {
            pokemon = self.uncaughtPokemon[indexPath.row]
        }
        
        cell.textLabel?.text = pokemon.name
        cell.imageView?.image = UIImage(named: pokemon.imageFileName!)
        return cell
    }
}
