//
//  ViewController.swift
//  MattKusak-VishalPuppala-MicahRounds-Final-Project
//
//  Created by Micah Rounds on 7/20/20.
//  Copyright © 2020 Micah Rounds. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, MKMapViewDelegate,UIGestureRecognizerDelegate {

    @IBOutlet weak var optionSwitch: UISwitch!
    @IBOutlet weak var myMap: MKMapView!
    var points:[LocationPoint] = []
    var currCoord:CLLocationCoordinate2D = CLLocationCoordinate2D()
    var currPoint = LocationPoint(title: "", locationName: "", coordinate: CLLocationCoordinate2D(), date: Date(), subtitle: "",opt: "")
    var selctedPoint = LocationPoint(title: "", locationName: "", coordinate: CLLocationCoordinate2D(), date: Date(), subtitle: "",opt: "")
    var currColor:UIColor = .green
    var option:String = "free"
    override func viewDidLoad() {
        super.viewDidLoad()
         var mapRegion:MKCoordinateRegion = MKCoordinateRegion()
         let coordinate: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude:38.6421713 , longitude: -90.3071533)
        mapRegion.center = coordinate
        mapRegion.span.latitudeDelta = 0.025
        mapRegion.span.longitudeDelta = 0.025
        myMap.delegate = self
        myMap.setRegion(mapRegion, animated: true)
        let gRecognizer = UITapGestureRecognizer(target: self, action:#selector(self.handleTap))
        gRecognizer.delegate = self
        myMap.addGestureRecognizer(gRecognizer)
        // Do any additional setup after loading the view.
    }
    @IBAction func switchFoodOption(_ sender: Any) {
        if optionSwitch.isOn
        {
            option = "rare"
            // change to rare food option
        }
        else
        {
            option = "free"
            //change to free food option
        }
    }
    @IBAction func addLocation(_ sender: Any) {
    }
    /*
     right now handleTap just adds a marker at the tapped location with the placeholder data
     */
    @objc func handleTap(gestureRecognizer: UITapGestureRecognizer) {
        //print("tap")
        let location = gestureRecognizer.location(in: myMap)
        //converts to coordinate
       currCoord = myMap.convert(location, toCoordinateFrom: myMap)
        performSegue(withIdentifier: "gotoform", sender: (Any).self)
        //adds location object as annotation
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "gotoform"
        {
            let form = segue.destination as? FormViewController
            form?.coord = currCoord
            form?.fOpt = option
        }
        else if segue.identifier == "gotodetail"
        {
            let detail = segue.destination as? EventDetailView
            detail?.detailLoc = selctedPoint
        }
        
        
    }
   override func viewWillAppear(_ animated: Bool) {
        for point in points
        {
            option = point.opt
            myMap.addAnnotation(point)
        }
    }
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKMarkerAnnotationView
        if pinView == nil {
            pinView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.rightCalloutAccessoryView = UIButton(type: .infoDark)
            if option == "free"
            {
                pinView!.markerTintColor = .green
            }
            else if option == "rare"
            {
                pinView!.markerTintColor = .purple
            }
            else
            {
                pinView!.markerTintColor = .black
            }
           
            
            
        }
        else {
            pinView!.annotation = annotation
        }
        return pinView
    }

    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        print("tapped on pin ")
    }

    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
           // if let doSomething = view.annotation?.title! {
                let ann = view.annotation as? LocationPoint
                let t = ann?.title
                let l = ann?.locationName
                let c = ann?.coordinate
                let d = ann?.date
                let s = ann?.subtitle
                let o = ann?.opt
                selctedPoint = LocationPoint(title: t!, locationName: l!, coordinate: c!, date: d!, subtitle: s!,opt: o!)
                performSegue(withIdentifier: "gotodetail", sender: Any.self)
               print("do something")
            //}
        }
      }
    

}

