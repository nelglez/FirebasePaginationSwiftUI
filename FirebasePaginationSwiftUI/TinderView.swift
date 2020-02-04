//
//  TinderView.swift
//  FirebasePaginationSwiftUI
//
//  Created by Nelson Gonzalez on 2/3/20.
//  Copyright © 2020 Nelson Gonzalez. All rights reserved.
//

import SwiftUI

struct TinderView: View {
    /// List of users
    @ObservedObject var quoteController = QuoteController()
    
    /// Return the CardViews width for the given offset in the array
    /// - Parameters:
    ///   - geometry: The geometry proxy of the parent
    ///   - id: The ID of the current user
    private func getCardWidth(_ geometry: GeometryProxy, id: Int) -> CGFloat {
        let offset: CGFloat = CGFloat(quoteController.quotes.count - 1 - id) * 10
        return geometry.size.width - offset
    }
    
    /// Return the CardViews frame offset for the given offset in the array
    /// - Parameters:
    ///   - geometry: The geometry proxy of the parent
    ///   - id: The ID of the current user
    private func getCardOffset(_ geometry: GeometryProxy, id: Int) -> CGFloat {
        return  CGFloat(quoteController.quotes.count - 1 - id) * 10
    }
    /*
     private var maxID: Int {
     return self.users.map { $0.id }.max() ?? 0
     }
     */
    var body: some View {
        VStack {
            GeometryReader { geometry in
                LinearGradient(gradient: Gradient(colors: [Color.init(#colorLiteral(red: 0.8509803922, green: 0.6549019608, blue: 0.7803921569, alpha: 1)), Color.init(#colorLiteral(red: 1, green: 0.9882352941, blue: 0.862745098, alpha: 1))]), startPoint: .bottom, endPoint: .top)
                    .frame(width: geometry.size.width * 1.5, height: geometry.size.height)
                    .background(Color.blue)
                    .clipShape(Circle())
                    .offset(x: -geometry.size.width / 4, y: -geometry.size.height / 2)
                
                VStack(spacing: 24) {
                    DateView()
                    ZStack {
                        ForEach(self.quoteController.quotes, id: \.id) { quote in
                            Group {
                                // Range Operator
                                //      if (self.maxID - 3)...self.maxID ~= user.id {
                                //      if (self.quoteController.quotes.count - 3)...self.quoteController.quotes.count ~= 10 {
                                CardView(quote: quote, onRemove: { removedUser in
                                    // Remove that user from our array
                                    
                                    self.quoteController.quotes.removeAll { $0.id == removedUser.id }
                                    print(self.quoteController.quotes.count)
                                    
                                    if self.quoteController.quotes.count == 1 {
                                        self.quoteController.fetchMore(currentItem: quote, limit: 5) { (error) in
                                            if let error = error {
                                                print(error.localizedDescription)
                                            }
                                        }
                                    }
                                    
                                }).onAppear {
                                    print("Appear")
                                    
                                }
                                .animation(.spring())
                                .frame(width: self.getCardWidth(geometry, id: self.quoteController.quotes.count), height: CGFloat(400))
                                .offset(x: CGFloat(0), y: self.getCardOffset(geometry, id: self.quoteController.quotes.count))
                            }
                            
                            
                            //    }
                        }
                    }
                    Spacer()
                }
            }
        }.padding()
    }
}

struct DateView: View {
    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading) {
                    Text(dateString())
                        .font(.title)
                        .bold()
                    Text("Today")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                Spacer()
            }.padding()
        }
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 5)
    }
    func dateString() -> String {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.dateFormat = "EEEE, MMM dd yyyy"
        return formatter.string(from: date)
    }
}
struct TinderView_Previews: PreviewProvider {
    static var previews: some View {
        TinderView()
    }
}
