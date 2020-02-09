//
//  QuoteController.swift
//  FirebasePaginationSwiftUI
//
//  Created by Nelson Gonzalez on 2/1/20.
//  Copyright © 2020 Nelson Gonzalez. All rights reserved.
//

import Foundation
import Firebase

class QuoteController: ObservableObject, RandomAccessCollection {
    
    typealias Element = Quote
    @Published var quotes: [Quote] = []
    
    var startIndex: Int { quotes.startIndex }
    var endIndex: Int { quotes.endIndex }
    var lastQueryDocumentSnapshot: QueryDocumentSnapshot?
    let db = Firestore.firestore()
    private var fetching = false
    var quoteQuery: Query {
        db.collection("quotes")
    }
    
    var currentlyLoading = false
    var doneLoading = false
    
    subscript(position: Int) -> Quote {
        return quotes[position]
    }
    
    init() {
        fetchFromServer(limit: 5) { (error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
        }
    }
    
    func shouldLoadMoreData(currentItem: Quote? = nil) -> Bool {
        
        if currentlyLoading || doneLoading {
            return false
        }
        
        guard let currentItem = currentItem else {
            return true
        }
        
        for n in (quotes.count - 4)...(quotes.count - 1) {
            if n >= 0 && currentItem.id == quotes[n].id {
                return true
            }
        }
        
        return false
        
        
    }
    
    func fetchFromServer(limit: Int, completion: @escaping(Error?) -> Void) {
        
        currentlyLoading = true
        
        quoteQuery.limit(to: limit).getDocuments { snapShot, error in
            if let error = error {
                
                self.currentlyLoading = false
                completion(error)
                return
            }
            
            guard let snapShot = snapShot else {
                
                self.currentlyLoading = false
                completion(NSError())
                return
                
            }
            
            
            var quotes = [Quote]()
            for doc in snapShot.documents {
                let data = doc.data() as [String: Any]
                let quote = Quote(data: data)
                quotes.append(quote)
            }
            
            if let last = snapShot.documents.last {
                self.lastQueryDocumentSnapshot = last
                
            }
            
            self.quotes = quotes
            
            self.currentlyLoading = false
            
            
            print("First fetch count:", self.quotes.count)
            
            completion(nil)
            
            
        }
    }
    
    func fetchMore(currentItem: Quote?, limit: Int = 5, completion: @escaping(Error?) -> Void) {
        //Remove this for tinder app..lines 112 - 115
        
        if !shouldLoadMoreData(currentItem: currentItem) {
            return
        }
        
        
        
        self.currentlyLoading = true
        quoteQuery.start(afterDocument: lastQueryDocumentSnapshot!).limit(to: limit).getDocuments { snapShot, error in
            if let error = error {
                
                self.currentlyLoading = false
                completion(error)
                
            }
            
            guard let snapShot = snapShot else {
                
                self.currentlyLoading = false
                
                completion(NSError())
                return
                
            }
            
            print("SnapShot Document Count: ", snapShot.documents.count)
            
            var quotes = [Quote]()
           
            for doc in snapShot.documents {
                let doc  = doc.data() as [String: Any]
                let quote = Quote(data: doc)
                // print(quote.author)
                quotes.append(quote)
                
            }
            self.quotes.insert(contentsOf: quotes, at: self.startIndex)
            
           // self.quotes.append(contentsOf: quotes)
            print("Second fetch count:", self.quotes.count)
            
            
            self.currentlyLoading = false
            
            if quotes.count == 0 {
                self.doneLoading = true
                print("Done loading :)")
            } else {
                print("Not done loading...")
            }
            
            print("First fetch count:", self.quotes.count)
            if let last = snapShot.documents.last {
                self.lastQueryDocumentSnapshot = last
                
            }
            
            completion(nil)
        }
    }
    
}
