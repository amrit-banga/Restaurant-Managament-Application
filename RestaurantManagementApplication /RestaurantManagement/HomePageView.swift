//
//  HomePageView.swift
//  RestaurantManagement
//
//  Created by Amrit Banga on 6/10/24.
// Edited by Zijian Zhang on 6/28/24

import SwiftUI

struct HomePageView: View {
    @StateObject private var viewModel = BusinessViewModel()
    @State private var isShowingAddBusinessSheet = false
    @State private var isNavigatingToFoodInventory = false
    @State private var selectedBusiness: Business? = nil

    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(viewModel.businesses) { business in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(business.name)
                                Text("ID: \(business.id.uuidString)")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                            Spacer()
                            Button(action: {
                                selectedBusiness = business
                                isNavigatingToFoodInventory = true
                            }) {
                                Image(systemName: "pencil")
                                    .foregroundColor(.blue)
                            }
                            .buttonStyle(BorderlessButtonStyle())
                            Button(action: {
                                viewModel.removeBusiness(business)
                            }) {
                                Image(systemName: "trash")
                                    .foregroundColor(.red)
                            }
                            .buttonStyle(BorderlessButtonStyle())
                        }
                    }
                }
                .navigationTitle("Businesses")
                .toolbar {
                    ToolbarItem(placement: .primaryAction) {
                        Button(action: {
                            isShowingAddBusinessSheet = true
                        }) {
                            Image(systemName: "plus")
                        }
                    }
                }
                .sheet(isPresented: $isShowingAddBusinessSheet) {
                    AddBusinessView(viewModel: viewModel, isShowingBusinessSheet: $isShowingAddBusinessSheet)
                }
                if let selectedBusiness = selectedBusiness {
                    NavigationLink(destination: FoodInventoryView(business: selectedBusiness), isActive: $isNavigatingToFoodInventory) {
                        EmptyView()
                    }
                } else {
                    EmptyView()
                }
            }
            .onAppear {
                viewModel.fetchBusinesses()
            }
        }
    }
}
