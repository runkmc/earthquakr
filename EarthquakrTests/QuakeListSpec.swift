//
//  QuakeListSpec.swift
//  Earthquakr
//
//  Created by Kevin McGladdery on 11/2/15.
//  Copyright © 2015 Kevin McGladdery. All rights reserved.
//

import Foundation
import Quick
import Nimble
import CoreLocation
@testable import Earthquakr

class QuakeListSpec : QuickSpec {
  override func spec() {
    
    let date1 = Int(xHoursAgo(1)(date: NSDate()).timeIntervalSince1970 * 1000)
    let quake1 = Quake(magnitude: 4.55, locationString: "0km ESE of Concord, California", rawTime:date1, url:"http://earthquake.usgs.gov/earthquakes/eventpage/ak10992884", coordinates:[-116.7776667,33.6633333,12.39])
    let date2 = Int(xHoursAgo(2)(date: NSDate()).timeIntervalSince1970 * 1000)
    let quake2 = Quake(magnitude: 2.55, locationString: "0km ESE of Concord, California", rawTime:date2, url:"http://earthquake.usgs.gov/earthquakes/eventpage/ak10992884", coordinates:[-121.958000,37.780000,12.39])
    let date3 = Int(xHoursAgo(3)(date: NSDate()).timeIntervalSince1970 * 1000)
    let quake3 = Quake(magnitude: 1.55, locationString: "0km ESE of Concord, California", rawTime:date3, url:"http://earthquake.usgs.gov/earthquakes/eventpage/ak10992884", coordinates:[-121,958000,37.780000,12.39])
    let date4 = Int(xHoursAgo(4)(date: NSDate()).timeIntervalSince1970 * 1000)
    let quake4 = Quake(magnitude: 8.55, locationString: "0km ESE of Concord, California", rawTime:date4, url:"http://earthquake.usgs.gov/earthquakes/eventpage/ak10992884", coordinates:[-121,958000,37.780000,12.39])
    let quakes = [quake1, quake2, quake3, quake4]
    
    it("takes an array of Quakes and provides an array of QuakeViewModels") {
      let list = QuakeList(quakes: quakes)
      expect(list.quakeViewModels[0].magnitudeString) == "4.5"
    }
  
    it("returns quakes over a given MMI number") {
      // see http://resilience.abag.ca.gov/shaking/mmi/ for the scale referenced here
      let list = QuakeList(quakes: quakes)
      let myLocation = CLLocation(latitude: 37.875920, longitude: -122.071068)
      expect(list.quakesWithMMI(2.3, location:myLocation).count) == 2
    }
    
  }
}