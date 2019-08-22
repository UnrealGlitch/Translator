//
//  ResponseData.swift
//  Translator
//
//  Created by MadBrain on 19/08/2019.
//  Copyright © 2019 Andrey. All rights reserved.
//

import ObjectMapper

final class TranslationResponse: Mappable {
    
    var lang: String?
    var code: Int?
    var text: [String]?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        lang <- map["lang"]
        code <- map["code"]
        text <- map["text"]
    }
    
}

final class LanguagesListResponse: Mappable {
    
    var dirs: [String]?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        dirs <- map["dirs"]
    }
    
}

final class PossibleLanguageResponse: Mappable {
    
    var lang: String?
    var code: Int?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        lang <- map["lang"]
        code <- map["code"]
    }
    
}
