//
//  ViewController.swift
//  Pokémon Go
//
//  Created by admin on 06/04/17.
//  Copyright © 2017 ACE. All rights reserved.
//

import UIKit
import MapKit
class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    @IBOutlet weak var mapView: MKMapView!
    var manager = CLLocationManager()
    var update = 0 // Counts till 4 then stops updating location
    
    
    var pokemon : [Pokemon] = []
    
    // To reset user location
    @IBAction func userLocationRepositioning(_ sender: Any) {
        let region = MKCoordinateRegionMakeWithDistance(self.manager.location!.coordinate, 400, 400)
        self.mapView.setRegion(region, animated: true)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.manager.delegate = self
        self.mapView.delegate = self
        self.manager.startUpdatingLocation()
        
        pokemon = bringAllPokemon()
        // Check and request authorization status and location showing
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            self.mapView.showsUserLocation = true
            self.manager.startUpdatingLocation()
            
            // Timer
            Timer.scheduledTimer(withTimeInterval: 4, repeats: true, block: {
                (timer)in
                if let coordinate = self.manager.location?.coordinate {
                    let randomPokemon = Int(arc4random_uniform(UInt32(self.pokemon.count)))
                    let pokemon = self.pokemon[randomPokemon]
                    
                    let annotation = PokemonAnnotation(coordinate: coordinate, pokemon: pokemon)
                    annotation.coordinate = coordinate
                    annotation.coordinate.latitude += (Double(arc4random_uniform(1000)) - 500) / 300000.0
                    annotation.coordinate.longitude += (Double(arc4random_uniform(1000)) - 500) / 300000.0
                    self.mapView.addAnnotation(annotation)
                }
            }
            )
        }
        else {
            self.manager.requestWhenInUseAuthorization()
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: nil)
        if annotation is MKUserLocation {
            annotationView.image = #imageLiteral(resourceName: "player")
        }
        else {
            let pokemon = (annotation as! PokemonAnnotation).pokemon
            annotationView.image = UIImage(named: pokemon.imageFileName!)
        }
        var newFrame = annotationView.frame
        newFrame.size.width = 40
        newFrame.size.height = 40
        annotationView.frame = newFrame
        return annotationView
    }
    
    // To set map region
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            if update < 4 {
                let region = MKCoordinateRegionMakeWithDistance(self.manager.location!.coordinate, 400, 400)
                    self.mapView.setRegion(region, animated: true)

                update += 1
                print("updating")
        }
        else {
            self.manager.stopUpdatingLocation()
            print("stopped")
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

