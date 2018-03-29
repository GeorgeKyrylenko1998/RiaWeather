//
//  AddCityController.swift
//  RiaWeather
//
//  Created by George Kyrylenko on 28.03.2018.
//  Copyright © 2018 George Kyrylenko. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class AddCityController: UIViewController, MKMapViewDelegate {

    var manageObjectContext: NSManagedObjectContext!
    
    @IBOutlet weak var mapSelectCity: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()

        
        manageObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func selectOnMap(_ sender: UITapGestureRecognizer) {
        let touchPoint = sender.location(in: mapSelectCity)
        let newCoordinates = mapSelectCity.convert(touchPoint, toCoordinateFrom: mapSelectCity)
        let annotation = MKPointAnnotation()
        let location = CLLocation(latitude: newCoordinates.latitude, longitude: newCoordinates.longitude)
        let getCoder = CLGeocoder()
        
        getCoder.reverseGeocodeLocation(location) { (placemarks, error) in
            let placeMark = placemarks?[0]
            print(placeMark?.addressDictionary!["City"] as? NSString)
            let city = City(context: self.manageObjectContext)
            city.city = placeMark?.addressDictionary!["City"] as? String
            city.latitude = newCoordinates.latitude
            city.longitude = newCoordinates.longitude
            
            try? self.manageObjectContext.save()
        }
        annotation.coordinate = newCoordinates
        mapSelectCity.addAnnotation(annotation)
    }
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
