//
//  Quote.swift
//  FirebasePaginationSwiftUI
//
//  Created by Nelson Gonzalez on 2/1/20.
//  Copyright © 2020 Nelson Gonzalez. All rights reserved.
//

import Foundation

struct Quote: Identifiable {
    let id: String
    let author: String
    let body: String
    
    init(id: String = "", author: String = "", body: String = "") {
        self.id = id
        self.author = author
        self.body = body
    }
    
    
    init(data: [String: Any]) {
        self.id = data["id"] as? String ?? ""
        self.author = data["author"] as? String ?? ""
        self.body = data["body"] as? String ?? ""
    }
}
