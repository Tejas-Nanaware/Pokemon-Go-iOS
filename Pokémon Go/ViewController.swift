//
//  ViewController.swift
//  Pokémon Go
//
//  Created by admin on 06/04/17.
//  Copyright © 2017 ACE. All rights reserved.
//

import UIKit
import MapKit
class ViewController: UIViewController, CLLocationManagerDelegate {
    @IBOutlet weak var mapView: MKMapView!
    var manager = CLLocationManager()
    var update = 0 // Counts till 4 then stops updating location
    
    // To reset user location
    @IBAction func userLocationRepositioning(_ sender: Any) {
        let region = MKCoordinateRegionMakeWithDistance(self.manager.location!.coordinate, 400, 400)
        self.mapView.setRegion(region, animated: true)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.manager.delegate = self
        self.manager.startUpdatingLocation()
        
        // Check and request authorization status and location showing
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            self.mapView.showsUserLocation = true
            self.manager.startUpdatingLocation()
        }
        else {
            self.manager.requestWhenInUseAuthorization()
        }
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

