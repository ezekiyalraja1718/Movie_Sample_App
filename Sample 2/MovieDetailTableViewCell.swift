//
//  MovieDetailTableViewCell.swift
//  Sample 2
//
//  Created by TechUnity IOS Developer on 20/08/22.
//

import UIKit

class MovieDetailTableViewCell: UITableViewCell {
    @IBOutlet weak var MovieDetailBackgroundView: UIView!
    @IBOutlet weak var MovieTitle: UILabel!
    @IBOutlet weak var RatingLable: UILabel!
    @IBOutlet weak var MovieImageview: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
