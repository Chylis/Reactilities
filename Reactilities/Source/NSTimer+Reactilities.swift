//
//  NSTimer+Reactilities.swift
//  Reactilities
//
//  Created by Magnus Eriksson on 25/06/16.
//  Copyright © 2016 Magnus Eriksson. All rights reserved.
//

import ReactiveCocoa
import enum Result.NoError

public extension NSTimer {
    
    ///Creates a Void SignalProducer that sends next events every 'interval'
    public class func rac_signalWithRepeatedInterval(interval: NSTimeInterval) -> SignalProducer<(), NoError> {
        return SignalProducer<(), NoError> { observer, _disposable in
            let now = CFAbsoluteTimeGetCurrent()
            let timer = CFRunLoopTimerCreateWithHandler(kCFAllocatorDefault, now, interval, 0, 0) { _timer in
                observer.sendNext()
            }
            CFRunLoopAddTimer(CFRunLoopGetCurrent(), timer, kCFRunLoopCommonModes)
        }
    }
}