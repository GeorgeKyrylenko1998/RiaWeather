//
//  WeathersController.swift
//  RiaWeather
//
//  Created by George Kyrylenko on 29.03.2018.
//  Copyright © 2018 George Kyrylenko. All rights reserved.
//

import UIKit
import CoreData
import SwiftSky

class WeathersController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var cityTable: UITableView!
    
    var weathers = [City]()
    var manageObjectContext: NSManagedObjectContext!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        manageObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        SwiftSky.secret = "776f57db3300e9eadd49e59653e04961"
        
        SwiftSky.language = .russian
        SwiftSky.units.temperature = .celsius
        loadData()
        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
        loadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func loadData(){
        let fetchRequest: NSFetchRequest<City> = City.fetchRequest()
        weathers = try! manageObjectContext.fetch(fetchRequest)
        if weathers.count == 0{
            let vin = City(context: manageObjectContext)
            vin.latitude = 49.229102034070621
            vin.longitude = 28.485089726021201
            vin.city = "Винница"
            try? manageObjectContext.save()
            
            let kiev = City(context: manageObjectContext)
            kiev.latitude = 50.440928624616475
            kiev.longitude = 30.529157940881337
            kiev.city = "Киев"
            try? manageObjectContext.save()
        }
        self.cityTable.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weathers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = cityTable.dequeueReusableCell(withIdentifier: "cityCell", for: indexPath) as! CityCell
        cell.lblCity.text = weathers[indexPath.row].city
        
        SwiftSky.get([.current,.minutes,.days,.hours], at: Location(latitude: weathers[indexPath.row].latitude, longitude: weathers[indexPath.row].longitude)) { (result) in
            switch result {
            case .success( _):
                cell.lblTemperature.text = result.response?.current?.temperature?.current?.label
                if result.response?.current?.precipitation?.type?.rawValue != nil{
                    cell.imgBack.image = UIImage(named: (result.response?.current?.precipitation?.type?.rawValue)!)
                } else {
                    cell.imgBack.image = #imageLiteral(resourceName: "goodWeather")
                }
            case .failure(let error):
                print(error)
                // do something with error
            }
        }
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            self.manageObjectContext.delete(self.weathers[indexPath.row])
            self.loadData()
        }
        return [delete]
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "DetailWeather") as! DetailWeatherController
        vc.city = weathers[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
