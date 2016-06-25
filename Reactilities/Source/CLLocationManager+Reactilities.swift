//
//  CLLocationManager+Reactilities.swift
//  Reactilities
//
//  Created by Magnus Eriksson on 24/06/16.
//  Copyright © 2016 Magnus Eriksson. All rights reserved.
//

import CoreLocation
import ReactiveCocoa

public extension CLLocationManager {
    
    //MARK: Public
    
    ///Creates and returns a SignalProducer which delivers a next event every time the authorization status is changed
    func rac_authStatusChangedSignalProducer() -> SignalProducer<CLAuthorizationStatus, NSError> {
        ensureDelegateExists()
        
        return rac_signalForSelector(#selector(CLLocationManagerDelegate.locationManager(_:didChangeAuthorizationStatus:)),
            fromProtocol: CLLocationManagerDelegate.self)
            .toSignalProducer()
            .map { (input: AnyObject?) -> CLAuthorizationStatus in
                guard let tuple = input as? RACTuple,
                    status = tuple.second as? NSNumber,
                    authStatus = CLAuthorizationStatus(rawValue: status.intValue) else {
                        return .NotDetermined
                }
                return authStatus
        }
    }
    
    ///Creates and returns a SignalProducer which delivers a next event every time the location is updated
    func rac_locationUpdatedSignalProducer() -> SignalProducer<[CLLocation], NSError> {
        ensureDelegateExists()
        
        return rac_signalForSelector(#selector(CLLocationManagerDelegate.locationManager(_:didUpdateLocations:)),
            fromProtocol: CLLocationManagerDelegate.self)
            .toSignalProducer()
            .map { (input: AnyObject?) -> [CLLocation] in
                let tuple = input as! RACTuple
                return tuple.second as! [CLLocation]
        }
    }
}

extension CLLocationManager: CLLocationManagerDelegate {

    //MARK: Private
    
    //Ensures that a delegate is set, else sets ourselves as delegate.
    //A delegate must be set in order to receive callbacks, such as auth status changed, location updates, etc.
    private func ensureDelegateExists() {
        if delegate == nil {
            delegate = self
        }
    }
}