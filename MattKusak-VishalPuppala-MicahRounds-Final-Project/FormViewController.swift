//
//  FormViewController.swift
//  MattKusak-VishalPuppala-MicahRounds-Final-Project
//
//  Created by Micah Rounds on 7/20/20.
//  Copyright © 2020 Micah Rounds. All rights reserved.
//

import UIKit
import MapKit
import FirebaseDatabase
import FirebaseStorage
class FormViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var formImage: UIImageView!
    @IBOutlet weak var eventTitle: UITextField!
    @IBOutlet weak var foodLoc: UITextField!
    @IBOutlet weak var endDate: UIDatePicker!
    //@IBOutlet weak var eventDescription: UITextField!
    @IBOutlet var eventDescription: UITextView!
    
    //imagepath holds on to url once image is uploaded (we'll need it for detailView)
    var imagePath:String = ""
    var coord:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    //holds string id for db object
    var objID:String = ""
    //this will either be free or rare
    var fOpt:String = ""
    //once the form is filled out, we will have all the info to make a locationPoint object to put into DB
    var formPoint:LocationPoint = LocationPoint(title: "", locationName: "", coordinate: CLLocationCoordinate2D(), date: Date(), subtitle: "",opt: "",path: "",id:"",score: 0)
    override func viewDidLoad() {
        super.viewDidLoad()
        let touchObject: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(keyboardRetreat) )
               view.addGestureRecognizer(touchObject)
        let borderColor : UIColor = UIColor(red: 0.85, green: 0.85, blue: 0.85, alpha: 1.0)
        eventDescription.layer.borderWidth = 0.75
        eventDescription.layer.borderColor = borderColor.cgColor
        eventDescription.layer.cornerRadius = 5.0
    }
    @objc func keyboardRetreat(){
       view.endEditing(true)
    }
    /*override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let scroll = UIScrollView(frame: view.bounds)
        view.addSubview(scroll)
    }*/
    //I'm reusing some imagePicker stuff from my lab3 - Micah
    @IBAction func addImage(_ sender: Any) {
        let img = UIImagePickerController()
        img.delegate = self
        img.sourceType = UIImagePickerController.SourceType.savedPhotosAlbum
        self.present(img, animated: true)
        
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        if let img = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        {
            formImage.image = img
            //I used code in this firebase article to upload image files
            //https://firebase.google.com/docs/storage/ios/upload-files
            //this video was very useful for showing how to convert an image into a data object,also shows how to make file names unique using uuidString
            //https://www.youtube.com/watch?v=b1vrjt7Nvb0&t=1524s
            let imgdata = formImage.image?.jpegData(compressionQuality: 0.8)
            let id = NSUUID().uuidString
            //add file suffix
            let storageRef = Storage.storage().reference().child(id+".jpg")
            let uploadTask = storageRef.putData(imgdata!, metadata: nil) { (metadata, error) in
              guard let metadata = metadata else {
                return
              }
              storageRef.downloadURL { (url, error) in
                guard let downloadURL = url else {
                  print("error getting downloadurl")
                  return
                }
                //set url for uploaded image
                self.imagePath = downloadURL.absoluteString
                print(self.imagePath)
              }
            }
            
        }
        
        self.dismiss(animated: true)
    }
    @IBAction func addLocation(_ sender: Any) {
        //validating input
        if eventTitle.text != nil && foodLoc.text != nil && eventDescription.text != nil
        {
           let now = Date()
           let result = now.compare(endDate.date)
            //verify input date hasn't passed
            if result.rawValue == -1
            {
                //print(endDate.date)
                //update object with form data included
                let id = NSUUID().uuidString
                formPoint = LocationPoint(title: eventTitle.text!, locationName: foodLoc.text!, coordinate: coord, date: endDate.date, subtitle: eventDescription.text!,opt: fOpt,path: imagePath,id:id,score: 0)
            }
            else
            {
                
                let a = UIAlertController(title: "Cannot add event", message: "Please enter a date that has not passed yet.", preferredStyle: .alert)
                a.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
                NSLog("The \"OK\" alert occured.")
                }))
                self.present(a, animated: true, completion: nil)
            }
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let nvc = segue.destination as? UINavigationController
        //i couldn't get the nav bar to show up again after submitting an event without this line
        let vc = nvc?.topViewController as? ViewController
        let db = Database.database().reference()
        if formPoint.title != "" && formPoint.locationName != "" && formPoint.coordinate.latitude != 0 && formPoint.coordinate.longitude != 0
        {
            //I used functions child() and childByAutoId() from this firebase article, which also shoes how to add a dictionary to database
            //https://firebase.google.com/docs/database/ios/read-and-write
            //upload our current object to db as dictionary
            let theId = formPoint.id
            db.child("locationPoints").child(theId).setValue(["long": Double(formPoint.coordinate.longitude), "date": formPoint.date.description, "lat": Double(formPoint.coordinate.latitude), "desc": formPoint.subtitle, "opt": formPoint.opt, "title": formPoint.title, "locationName": formPoint.locationName, "path":formPoint.path, "id":formPoint.id, "score":formPoint.score])
        }
        else{
            //something to look for in console if something isnt working
            //if the user does not allow current location and tries to use current location feature, this will print
            //this should probably be fixed in the future.
            print("not enough data")
            if formPoint.coordinate.latitude == 0.0 && formPoint.coordinate.longitude == 0.0
            {
                let a = UIAlertController(title: "Cannot add event", message: "You must allow location permissions in your settings", preferredStyle: .alert)
                a.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
                NSLog("The \"OK\" alert occured.")
                }))
                self.present(a, animated: true, completion: nil)
            }
        }
       
        //vc?.currPoint = formPoint
        //vc?.points.append(formPoint)
    }
    

}
