//
//  CreateAccountView.swift
//  TestApp
//
//  Created by Amrit Banga on 6/10/24.
//  Changed by Zijian Zhang on 6/24/24

import SwiftUI
import FirebaseAuth

struct CreateAccountView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State private var navigateToLogin = false
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var showSuccessMessage = false

    var body: some View {
        VStack {
            Text("Create Account")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding()

            TextField("Email", text: $email)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(10)
                .padding(.horizontal)
                .keyboardType(.emailAddress)
                .autocapitalization(.none)
            
            SecureField("Password", text: $password)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(10)
                .padding(.horizontal)
            
            SecureField("Confirm Password", text: $confirmPassword)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(10)
                .padding(.horizontal)

            Button(action: {
                createAccount()
            }) {
                Text("Create Account")
                    .font(.title2)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding(.horizontal)
            .padding(.top, 10)
            
            Spacer()
        }
        .padding()
        .alert(isPresented: $showAlert) {
            Alert(title: Text(showSuccessMessage ? "Success" : "Account Creation Error"),
                  message: Text(alertMessage),
                  dismissButton: .default(Text("OK")) {
                    if showSuccessMessage {
                        // Navigate back to login page after showing success message
                        navigateToLogin = true
                    }
                  })
        }
        .background(
            NavigationLink(destination: LoginView(), isActive: $navigateToLogin) {
                EmptyView()
            }
            .hidden()
        )
    }

    func createAccount() {
        if password != confirmPassword {
            alertMessage = "Passwords do not match."
            showAlert = true
        } else if email.isEmpty || password.isEmpty {
            alertMessage = "Please fill in all fields."
            showAlert = true
        } else if !isValidEmail(email) {
            alertMessage = "Invalid email address."
            showAlert = true
        } else {
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                if let error = error {
                    alertMessage = error.localizedDescription
                    showAlert = true
                } else {
                    alertMessage = "Account created successfully."
                    showSuccessMessage = true
                    showAlert = true
                }
            }
        }
    }

    func isValidEmail(_ email: String) -> Bool {
        let emailFormat = "(?:[a-zA-Z0-9!#$%&'*+/=?^_`{|}~-]+(?:\\.[a-zA-Z0-9!#$%&'*+/=?^_`{|}~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:[a-zA-Z0-9](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?\\.)+[a-zA-Z0-9](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: email)
    }
}

#Preview {
    CreateAccountView()
}
