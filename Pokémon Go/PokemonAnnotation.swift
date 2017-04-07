//
//  PokemonAnnotation.swift
//  Pokémon Go
//
//  Created by Tejas on 06/04/17.
//  Copyright © 2017 Tejas-Nanaware. All rights reserved.
//

import UIKit
import MapKit
class PokemonAnnotation: NSObject, MKAnnotation {

    var coordinate = CLLocationCoordinate2D()
    var pokemon : Pokemon
    init(coordinate : CLLocationCoordinate2D, pokemon : Pokemon) {
        self.coordinate = coordinate
        self.pokemon = pokemon
    }
}
