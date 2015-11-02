//
//  QuakeList.swift
//  Earthquakr
//
//  Created by Kevin McGladdery on 11/1/15.
//  Copyright © 2015 Kevin McGladdery. All rights reserved.
//

import Foundation
import Curry
import Argo
import Runes

struct QuakeList {
  let quakes : [Quake]
}

extension QuakeList: Decodable {
  static func decode(json: JSON) -> Decoded<QuakeList.DecodedType> {
    let q = curry(self.init)
    return q
      <^> json <|| "features"
  }
}
