//
//  SignalProducer+VoidSignal.swift
//  Reactilities
//
//  Created by Magnus Eriksson on 25/06/16.
//  Copyright © 2016 Magnus Eriksson. All rights reserved.
//

import ReactiveCocoa
import enum Result.NoError

public extension SignalProducer {
    
    ///Transforms self into a void Signal Producer. 
    ///Useful since some operators, e.g. 'sampleOn', require void SignalProducers 
    func toVoidSignalProducer() -> SignalProducer<(), NoError> {
        return map { _ -> () in }
            .flatMapError { _ in SignalProducer<(), NoError>() }
    }
}