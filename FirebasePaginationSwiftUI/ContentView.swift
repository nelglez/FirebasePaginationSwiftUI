//
//  ContentView.swift
//  FirebasePaginationSwiftUI
//
//  Created by Nelson Gonzalez on 2/1/20.
//  Copyright © 2020 Nelson Gonzalez. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var quoteController = QuoteController()
    
    var body: some View {
        
        NavigationView {
        
        List(self.quoteController.quotes) { quote in
            
            ItemRow(quote: quote).frame(height: 150).onAppear {
                
                print("Load more posts? ", self.quoteController.shouldLoadMoreData())
                
                if self.quoteController.shouldLoadMoreData() {
                    self.quoteController.fetchMore(currentItem: quote, limit: 5) { (error) in
                        if let error = error {
                            print(error.localizedDescription)
                        }
                    }
                }
            }
            }.navigationBarTitle("Firestore Pagination")
        }
    }
    
}


struct ItemRow: View {
    var quote: Quote
    var body: some View {
        ZStack {
            Rectangle().fill(Color.white).cornerRadius(10).shadow(color: .gray, radius: 5, x: 1, y: 1)
            VStack {
                Text(quote.body).font(.subheadline)
                Text(quote.author).font(.headline)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
