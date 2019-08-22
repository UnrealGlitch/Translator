//
//  DataSource.swift
//  Translator
//
//  Created by MadBrain on 19/08/2019.
//  Copyright © 2019 Andrey. All rights reserved.
//

import Alamofire
import AlamofireObjectMapper
import ObjectMapper

final class DataSource {
    
    // MARK: Variables
    
    static let instance = DataSource()
    
    private let apiKey = "trnsl.1.1.20190819T165746Z.7abfe04761eda072.5f5e69b555dffdd8d30b0f6556b40fee716a748a"
    private let translateUrl = "https://translate.yandex.net/api/v1.5/tr.json/translate"
    private let languagesUrl = "https://translate.yandex.net/api/v1.5/tr.json/getLangs"
    private let detectLanguageUrl = "https://translate.yandex.net/api/v1.5/tr.json/detect"
    
    // MARK: Public
    
    public func translateText(_ text: String, language: String, completionHandler: @escaping ([String]?) -> Void) {
        let parameters = ["key": apiKey, "text": text, "lang": language]
        performQuery(url: translateUrl, with: parameters) { (response: TranslationResponse) in
            completionHandler(response.text)
        }
    }
    
    public func getLanguages(completionHandler: @escaping ([String]?) -> Void) {
        let parameters = ["key": apiKey]
        performQuery(url: languagesUrl, with: parameters) { (response: LanguagesListResponse) in
            completionHandler(response.dirs)
        }
    }
    
    public func detectLanguage(text: String, completionHandler: @escaping (String?) -> Void) {
        let parameters = ["key": apiKey, "text": text]
        performQuery(url: detectLanguageUrl, with: parameters) { (response: PossibleLanguageResponse) in
            completionHandler(response.lang)
        }
    }
    
    // MARK: Private
    
    private func performQuery<T: Mappable>(url: String,
                                           with parameters: Parameters,
                                           completionHandler: ((T) -> Void)? = nil) {
        Alamofire.request(url,
                          method: .post,
                          parameters: parameters,
                          encoding: URLEncoding.default).responseObject { (response: DataResponse<T>) in
                            guard let value = response.result.value else {
                                print("[DataSource.performQuery]: Something wrong!")
                                return
                            }
                            completionHandler?(value)
        }
    }
    
}
