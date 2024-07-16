//
//  HomePageView.swift
//  RestaurantManagement
//
//  Created by Amrit Banga on 6/10/24.
// Edited by Zijian Zhang on 6/28/24, 7/6/24
import SwiftUI
import FirebaseAuth

struct HomePageView: View {
    @StateObject private var viewModel = BusinessViewModel()
    @State private var isShowingAddBusinessSheet = false
    @State private var isShowingJoinBusinessSheet = false
    @State private var isNavigatingToFoodInventory = false
    @State private var selectedBusiness: Business? = nil
    @State private var showingAlert = false
    @State private var alertType: AlertType? = nil
    @State private var selectedBusinessForAction: Business? = nil
    
    enum AlertType {
        case delete
        case quit
    }

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
                                if business.ownerId == Auth.auth().currentUser?.uid {
                                    selectedBusinessForAction = business
                                    alertType = .delete
                                } else {
                                    selectedBusinessForAction = business
                                    alertType = .quit
                                }
                                showingAlert = true
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
                        HStack {
                            Button(action: {
                                isShowingAddBusinessSheet = true
                            }) {
                                Image(systemName: "plus")
                            }
                            Button(action: {
                                isShowingJoinBusinessSheet = true
                            }) {
                                Image(systemName: "person.badge.plus")
                            }
                        }
                    }
                }
                .sheet(isPresented: $isShowingAddBusinessSheet) {
                    AddBusinessView(viewModel: viewModel, isShowingBusinessSheet: $isShowingAddBusinessSheet)
                }
                .sheet(isPresented: $isShowingJoinBusinessSheet) {
                    JoinBusinessView(viewModel: viewModel, isShowingJoinBusinessSheet: $isShowingJoinBusinessSheet)
                }
                if let selectedBusiness = selectedBusiness {
                    NavigationLink(destination: FoodInventoryView(business: selectedBusiness), isActive: $isNavigatingToFoodInventory) {
                        EmptyView()
                    }
                }
            }
            .onAppear {
                viewModel.fetchBusinesses()
            }
            .alert(isPresented: $showingAlert) {
                if alertType == .delete {
                    return Alert(
                        title: Text("Are you sure you want to delete this business?"),
                        primaryButton: .destructive(Text("Yes")) {
                            if let businessToDelete = selectedBusinessForAction {
                                viewModel.removeBusiness(businessToDelete)
                            }
                        },
                        secondaryButton: .cancel()
                    )
                } else {
                    return Alert(
                        title: Text("Are you sure you want to quit this business?"),
                        primaryButton: .destructive(Text("Yes")) {
                            if let businessToQuit = selectedBusinessForAction {
                                viewModel.quitBusiness(businessToQuit)
                            }
                        },
                        secondaryButton: .cancel()
                    )
                }
            }
        }
    }
}

struct HomePageView_Previews: PreviewProvider {
    static var previews: some View {
        HomePageView()
    }
}
