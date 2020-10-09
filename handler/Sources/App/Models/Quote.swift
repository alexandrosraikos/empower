//
//  File.swift
//  
//
//  Created by Αλέξανδρος Ράικος on 6/10/20.
//

import Vapor
import Fluent
import FluentMongoDriver

final class Quote: Model, Content {
    static var schema = "quotes"
    
    @ID(custom: "_id", generatedBy: .database)
    var id: String?
    
    @Field(key: "quote")
    var quote: String
    
    @Field(key:"citation")
    var citation: String
    
    required init() {}
    
    init(id: String? = nil, quote: String, citation: String) {
        self.id = id
        self.quote = quote
        self.citation = citation
    }
}
