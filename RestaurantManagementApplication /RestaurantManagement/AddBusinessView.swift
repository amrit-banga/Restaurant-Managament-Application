//
//  AddBusinessView.swift
//  RestaurantManagement
//
//  Created by Amrit Banga on 6/22/24.
//

import Foundation
import SwiftUI

struct AddBusinessView: View {
    @State private var businesses: [Business] = []
    @State private var showAddBusinessModal = false
    @State private var selectedBusiness: Business?
    @State private var businessName: String = ""
    @State private var businessCode: String = ""
    @State private var isAddingByCode = false
    @State private var showAlert = false
    @State private var alertMessage = ""

    var body: some View {
        NavigationView {
            VStack {
                List(businesses, id: \.id) { business in
                    Button(action: {
                        selectedBusiness = business
                    }) {
                        VStack(alignment: .leading) {
                            Text(business.name)
                                .font(.headline)
                            Text("Code: \(business.code)")
                                .font(.subheadline)
                        }
                    }
                    .background(
                        NavigationLink(
                            destination: HomePageView(business: selectedBusiness),
                            tag: business,
                            selection: $selectedBusiness
                        ) {
                            EmptyView()
                        }
                        .hidden()
                    )
                }
                
                Button(action: {
                    showAddBusinessModal.toggle()
                }) {
                    Text("Add Business")
                        .font(.title2)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding()
                .sheet(isPresented: $showAddBusinessModal) {
                    AddBusinessModalView(isPresented: $showAddBusinessModal, businesses: $businesses, isAddingByCode: $isAddingByCode, businessName: $businessName, businessCode: $businessCode, showAlert: $showAlert, alertMessage: $alertMessage)
                }
            }
            .navigationBarTitle("Your Businesses")
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Business Management"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
        }
    }
}

struct AddBusinessModalView: View {
    @Binding var isPresented: Bool
    @Binding var businesses: [Business]
    @Binding var isAddingByCode: Bool
    @Binding var businessName: String
    @Binding var businessCode: String
    @Binding var showAlert: Bool
    @Binding var alertMessage: String

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Business Details")) {
                    Toggle("Add by Code", isOn: $isAddingByCode)
                    
                    if isAddingByCode {
                        TextField("Business Code", text: $businessCode)
                            .padding()
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(10)
                            .padding(.horizontal)
                    } else {
                        TextField("Business Name", text: $businessName)
                            .padding()
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(10)
                            .padding(.horizontal)
                    }
                }
                
                Section {
                    Button(action: saveBusiness) {
                        Text("Save Business")
                    }
                }
            }
            .navigationBarTitle("Add Business", displayMode: .inline)
            .navigationBarItems(trailing: Button("Cancel") {
                isPresented = false
            })
        }
    }
    
    func saveBusiness() {
        if isAddingByCode {
            // Logic to add business by code
            if businessCode.isEmpty {
                alertMessage = "Please enter a business code."
                showAlert = true
            } else {
                // Simulate fetching business by code and adding to the list
                let business = Business(name: "Fetched Business", code: businessCode, isAdmin: false)
                businesses.append(business)
                alertMessage = "Business added successfully."
                showAlert = true
                isPresented = false
            }
        } else {
            if businessName.isEmpty {
                alertMessage = "Please enter a business name."
                showAlert = true
            } else {
                // Create new business
                let business = Business(name: businessName, code: generateBusinessCode(), isAdmin: true)
                businesses.append(business)
                alertMessage = "Business created successfully with code: \(business.code)"
                showAlert = true
                isPresented = false
            }
        }
    }
    
    func generateBusinessCode() -> String {
        return UUID().uuidString
    }
}

struct AddBusinessView_Previews: PreviewProvider {
    static var previews: some View {
        AddBusinessView()
    }
}
