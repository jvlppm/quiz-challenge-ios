//
//  ResponseTableViewCell.swift
//  Quiz Challenge
//
//  Created by Joao Vitor P. on 2/15/20.
//  Copyright © 2020 ArcTouch. All rights reserved.
//

import Foundation
import UIKit

class ResponseTableViewCell : UITableViewCell {
    @IBOutlet weak var responseLabel: UILabel!

    func configure(answer: String) {
        responseLabel.text = answer
    }
}
