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
  let time: String
//  let url: NSURL
//  let location: CLLocation
  var locationString: String {
    return self.quake.locationString
  }
  
  init(quake:Quake) {
    self.quake = quake
    self.magnitudeString = String(format: "%.1f", quake.magnitude)
    self.time = QuakeViewModel.formatTime(quake.rawTime)
  }
  
  static private func formatTime(time:Int) -> String {
    let formatter = NSDateFormatter()
    formatter.dateFormat = "h:mm a"
    
    let newTime = time / 1000
    let date = NSDate(timeIntervalSince1970: Double(newTime))
    
    return formatter.stringFromDate(date)
  }
}