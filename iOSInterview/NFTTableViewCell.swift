//
//  NFTTableViewCell.swift
//  iOSInterview
//
//  Created by Ariel on 11/05/2023.
//

import UIKit

class NFTTableViewCell: UITableViewCell {

    @IBOutlet weak var rank: UILabel!
    
    @IBOutlet weak var nftImage: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var floorPriceChange: UILabel!
    @IBOutlet weak var floorPrice: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
