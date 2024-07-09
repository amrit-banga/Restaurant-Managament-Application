//
//  JoinBusinessView.swift
//  RestaurantManagement
//
//  Created by Zijian Zhang on 7/6/24
//



import SwiftUI

struct JoinBusinessView: View {
    @State private var businessIdString: String = ""
    @ObservedObject var viewModel: BusinessViewModel
    @Binding var isShowingJoinBusinessSheet: Bool
    @State private var showingAlert = false
    @State private var alertMessage = ""
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    var body: some View {
        NavigationView {
            VStack {
                TextField("Enter Business ID", text: $businessIdString)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                Button(action: {
                    if let businessId = UUID(uuidString: businessIdString) {
                        viewModel.joinBusinessWithResult(businessId: businessId) { result in
                            alertMessage = result
                            showingAlert = true
                        }
                    } else {
                        alertMessage = "Invalid Business ID"
                        showingAlert = true
                    }
                }) {
                    Text("Join Business")
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
            .navigationTitle("Join Business")
            .navigationBarItems(leading: Button(action: {
                isShowingJoinBusinessSheet = false
            }) {
                Text("Back")
            })
            .alert(isPresented: $showingAlert) {
                Alert(
                    title: Text(alertMessage),
                    dismissButton: .default(Text("OK")) {
                        self.presentationMode.wrappedValue.dismiss()
                    }
                )
            }
        }
    }
}

struct JoinBusinessView_Previews: PreviewProvider {
    static var previews: some View {
        JoinBusinessView(viewModel: BusinessViewModel(), isShowingJoinBusinessSheet: .constant(true))
    }
}
