//
//  AddBusinessView.swift
//  RestaurantManagement
//
//  Created by Amrit Banga on 6/25/24.
//  Edited by Zijian Zhang on 6/28/24, 7/6/24


import SwiftUI

struct AddBusinessView: View {
    @ObservedObject var viewModel: BusinessViewModel
    @Binding var isShowingBusinessSheet: Bool
    @State private var businessName: String = ""
    
    var body: some View {
        NavigationView {
            VStack {
                TextField("Business Name", text: $businessName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                Button(action: {
                    viewModel.addBusiness(name: businessName)
                    isShowingBusinessSheet = false
                }) {
                    Text("Add Business")
                        .font(.title2)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding()
                
                Spacer()
            }
            .padding()
            .navigationTitle("Add Business")
            .navigationBarItems(leading: Button(action: {
                isShowingBusinessSheet = false
            }) {
                Text("Back")
            })
        }
    }
}

struct AddBusinessView_Previews: PreviewProvider {
    static var previews: some View {
        AddBusinessView(viewModel: BusinessViewModel(), isShowingBusinessSheet: .constant(true))
    }
}
