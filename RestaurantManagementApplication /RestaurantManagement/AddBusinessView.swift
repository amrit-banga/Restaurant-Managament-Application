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
                Text("Add Business")
                    .font(.system(size: 40, weight: .bold))
                    .foregroundColor(.orange)
                    .multilineTextAlignment(.center)
                    .padding()

                TextField("Business Name", text: $businessName)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(10)
                    .padding(.horizontal)
                    .multilineTextAlignment(.center)
                
                Button(action: {
                    viewModel.addBusiness(name: businessName)
                    isShowingBusinessSheet = false
                }) {
                    Text("Add Business")
                        .font(.title2)
                        .fontWeight(.bold)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.orange)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.horizontal)
                .padding(.top, 10)
                
                Spacer()
            }
            .padding()
            .navigationBarItems(leading: Button(action: {
                isShowingBusinessSheet = false
            }) {
                Text("Back")
                    .foregroundColor(.orange)
            })
        }
    }
}

struct AddBusinessView_Previews: PreviewProvider {
    static var previews: some View {
        AddBusinessView(viewModel: BusinessViewModel(), isShowingBusinessSheet: .constant(true))
    }
}

