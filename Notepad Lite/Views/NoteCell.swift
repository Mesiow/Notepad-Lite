//
//  NoteCell.swift
//  Notepad Lite
//
//  Created by Mesiow on 2/25/23.
//

import Foundation
import UIKit
import SwipeCellKit

class NoteCell: SwipeTableViewCell {

    @IBOutlet weak var subLabel: UILabel!
    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        //self.layer.borderColor = UIColor.systemTeal.cgColor;
        //self.layer.cornerRadius = 8;
        //self.layer.borderWidth = 0.4;
        //self.frame = CGRectOffset(self.frame, 10, 10);
        self.accessoryType = .disclosureIndicator;
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
