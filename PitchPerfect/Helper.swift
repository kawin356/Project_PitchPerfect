//
//  Helper.swift
//  PitchPerfect
//
//  Created by Kittikawin Sontinarakul on 22/3/2563 BE.
//  Copyright © 2563 Kittikawin Sontinarakul. All rights reserved.
//

import Foundation

func delay(delayInSecond: Double, completion: @escaping () -> Void){
    DispatchQueue.main.asyncAfter(deadline: .now() + delayInSecond, execute: completion)
}

