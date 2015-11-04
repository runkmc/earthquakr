//
//  QuakeViewModelSpec.swift
//  Earthquakr
//
//  Created by Kevin McGladdery on 11/3/15.
//  Copyright © 2015 Kevin McGladdery. All rights reserved.
//

import Foundation
import Quick
import Nimble
@testable import Earthquakr

class QuakeViewModelSpec: QuickSpec {
  override func spec() {
    describe("QuakeViewModel") {
      let quake = Quake(magnitude: 1.29, locationString: "10km SSW of Pine Cove, California", rawTime: 1388620296020, url:"http://earthquake.usgs.gov/earthquakes/eventpage/ci11408890", coordinates: [-116.7776667,33.6633333,12.39])
      let quakemodel = QuakeViewModel(quake: quake)
      
      it("returns the magnitude to one decimal place") {
        expect(quakemodel.magnitudeString) == "1.3"
      }
      
      it("returns the location String") {
        expect(quakemodel.locationString) == quake.locationString
      }
    }
  }
}
