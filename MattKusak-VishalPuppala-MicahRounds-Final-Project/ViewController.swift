//
//  ViewController.swift
//  MattKusak-VishalPuppala-MicahRounds-Final-Project
//
//  Created by Micah Rounds on 7/20/20.
//  Copyright © 2020 Micah Rounds. All rights reserved.
//

import UIKit
import MapKit
import FirebaseDatabase
import CoreLocation
class ViewController: UIViewController, MKMapViewDelegate,UIGestureRecognizerDelegate,CLLocationManagerDelegate {

    //"tutorial" label
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var optionSwitch: UISwitch!
    @IBOutlet weak var myMap: MKMapView!
    
    @IBOutlet weak var addButton: UIBarButtonItem!
    
    //state to determine if user has launched app before
    var isLaunched:Bool = false
    //object for detecting location
    let locationManager = CLLocationManager()
    //points array was used  as placeholder prior to integrating the database, this is not implemented anymore
    var points:[LocationPoint] = []
    //holds coordinates of current location
    var currCoord:CLLocationCoordinate2D = CLLocationCoordinate2D()
    //object to hold new location object when being created
    var currPoint = LocationPoint(title: "", locationName: "", coordinate: CLLocationCoordinate2D(), date: Date(), subtitle: "",opt: "", path: "", id: "",score: 0)
    //object to hold new location object that is to be viewed
    var selctedPoint = LocationPoint(title: "", locationName: "", coordinate: CLLocationCoordinate2D(), date: Date(), subtitle: "",opt: "", path: "",id: "",score: 0)
    var currColor:UIColor = .green
    //this is changed when the switch is moved
    var option:String = "free"
    var currID:String = ""
    var currScore:Int = 0
    //this helps the menus for adding locations
    var adding:Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        //code to request location
         var mapRegion:MKCoordinateRegion = MKCoordinateRegion()
        //region for map to zoom to centered at coordinate ranging within span property
         let coordinate: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude:38.6421713 , longitude: -90.3071533)
        mapRegion.center = coordinate
        mapRegion.span.latitudeDelta = 0.025
        mapRegion.span.longitudeDelta = 0.025
        //uncomment for debugging
        //UserDefaults.standard.set(false, forKey: "launchedBefore")
        isLaunched = UserDefaults.standard.bool(forKey: "launchedBefore")
        if isLaunched == false
        {
            infoLabel.text = "Tap '+' to manually add a location, or tap the pin icon to use your current location..."
            UserDefaults.standard.set(true, forKey: "launchedBefore")
        }
        else{
            infoLabel.isHidden = true
        }
        
        
        myMap.delegate = self
        //sets map starting coordinates to region mentioned above
        myMap.setRegion(mapRegion, animated: true)
        //starts reading in current location
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
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
    //enables tap handler for manually entered locations
    @IBAction func addLocation(_ sender: Any) {
        
        
        if adding == false {
        let alertController = UIAlertController(title: "Add a food event?", message: "Tap 'Add' then tap on the map to place your pin!", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Add", style: .default, handler: {(alert: UIAlertAction!) in self.adding = true; self.addButton.image = UIImage(systemName: "xmark"); self.addButton.tintColor = .systemRed
                
}))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .destructive))
        self.present(alertController, animated: true, completion: nil)
        
        //set gesture recognizer associated with function handleTap
        let gRecognizer = UITapGestureRecognizer(target: self, action:#selector(self.handleTap))
        gRecognizer.delegate = self
        //apply gesture recognizer to mapView
        myMap.addGestureRecognizer(gRecognizer)
        if isLaunched == false
        {
            infoLabel.text = "Tap on the part of the map where the event is located..."
        }
        } else {
            adding = false
            addButton.image = UIImage(systemName: "plus")
            addButton.tintColor = .systemBlue
        }
        
    }
    @IBAction func userLocation(_ sender: Any) {
        infoLabel.isHidden = true
        
        let alertController = UIAlertController(title: "Add a food event from location?", message: "Uses your phone's current location for the pin!", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Add", style: .default, handler: {(alert: UIAlertAction!) in
            let latNorthLimit = 38.6761765
            let longEastLimit = -90.1573885
            let latSouthLimit = 38.5617648
            let longWestLimit = -90.3955759
            if self.currCoord.latitude >= latSouthLimit && self.currCoord.latitude <= latNorthLimit && self.currCoord.longitude >= longWestLimit && self.currCoord.longitude <= longEastLimit
                {
                    self.performSegue(withIdentifier: "gotoform", sender: (Any).self)
                }
                else
                {
                    let aL = UIAlertController(title: "Cannot add location", message: "This location is not close enough to campus" , preferredStyle: .alert)
                    aL.addAction(UIAlertAction(title: "Ok", style: .cancel))
                    self.present(aL,animated: true,completion: nil)
                }
            }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .destructive))
        self.present(alertController, animated: true, completion: nil)
        
        //switch to form viewcontroller
        //performSegue(withIdentifier: "gotoform", sender: (Any).self)
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last
        
        //update class location varible
        currCoord = location!.coordinate
    }
    /*
     takes user to form and holds on to coordinates associated with tap location on map
     */
    @objc func handleTap(gestureRecognizer: UITapGestureRecognizer) {
        if adding == true {
            adding = false
        infoLabel.isHidden = true
        //stop updating location to prevent currCoord from being set again
        locationManager.stopUpdatingLocation()
        //get raw location data
        let location = gestureRecognizer.location(in: myMap)
        //converts to coordinate
       currCoord = myMap.convert(location, toCoordinateFrom: myMap)
        let latNorthLimit = 38.6761765
        let longEastLimit = -90.1573885
        let latSouthLimit = 38.5617648
        let longWestLimit = -90.3955759
            if currCoord.latitude >= latSouthLimit && currCoord.latitude <= latNorthLimit && currCoord.longitude >= longWestLimit && currCoord.longitude <= longEastLimit
            {
                addButton.image = UIImage(systemName: "plus")
                addButton.tintColor = .systemBlue
                performSegue(withIdentifier: "gotoform", sender: (Any).self)
            }
            else
            {
                let aL = UIAlertController(title: "Cannot add location", message: "This location is not close enough to campus" , preferredStyle: .alert)
                aL.addAction(UIAlertAction(title: "Ok", style: .cancel))
                self.present(aL,animated: true,completion: nil)
                print(currCoord)
                
                adding = true
            }
        
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //we need to set the coordinate and option(free or rare) in FormViewController
        if segue.identifier == "gotoform"
        {
            let form = segue.destination as? FormViewController
            form?.coord = currCoord
            form?.fOpt = option
        }
        //I'm actually not sure if this is needed since the entire object is stored in the db alrady
        else if segue.identifier == "gotodetail"
        {
            let detail = segue.destination as? EventDetailView
            detail?.detailLoc = selctedPoint
        }
        
        
    }
    //this post helped show how to format date objects into a string
    //https://stackoverflow.com/questions/35700281/date-format-in-swift
    static func formatDate(s: String) ->Date?
    {
        
       let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ssZ"
        let date = dateFormatter.date(from:s)
        return date
    }
    /*rather than use viewdidLoad, this function updates when the view first loads and also when there is a segue to the view
     (i.e. when the user finishes filling out the form)
 */
   override func viewWillAppear(_ animated: Bool) {
    let db = Database.database().reference()
    db.child("locationPoints").observeSingleEvent(of: .value)
        {(snapshot) in
            //here we have an array of dictionaries, where each dict holds a value for each property of a location object
            if let dbpoints = snapshot.value as? [String:[String:Any]]
            {
                //each p is a dictionary (represents location/annotation object)
                for p in dbpoints
                {
                    //parse out information into appropriate type
                    let dict = p.value
                    let newTitle = dict["title"] as! String
                    let newLocation = dict["locationName"] as! String
                    let newLat = dict["lat"] as! Double
                    let newLong = dict["long"] as! Double
                    let newCoord = CLLocationCoordinate2D(latitude: newLat , longitude: newLong)
                    let newDate = dict["date"] as! String
                    let newDateObj = ViewController.formatDate(s: newDate)!
                    let newSubtitle = dict["desc"] as! String
                    let newOpt = dict["opt"] as! String
                    let newPath = dict["path"] as! String
                    let newID = dict["id"] as! String
                    let newScore = dict["score"] as! Int
                    //create annotation object from extracted database values
                    let newLocationPoint = LocationPoint(title: newTitle, locationName: newLocation, coordinate:newCoord , date: newDateObj, subtitle: newSubtitle, opt: newOpt, path: newPath,id: newID,score: newScore)
                    let now = Date()
                    //only load events that haven't ended
                    if now.compare(newDateObj).rawValue == -1
                    {
                        self.myMap.addAnnotation(newLocationPoint)
                    }
                    
                }
            }
        }

    }
    //this article was useful for showing how to add an info button to the marker
    //https://www.hackingwithswift.com/example-code/location/how-to-add-a-button-to-an-mkmapview-annotation
    //This article explains the MKMarkerAnnotationView, which works similarly to using pins but looks a little nicer IMO
    //https://makeapppie.com/2018/02/20/use-markers-instead-of-pins-for-map-annotations/
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        var marker = mapView.dequeueReusableAnnotationView(withIdentifier: "marker") as? MKMarkerAnnotationView
        if marker == nil {
            marker = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: "marker")
            marker!.canShowCallout = true
            //creates the info button in the small description
            marker!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            let lp = annotation as? LocationPoint
            //format color (I didn't end up needing currColor)
            if lp!.opt == "free"
            {
                marker!.markerTintColor = .green
            }
            else if lp!.opt == "rare"
            {
                marker!.markerTintColor = .purple
            }
            else
            {
                //THIS SHOULD NOT HAPPEN
                marker!.markerTintColor = .black
            }
        }
        else {
            marker!.annotation = annotation
        }
        return marker
    }

    /*func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
    }*/

    //called when info button is clicked
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            //create location object from clicked annoation object and update selectedPoint object
                let ann = view.annotation as? LocationPoint
                let t = ann?.title
                let l = ann?.locationName
                let c = ann?.coordinate
                let d = ann?.date
                let s = ann?.subtitle
                let o = ann?.opt
                let p = ann?.path
                let i = ann?.id
                let sc = ann?.score
                selctedPoint = LocationPoint(title: t!, locationName: l!, coordinate: c!, date: d!, subtitle: s!,opt: o!,path: p!,id:i!,score: sc!)
                performSegue(withIdentifier: "gotodetail", sender: Any.self)
               
        }
      }
}

