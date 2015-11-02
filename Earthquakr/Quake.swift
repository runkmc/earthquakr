//
//  Quake.swift
//  Earthquakr
//
//  Created by Kevin McGladdery on 11/1/15.
//  Copyright © 2015 Kevin McGladdery. All rights reserved.
//

import Foundation
import Argo
import Runes
import Curry

struct Quake {
  let locationString : String
  let magnitude : Double
  let coordinates : [Double]
  let time : String
  let link : String
}

extension Quake: Decodable {
  
  static func decode(json: JSON) -> Decoded<Quake> {
    let q = curry(self.init)
      return q
      <^> json <| ["properties", "place"]
      <*> json <| ["properties", "mag"]
      <*> json <|| ["geometry", "coordinates"]
      <*> json <| ["properties", "time"]
      <*> json <| ["properties", "url"]
  }
}