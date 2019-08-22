//
//  HistoryViewCellModel.swift
//  Translator
//
//  Created by MadBrain on 21/08/2019.
//  Copyright © 2019 Andrey. All rights reserved.
//

final class HistoryViewCellModel {
    
    // MARK: Variables
    
    let text: String
    let translatedText: String
    let time: String
    
    // MARK: Life cycle
    
    init(text: String, translatedText: String, time: String) {
        self.text = text
        self.translatedText = translatedText
        self.time = time
    }
    
}
