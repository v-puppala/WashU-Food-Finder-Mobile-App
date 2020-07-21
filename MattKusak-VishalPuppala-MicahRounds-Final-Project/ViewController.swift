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
    var currCoord:CLLocationCoordinate2D = CLLocationCoordinate2D()
    var currColor:UIColor = .green
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
            currColor = .purple
            // change to rare food option
        }
        else
        {
            currColor = .green
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
        //performSegue(withIdentifier: "gotoform", sender: (Any).self)
        let annotation = LocationPoint(title: "food", locationName: "duc", coordinate: currCoord, date: "07-20-20", subtitle: "taco")
        //adds location object as annotation
        myMap.addAnnotation(annotation)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let form = segue.destination as? FormViewController
        form?.coord = currCoord
        
        
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        //guard annotation is MKAnnotation else { print("no mkpointannotaions"); return nil }
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKMarkerAnnotationView
        if pinView == nil {
            pinView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.rightCalloutAccessoryView = UIButton(type: .infoDark)
            pinView!.markerTintColor = currColor
            
            
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
            if let doSomething = view.annotation?.title! {
               print("do something")
            }
        }
      }
    

}

