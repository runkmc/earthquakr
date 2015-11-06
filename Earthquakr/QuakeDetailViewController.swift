//
//  QuakeDetailViewController.swift
//  Earthquakr
//
//  Created by Kevin McGladdery on 11/4/15.
//  Copyright © 2015 Kevin McGladdery. All rights reserved.
//

import UIKit
import MapKit

class QuakeDetailViewController: UIViewController {
  
  @IBOutlet weak var magnitudeLabel: UILabel!
  @IBOutlet weak var distanceLabel: UILabel!
  @IBOutlet weak var placeLabel: UILabel!
  @IBOutlet weak var map: MKMapView!
  var quake: QuakeViewModel?
  var currentLocation: CLLocation?
  
  @objc class QuakeAnnotation: NSObject, MKAnnotation {
    let coordinate: CLLocationCoordinate2D
    let title: String?
    
    init(coordinate: CLLocationCoordinate2D, title: String) {
      self.coordinate = coordinate
      self.title = title
    }
  }
    override func viewDidLoad() {
        super.viewDidLoad()
      guard let q = quake else {
        return
      }
      placeLabel.text = q.locationString
      magnitudeLabel.text = q.magnitudeString
      distanceLabel.text = "\(Int((currentLocation?.distanceFromLocation(q.location))! / 1000.0))km from the epicenter"
      adjustMap()
    }

  func adjustMap() {
    let region = MKCoordinateRegionMakeWithDistance(quake!.location.coordinate, 2500, 2500)
    map.setRegion(region, animated:true)
    map.addAnnotation(QuakeAnnotation(coordinate: quake!.location.coordinate, title: quake!.locationString))
  }
  
  @IBAction func didTapDetailButton(sender: AnyObject) {
    UIApplication.sharedApplication().openURL(quake!.url)
  }
  
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
