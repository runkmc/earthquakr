//
//  QuakeList.swift
//  Earthquakr
//
//  Created by Kevin McGladdery on 11/2/15.
//  Copyright © 2015 Kevin McGladdery. All rights reserved.
//

import Foundation
import CoreLocation

struct QuakeList {
  let quakeViewModels: [QuakeViewModel]
  static let logConstant = log(10.0)
  
  init(quakes: [Quake], location:CLLocation, minNumber:Double) {
    let viewModels = quakes.map { QuakeViewModel(quake: $0) }
    self.quakeViewModels = QuakeList.quakesWithMMI(viewModels, mmiNumber:minNumber, location: location)
  }
  
  static func quakesWithMMI(viewModels:[QuakeViewModel], mmiNumber: Double, location: CLLocation) -> [QuakeViewModel] {
    return viewModels.filter { quakeModel in
      let distance = location.distanceFromLocation(quakeModel.location) / 1000.0
      let magnitude = quakeModel.quake.magnitude
      return mmiFormula(distance, magnitude: magnitude) > mmiNumber
    }
  }
  
  static func mmiFormula(distance: Double, magnitude: Double) -> Double {
    
    func first() -> Double {
      return 1.15 + (1.01 * magnitude)
    }
    func second() -> Double {
      return 0.00054 * distance
    }
    func third() -> Double {
      return 1.72 * log(distance) / QuakeList.logConstant
    }
    
     return first() - second() - third()
    }
  }
