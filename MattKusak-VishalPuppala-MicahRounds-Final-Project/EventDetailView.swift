//
//  EventDetailView.swift
//  MattKusak-VishalPuppala-MicahRounds-Final-Project
//
//  Created by Micah Rounds on 7/21/20.
//  Copyright © 2020 Micah Rounds. All rights reserved.
//

import UIKit
import MapKit
extension UIViewController{
    func pushKeyboard(){
        let touchObject: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(keyboardRetreat) )
        view.addGestureRecognizer(touchObject)
        
      
        
    }
    @objc func keyboardRetreat(){
                 view.endEditing(true)
              }
}
class EventDetailView: UIViewController {
    var detailLoc: LocationPoint = LocationPoint(title: "", locationName: "", coordinate: CLLocationCoordinate2D(), date: Date(), subtitle: "",opt: "", path: "")
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var locLabel: UILabel!
    @IBOutlet weak var endDateLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var foodImage: UIImageView!
  
 
    override func viewDidLoad() {
        super.viewDidLoad()
        self.pushKeyboard()
        //I used this article for the DatFormatter()
        //https://stackoverflow.com/questions/35700281/date-format-in-swift
        let df = DateFormatter()
        df.dateFormat = "E d MMM y, h:mm a"
        titleLabel.text = detailLoc.title
        locLabel.text = detailLoc.locationName
        endDateLabel.text = "Lasts Until: "+df.string(from: detailLoc.date)
        descriptionLabel.text = detailLoc.subtitle
        if let url = URL(string: detailLoc.path)
        {
            if let imageData = try? Data(contentsOf: url)
            {
                foodImage.image = UIImage(data: imageData)
            }
        }
        

      
        
        
        // Do any additional setup after loading the view.
    }
  
    //https://www.youtube.com/watch?v=YA20F7RJnwA was consulted for viewDidLayoutSubviews() function
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let scroll = UIScrollView(frame: view.bounds)
        view.addSubview(scroll)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
