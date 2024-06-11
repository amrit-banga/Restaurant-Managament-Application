//
//  HomePageView.swift
//  RestaurantManagement
//
//  Created by Amrit Banga on 6/10/24.
//
import SwiftUI

struct HomePageView: View {
    var body: some View {
        VStack {
            Text("Home Page")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding()

            HStack {
                NavigationLink(destination: InventoryView()) {
                    VStack {
                        Image(systemName: "archivebox")
                            .resizable()
                            .frame(width: 100, height: 100)
                            .padding()
                        Text("Inventory")
                            .font(.title2)
                            .padding(.top, 10)
                    }
                    .frame(maxWidth: .infinity)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
                    .padding()
                }
                
                NavigationLink(destination: CostView()) {
                    VStack {
                        Image(systemName: "dollarsign.circle")
                            .resizable()
                            .frame(width: 100, height: 100)
                            .padding()
                        Text("Cost")
                            .font(.title2)
                            .padding(.top, 10)
                    }
                    .frame(maxWidth: .infinity)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
                    .padding()
                }
            }
            Spacer()
        }
        .padding()
    }
}

#Preview {
    HomePageView()
}
