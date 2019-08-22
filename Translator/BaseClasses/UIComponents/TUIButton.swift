//
//  TUIButton.swift
//  Translator
//
//  Created by MadBrain on 22/08/2019.
//  Copyright © 2019 Andrey. All rights reserved.
//

import UIKit

final class TUIButton: UIButton {
    
    // MARK: Life cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        customInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Private
    
    private func customInit() {
        backgroundColor = .yellow
        borderColor = .black
        borderWidth = 1
        cornerRadius = 5
        setTitleColor(.black, for: .normal)
    }
    
}
