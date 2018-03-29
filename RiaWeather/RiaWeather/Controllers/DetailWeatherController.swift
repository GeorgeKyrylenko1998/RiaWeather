//
//  DetailWeatherController.swift
//  RiaWeather
//
//  Created by George Kyrylenko on 29.03.2018.
//  Copyright © 2018 George Kyrylenko. All rights reserved.
//

import UIKit
import SwiftSky

class DetailWeatherController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var countDays: UIPageControl!
    @IBOutlet weak var lvlTemperature: UILabel!
    @IBOutlet weak var lblHumidity: UILabel!
    @IBOutlet weak var lblSpeed: UILabel!
    
    @IBOutlet weak var scrolDays: UIScrollView!
    
    @IBOutlet weak var lblInfo: UILabel!
    var city: City?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = city?.city
        
        
        // Do any additional setup after loading the view.
    }

    
    override func viewDidAppear(_ animated: Bool) {
        loadWeather()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func loadWeather(){
        SwiftSky.get([.current,.minutes,.days,.hours], at: Location(latitude: (city?.latitude)!, longitude: (city?.longitude)!)) { (result) in
            switch result {
            case .success( _):
                self.lvlTemperature.text = result.response?.current?.temperature?.current?.label
                self.lblHumidity.text = result.response?.current?.humidity?.label
                self.lblSpeed.text = result.response?.current?.wind?.speed?.label
                
                self.lblInfo.text = result.response?.days?.summary
                
                self.countDays.numberOfPages = (result.response?.days?.points.count)!
                
                var count = 0
                
                for day in (result.response?.days?.points)!{
                    let view = UIView(frame: self.scrolDays.frame)
                    
                    self.scrolDays.addSubview(view)
                    
                    let lblDate = UILabel()
                    
                    let dateFormaterLable = DateFormatter()
                    dateFormaterLable.dateFormat = "dd.MM.yyyy"
                    
                    lblDate.text = dateFormaterLable.string(from: day.time)
                    
                    view.addSubview(lblDate)
                    
                    lblDate.center.x = view.center.x
                    lblDate.frame.origin.y = 20
                    
                    lblDate.sizeToFit()
                    lblDate.textColor = .black
                    
                    
                    let lblTemperature = UILabel()
                    lblTemperature.text = "Температура: от \(day.temperature?.min?.label ?? "None info") до \(day.temperature?.max?.label ?? "None info")"
                    lblTemperature.sizeToFit()
                    
                    view.addSubview(lblTemperature)
                    
                    lblTemperature.frame.origin.x = 20
                    lblTemperature.frame.origin.y = 40
                    
                    let lblHumidity = UILabel()
                    lblHumidity.text = "Влажность: \(day.humidity?.label ?? "None info")"
                    lblHumidity.sizeToFit()
                    
                    view.addSubview(lblHumidity)
                    
                    lblHumidity.frame.origin.x = 20
                    lblHumidity.frame.origin.y = 60
                    
                    let lblSpeed = UILabel()
                    lblSpeed.text = "Скорость ветра: \(day.wind?.speed?.label ?? "None info")"
                    lblSpeed.sizeToFit()
                    
                    view.addSubview(lblSpeed)
                    
                    lblSpeed.frame.origin.x = 20
                    lblSpeed.frame.origin.y = 80
                    
                    view.frame.origin.y = 0
                    view.frame.origin.x = self.scrolDays.frame.size.width * CGFloat(count)
                    
                    count += 1
                    
                    self.scrolDays.contentSize.width += view.frame.size.width
                }
            case .failure(let error):
                print(error)
                // do something with error
            }
        }
        
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        countDays.currentPage = Int((scrollView.contentOffset.x + scrollView.frame.size.width/2)/scrollView.frame.size.width) 
    }
}
