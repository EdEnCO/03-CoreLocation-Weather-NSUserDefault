//
//  ViewController.swift
//  03-CoreLocation-Weather-NSUserDefault
//
//  Created by Gianfranco Cotumaccio on 23/06/16.
//  Copyright © 2016 Propaganda Studio. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire
import SwiftyJSON

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    // Variables
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.requestAlwaysAuthorization()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
    }
    
    // MARK: - CLLocationManagerDelegate
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("ERROR: \(error.localizedDescription)")
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("Location: \(manager.location)")
        
        let currentLocation = locationManager.location
        
        if currentLocation != nil {
            // print("Latitude: \((currentLocation?.coordinate.latitude)!) - Longitude: \((currentLocation?.coordinate.longitude)!)")
            let lat = (currentLocation?.coordinate.latitude)!
            let lon = (currentLocation?.coordinate.longitude)!
            Alamofire.request(.GET, "http://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(lon)&appid=fc5edb9fa5d86243573c9a9fc26f8d86").validate().responseJSON(completionHandler: { (response) in
                switch response.result {
                case .Success:
                    let json = JSON(response.result.value!)
                    print(json)
                case .Failure(let error):
                    print(error)
                }
                // print(response.result.value)
            })
        }
        
        manager.stopUpdatingLocation()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

