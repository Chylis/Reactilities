//
//  ViewController.swift
//  Demo
//
//  Created by Magnus Eriksson on 24/06/16.
//  Copyright © 2016 Magnus Eriksson. All rights reserved.
//

import UIKit
import Reactilities
import ReactiveCocoa
import CoreLocation
import enum Result.NoError

class ViewController: UIViewController {
    
    let requester = LocationTracker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        requester.requestLocationAccess()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        requester.startUpdatingLocations()
    }
}


struct LocationTracker {
    
    let manager = CLLocationManager()
    
    func requestLocationAccess() {
        manager.rac_authStatusChangedSignalProducer()
            .filter { $0 == .NotDetermined }
            .startWithNext { [weak manager] _ in
                manager?.requestWhenInUseAuthorization()
        }
    }
    
    func startUpdatingLocations() {
        
        let distanceMeterFilter: CLLocationDistance = 5
        let durationSecondsFilter: NSTimeInterval = 5
        
        manager.distanceFilter = distanceMeterFilter
        manager.rac_locationUpdatedSignalProducer()
            .sampleOn(NSTimer.rac_signalWithRepeatedInterval(durationSecondsFilter))
            .filter { locations in locations.count > 0 }
            .skipRepeats { (loc1, loc2) -> Bool in
                let coord1 = loc1.first!.coordinate
                let coord2 = loc2.first!.coordinate
                return (coord1.latitude == coord2.latitude && coord1.longitude == coord2.longitude)
            }
            .map { $0.first! }
            .startWithNext { location in
                //'location' is distinct from the previous one, with a distance difference of at least 5 meters and at least 5 seconds between each location update
                print("\(NSDate()): \(location)")
        }
        
        manager.rac_authStatusChangedSignalProducer()
            .filter { $0 == .AuthorizedWhenInUse }
            .startWithNext { [weak manager] _ in
                print("Let's start updating locations!")
                manager?.startUpdatingLocation()
        }
    }
}