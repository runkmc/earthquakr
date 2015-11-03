//
//  QuakeRequestDateFormatterSpec.swift
//  Earthquakr
//
//  Created by Kevin McGladdery on 11/2/15.
//  Copyright © 2015 Kevin McGladdery. All rights reserved.
//

import Foundation
import Quick
import Nimble
@testable import Earthquakr

class DateFormatterSpec: QuickSpec {
  override func spec() {
    describe("the date formatter") {
      let date = NSDate(timeIntervalSince1970: 1388619956.0)
      
      it("formats dates according to ISO8601") {
        expect(quakeRequestDateFormatter(date)) == "2014-01-01T15:45:56-08:00"
      }
      
      it("subtracts 12 hours from an NSDate") {
        let lastTwelve = twelveHoursAgo(date: date)
        expect(quakeRequestDateFormatter(lastTwelve)) == "2014-01-01T03:45:56-08:00"
      }
    }
  }
}