//
//  QuakeCell.swift
//  Earthquakr
//
//  Created by Kevin McGladdery on 11/5/15.
//  Copyright © 2015 Kevin McGladdery. All rights reserved.
//

import UIKit

class QuakeCell: UITableViewCell {

  @IBOutlet weak var magnitudeLabel: UILabel!
  @IBOutlet weak var timeLabel: UILabel!
  @IBOutlet weak var placeLabel: UILabel!
  var quake: QuakeViewModel?
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }

  override func setSelected(selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)

    // Configure the view for the selected state
  }
}
