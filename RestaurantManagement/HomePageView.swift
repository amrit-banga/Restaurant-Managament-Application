//
//  HomePageView.swift
//  RestaurantManagement
//
//  Created by Amrit Banga on 6/10/24.
//
import SwiftUI

struct HomePageView: View {
    var business: Business?

    var body: some View {
        VStack {
            if let business = business {
                VStack {
                    Text("Welcome to \(business.name)")
                        .font(.largeTitle)
                        .padding(.top)
                    
                    if business.isAdmin {
                        Text("You are an admin and can edit the business.")
                            .padding()
                    } else {
                        Text("You can view the business details.")
                            .padding()
                    }
                }
                .padding(.top, 50)

                Spacer()

                HStack {
                    NavigationLink(destination: InventoryView()) {
                        VStack {
                            Image(systemName: "archivebox.fill")
                                .resizable()
                                .frame(width: 50, height: 50)
                            Text("Inventory")
                                .font(.title2)
                        }
                        .frame(width: 150, height: 150)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    }
                    
                    NavigationLink(destination: CostView()) {
                        VStack {
                            Image(systemName: "dollarsign.circle.fill")
                                .resizable()
                                .frame(width: 50, height: 50)
                            Text("Cost")
                                .font(.title2)
                        }
                        .frame(width: 150, height: 150)
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    }
                }
                .padding()
            } else {
                Text("No business selected.")
                    .font(.largeTitle)
                    .padding()
            }
        }
        .navigationBarTitle("Home", displayMode: .inline)
        .navigationBarBackButtonHidden(true) // Hide the default back button
        .navigationBarItems(leading: Button(action: {
            
        }) {
            HStack {
                Image(systemName: "arrow.left")
                Text("Your Businesses")
            }
        })
    }
}

struct HomePageView_Previews: PreviewProvider {
    static var previews: some View {
        HomePageView(business: Business(name: "Sample Business", code: "123456", isAdmin: true))
    }
}
