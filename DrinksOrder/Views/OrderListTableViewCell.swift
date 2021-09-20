//
//  OrderListTableViewCell.swift
//  DrinksOrder
//
//  Created by Machir on 2021/9/12.
//

import UIKit

class OrderListTableViewCell: UITableViewCell {

    @IBOutlet weak var drinkImageView: UIImageView!
    @IBOutlet weak var orderNameLabel: UILabel!
    @IBOutlet weak var drinkNameLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var sweetnessLabel: UILabel!
    @IBOutlet weak var toppingsLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var drinkPriceLabel: UILabel!
    
    @IBOutlet weak var id: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
