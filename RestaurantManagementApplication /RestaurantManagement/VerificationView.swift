//
//  VerificationView.swift
//  RestaurantManagement
//
//  Created by Zijian Zhang on 6/24/24.
//

import SwiftUI

struct VerificationView: View {
    @State private var verificationCode: String = ""
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var navigateToHome = false
    var email: String
    @State private var correctCode: String = ""
    private let sendGridAPIKey = "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"
    
    var body: some View {
        VStack {
            
            Text("Enter Verification Code")
                .font(.system(size: 40, weight: .bold))
                .foregroundColor(.orange)
                .padding()

            TextField("Verification Code", text: $verificationCode)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(10)
                .padding(.horizontal)
                .keyboardType(.numberPad)
            
            Button(action: {
                sendVerificationCode()
            }) {
                Text("Send Verification Code")
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
            
            Button(action: {
                verifyCode()
            }) {
                Text("Verify Code")
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
            Alert(title: Text("Verification Result"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
        .background(
            NavigationLink(destination: HomePageView(), isActive: $navigateToHome) {
                EmptyView()
            }
        )
    }

    func sendVerificationCode() {
        correctCode = generateVerificationCode()
        let subject = "Your Verification Code"
        let plainTextContent = "Your verification code is \(correctCode)."
        let htmlContent = "<strong>Your verification code is \(correctCode).</strong>"
        
        let payload: [String: Any] = [
            "personalizations": [
                [
                    "to": [["email": email]]
                ]
            ],
            "from": ["email": "zzjian51821@gmail.com"],
            "subject": subject,
            "content": [
                ["type": "text/plain", "value": plainTextContent],
                ["type": "text/html", "value": htmlContent]
            ]
        ]
        
        guard let url = URL(string: "https://api.sendgrid.com/v3/mail/send") else {
            alertMessage = "Invalid URL"
            showAlert = true
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(sendGridAPIKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: payload, options: [])
        } catch {
            alertMessage = "Failed to encode payload: \(error.localizedDescription)"
            showAlert = true
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    alertMessage = "Failed to send verification code: \(error.localizedDescription)"
                    showAlert = true
                }
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                DispatchQueue.main.async {
                    alertMessage = "Invalid response from server"
                    showAlert = true
                }
                return
            }
            
            print("Response status code: \(httpResponse.statusCode)")
            
            if httpResponse.statusCode == 202 {
                DispatchQueue.main.async {
                    alertMessage = "Verification code sent to \(email)"
                    showAlert = true
                }
            } else {
                let responseBody = String(data: data ?? Data(), encoding: .utf8) ?? "No response body"
                DispatchQueue.main.async {
                    alertMessage = "Failed to send verification code. Status code: \(httpResponse.statusCode). Response: \(responseBody)"
                    showAlert = true
                }
            }
        }.resume()
    }
    
    func generateVerificationCode() -> String {
        return String(format: "%06d", Int.random(in: 0...999999))
    }

    func verifyCode() {
        if verificationCode == correctCode {
            navigateToHome = true
        } else {
            alertMessage = "Verification failed. Please try again."
            showAlert = true
        }
    }
}

struct VerificationView_Previews: PreviewProvider {
    static var previews: some View {
        VerificationView(email: "test@example.com")
    }
}

