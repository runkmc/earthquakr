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
  
  init(quakes: [Quake]) {
    self.quakeViewModels = quakes.map { QuakeViewModel(quake: $0) }
  }
  
  func quakesWithMMI(mmiNumber: Double, location: CLLocation) -> [QuakeViewModel] {
    return self.quakeViewModels.filter { quakeModel in
      let distance = Int(location.distanceFromLocation(quakeModel.location)) / 1000
      let magnitude = quakeModel.quake.magnitude
      if mmiFormula(distance, magnitude: magnitude) > 2.3 {
        return true
      } else {
        return false
      }
    }
  }
  
  func mmiFormula(distance: Int, magnitude: Double) -> Double {
    
    func first() -> Double {
      return 1.15 + (1.01 * magnitude)
    }
    func second() -> Double {
      return 0.00054 * Double(distance)
    }
    func third() -> Double {
      return 1.72 * log(Double(distance)) / QuakeList.logConstant
    }
    
     return first() - second() - third()
    }
  }
