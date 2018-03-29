//
//  CityCell.swift
//  RiaWeather
//
//  Created by George Kyrylenko on 29.03.2018.
//  Copyright © 2018 George Kyrylenko. All rights reserved.
//

import UIKit

class CityCell: UITableViewCell {

    @IBOutlet weak var imgBack: UIImageView!
    @IBOutlet weak var lblCity: UILabel!
    @IBOutlet weak var lblTemperature: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
