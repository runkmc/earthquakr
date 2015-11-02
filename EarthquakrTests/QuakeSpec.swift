//
//  QuakeSpec.swift
//  Earthquakr
//
//  Created by Kevin McGladdery on 11/1/15.
//  Copyright © 2015 Kevin McGladdery. All rights reserved.
//

import Foundation
import Quick
import Nimble
@testable import Earthquakr

class QuakeSpec: QuickSpec {
  override func spec() {
    describe("the essence of a quake") {
      let magnitude = 2.5
      let locationString = "4km ESE of San Ramon, California"
      let rawTime = 1388620296020
      let url = "http://hey.there.bozo"
      let coordinates = [-116.7776667,33.6633333,12.39]
      let quake = Quake(magnitude: magnitude, locationString: locationString,
        rawTime: rawTime, url: url, coordinates: coordinates)
      
      it("has a magnitude") {
        expect(quake.magnitude) == 2.5
      }
      
      it("has a location string") {
        expect(quake.locationString) == locationString
      }
      
      it("has a raw time value") {
        expect(quake.rawTime) == rawTime
      }
      
      it("has a url in the form of a string") {
        expect(quake.url) == url
      }
      
      it("has coordinates") {
        expect(quake.coordinates) == coordinates
      }
    }
  }
}