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
    var weather = NSUserDefaults.standardUserDefaults()
    var networkReachability = NetworkReachabilityManager(host: "openweathermap.org")
    
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
        let currentLocation = locationManager.location
        
        if currentLocation != nil {
            let lat = (currentLocation?.coordinate.latitude)!
            let lon = (currentLocation?.coordinate.longitude)!
            
            /*
            networkReachability?.listener = { status in
                print("Network Status Changed: \(status)")
            }
            
            networkReachability?.startListening()
            */
            
            if networkReachability?.isReachable != false {
                print("Reachable")
                Alamofire.request(.GET, "http://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(lon)&appid=fc5edb9fa5d86243573c9a9fc26f8d86").validate().responseJSON(completionHandler: { (response) in
                    switch response.result {
                    case .Success:
                        let json = JSON(response.result.value!)
                        self.weather.setObject(json["name"].string, forKey: "cityName")
                        self.weather.setObject(json["weather"][0]["description"].string, forKey: "weatherDescription")
                        print(json)
                    case .Failure(let error):
                        print(error)
                    }
                })
            } else {
                print("Not Reachable")
                if weather.objectForKey("cityName") != nil {
                    print(weather.objectForKey("cityName")!)
                    print(weather.objectForKey("weatherDescription")!)
                } else {
                    print("Network is not reachable and dataBase is empty!")
                }
            }
            
        }
        
        manager.stopUpdatingLocation()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

