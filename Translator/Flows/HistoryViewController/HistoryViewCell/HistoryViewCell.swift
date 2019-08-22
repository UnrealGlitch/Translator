//
//  HistoryViewCell.swift
//  Translator
//
//  Created by MadBrain on 21/08/2019.
//  Copyright © 2019 Andrey. All rights reserved.
//

import UIKit

class HistoryViewCell: UITableViewCell {

    // MARK: Variables
    
    @IBOutlet private weak var timeLabel: UILabel!
    @IBOutlet private weak var translatedTextLabel: UILabel!
    @IBOutlet private weak var originalTextLabel: UILabel!
    
    var viewModel: HistoryViewCellModel? {
        didSet {
            guard let viewModel = viewModel else {
                return
            }
            
            timeLabel.text = viewModel.time
            translatedTextLabel.text = viewModel.translatedText
            originalTextLabel.text = viewModel.text
        }
    }
    
}
