//
//  LoginView.swift
//  TtApp
//
//  Created by Amrit Banga on 6/10/24.
//  Changed by Zijian Zhang on 6/24/24

import SwiftUI
import FirebaseAuth

struct LoginView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var navigateToVerification = false
    @State private var showAlert = false
    @State private var alertMessage = ""

    var body: some View {
        VStack {
            Text("Log In")
                .font(.system(size: 40, weight: .bold))
                .foregroundColor(.orange)
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
            
            NavigationLink(destination: VerificationView(email: email), isActive: $navigateToVerification) {
                EmptyView()
            }

            Button(action: {
                login()
            }) {
                Text("Log In")
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
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Login Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
    }

    func login() {
        if email.isEmpty || password.isEmpty {
            alertMessage = "Please fill in all fields."
            showAlert = true
        } else if !isValidEmail(email) {
            alertMessage = "Invalid email address."
            showAlert = true
        } else {
            Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                if let error = error {
                    alertMessage = error.localizedDescription
                    showAlert = true
                } else {
                    navigateToVerification = true
                }
            }
        }
    }

    func isValidEmail(_ email: String) -> Bool {
        let emailFormat = "(?:[a-zA-Z0-9!#$%&'*+/=?^_{|}~-]+(?:\\.[a-zA-Z0-9!#$%&'*+/=?^_{|}~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:[a-zA-Z0-9](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?\\.)+[a-zA-Z0-9](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: email)
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}

