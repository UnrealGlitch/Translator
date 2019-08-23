//
//  TranslateViewControllerModel.swift
//  Translator
//
//  Created by MadBrain on 20/08/2019.
//  Copyright © 2019 Andrey. All rights reserved.
//

import RxSwift
import RxCocoa

protocol TranslateViewControllerModelOutput: class {
    
}

final class TranslateViewControllerModel: BaseViewModel {
    
    // MARK: Variables
    
    weak var output: TranslateViewControllerModelOutput?
    
    let currentTranslation: HistoryTranslation?
    
    private(set) var languages = BehaviorRelay<[String]>(value: [])
    private(set) var translatedText = BehaviorRelay<[String]>(value: [])
    private(set) var autoDetectedLanguage = BehaviorRelay<String>(value: "")
    
    // MARK: Life cycle
    
    init(output: TranslateViewControllerModelOutput, currentTranslation: HistoryTranslation? = nil) {
        self.output = output
        self.currentTranslation = currentTranslation
        
        getLanguagesRequest()
    }
    
    // MARK: Public
    
    public func textViewDidChange(_ text: String, from: String, to: String, autoResponseLanguage: Bool) {
        if autoResponseLanguage {
            DataSource.instance.detectLanguage(text: text) { [weak self] (language) in
                guard let language = language else {
                    return
                }
                
                self?.autoDetectedLanguage.accept(language)
                self?.translateTextRequest(text, attributes: "\(language)-\(to)")
            }
        } else {
            translateTextRequest(text, attributes: "\(from)-\(to)")
        }
    }
    
    public func saveTranslationTOHistory(from: String, to: String, originalLanguage: String, targetLanguage: String) {
        UserDefaultsService.instance.addTranslationToHistory(text: from,
                                                             translatedText: to,
                                                             originalLanguage: originalLanguage,
                                                             targetLanguage: targetLanguage)
    }
    
    // MARK: Private
    
    private func getLanguagesRequest() {
        DataSource.instance.getLanguages { [weak self] (languages) in
            guard let languages = languages else {
                return
            }
            
            var array: [String] = []
            languages.forEach() {
                let splittedValues = $0.components(separatedBy: "-")
                array.append(contentsOf: splittedValues)
            }
            
            self?.languages.accept(Array(Set(array)))
        }
    }
    
    private func translateTextRequest(_ text: String, attributes: String) {
        DataSource.instance.translateText(text, language: attributes) { [weak self] (translatedText) in
            guard let translatedText = translatedText else {
                return
            }
            self?.translatedText.accept(translatedText)
        }
    }
    
}
