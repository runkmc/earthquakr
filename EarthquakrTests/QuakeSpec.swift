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
      let quake = Quake(magnitude: magnitude)
      it("has a magnitude") {
        expect(quake.magnitude) == 2.5
      }
    }
  }
}