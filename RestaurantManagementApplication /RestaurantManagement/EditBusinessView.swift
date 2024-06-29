//
//  EditBusinessView.swift
//  RestaurantManagement
//
//  Created by Zijian Zhang on 6/28/24.

import SwiftUI

struct EditBusinessView: View {
    @State private var name: String
    @State private var uniqueID: String
    @ObservedObject var viewModel: BusinessViewModel
    var business: Business
    @Binding var isShowingBusinessSheet: Bool
    @Binding var isNavigatingToFoodInventory: Bool

    init(viewModel: BusinessViewModel, business: Business, isShowingBusinessSheet: Binding<Bool>, isNavigatingToFoodInventory: Binding<Bool>) {
        self.viewModel = viewModel
        self.business = business
        _name = State(initialValue: business.name)
        _uniqueID = State(initialValue: business.id.uuidString)
        _isShowingBusinessSheet = isShowingBusinessSheet
        _isNavigatingToFoodInventory = isNavigatingToFoodInventory
    }

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Edit Business")) {
                    TextField("Business Name", text: $name)
                    TextField("Unique ID", text: $uniqueID)
                    Button("Save Changes") {
                        if let uuid = UUID(uuidString: uniqueID) {
                            let updatedBusiness = Business(name: name, id: uuid)
                            viewModel.updateBusiness(updatedBusiness)
                            isShowingBusinessSheet = false
                            isNavigatingToFoodInventory = true
                        }
                    }
                }
            }
            .navigationTitle("Edit Business")
            .navigationBarItems(leading: Button("Cancel") {
                isShowingBusinessSheet = false 
            })
        }
    }
}
