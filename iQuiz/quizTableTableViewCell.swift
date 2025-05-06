//
//  quizTableTableViewCell.swift
//  iQuiz
//
//  Created by Anthony  Wen on 5/5/25.
//

import UIKit

class quizTableTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var image1: UIImageView!
    
    
    @IBOutlet weak var title1: UILabel!
    
    
    @IBOutlet weak var description1: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    

}
