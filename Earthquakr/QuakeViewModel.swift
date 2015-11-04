//
//  QuakeViewModel.swift
//  Earthquakr
//
//  Created by Kevin McGladdery on 11/3/15.
//  Copyright © 2015 Kevin McGladdery. All rights reserved.
//

import Foundation
import CoreLocation

struct QuakeViewModel {
  let quake: Quake
  let magnitudeString: String
//  let locationString: String
//  let time: String
//  let url: NSURL
//  let location: CLLocation
  
  init(quake:Quake) {
    self.quake = quake
    self.magnitudeString = String(format: "%.1f", quake.magnitude)
  }
}