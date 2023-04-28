//
//  CountryCell.swift
//  SectionIndexing
//
//  Created by Prachit on 29/04/23.
//

import UIKit

class CountryCell: UITableViewCell {

    @IBOutlet weak var countryImage: UIImageView!
    @IBOutlet weak var name: UILabel!
    var country : Country? {
        didSet {
            countryImage.image = country?.image
            name.text = country?.name ?? ""
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
