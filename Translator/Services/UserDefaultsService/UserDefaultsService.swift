//
//  UserDefaultsService.swift
//  Translator
//
//  Created by MadBrain on 21/08/2019.
//  Copyright © 2019 Andrey. All rights reserved.
//

import Foundation.NSDate

struct HistoryTranslation: Codable {
    
    let time: String
    let text: String
    let translatedText: String
    
}

final class UserDefaultsService {
    
    // MARK: Variables
    
    static let instance = UserDefaultsService()
    
    private(set) var history: [HistoryTranslation] = []
    
    private let userDefaultsKey = "history"
    
    private var currentTime: String {
        let currentDateTime = Date()
        let formatter = DateFormatter()
        formatter.timeStyle = .medium
        formatter.dateStyle = .long
        
        return formatter.string(from: currentDateTime)
    }
    
    // MARK: Life cycle
    
    private init() {
        history = loadHistory()
    }
    
    // MARK: Public
    
    public func addTranslationToHistory(text: String, translatedText: String) {
        let savingData = HistoryTranslation(time: currentTime, text: text, translatedText: translatedText)
        history.append(savingData)
        
        UserDefaults.standard.set(try? PropertyListEncoder().encode(history), forKey: userDefaultsKey)
    }
    
    // MARK: Private
    
    private func loadHistory() -> [HistoryTranslation] {
        guard let data = UserDefaults.standard.value(forKey: userDefaultsKey) as? Data,
              let history = try? PropertyListDecoder().decode(Array<HistoryTranslation>.self, from: data)
        else {
            return []
        }
        
        return history
    }
    
}
