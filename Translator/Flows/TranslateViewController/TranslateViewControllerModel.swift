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
    
    private(set) var languages = BehaviorRelay<[String]>(value: [])
    private(set) var translatedText = BehaviorRelay<[String]>(value: [])
    
    // MARK: Life cycle
    
    init(output: TranslateViewControllerModelOutput) {
        self.output = output
        
        getLanguagesRequest()
    }
    
    // MARK: Public
    
    public func textViewDidChange(_ text: String) {
        translateTextRequest(text)
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
    
    //TODO: FRom to
    private func translateTextRequest(_ text: String) {
        DataSource.instance.translateText(text, language: "ru") { [weak self] (translatedText) in
            guard let translatedText = translatedText else {
                return
            }
            self?.translatedText.accept(translatedText)
        }
    }
    
    //AAA
    //    func loadTest() {
    //        DataSource.instance.translateText("Hello", language: "ru") { (translatedText) in
    //            print(translatedText)
    //        }
    //        DataSource.instance.getLanguages { (languages) in
    //            print(languages)
    //        }
    //        DataSource.instance.detectLanguage(text: "TABLE") { (language) in
    //            print(language)
    //        }
    //    }
    
}
