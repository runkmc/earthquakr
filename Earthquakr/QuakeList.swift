//
//  QuakeList.swift
//  Earthquakr
//
//  Created by Kevin McGladdery on 11/2/15.
//  Copyright © 2015 Kevin McGladdery. All rights reserved.
//

import Foundation

struct QuakeList {
  let quakeViewModels: [QuakeViewModel]
  
  init(quakes: [Quake]) {
    self.quakeViewModels = quakes.map { QuakeViewModel(quake: $0) }
  }
}