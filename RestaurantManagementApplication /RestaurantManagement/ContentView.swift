//
//  ContentView.swift
//  RestaurantManagement
//
//  Created by Amrit Banga on 6/10/24.
//
import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            VStack {
                Text("Restaurant Management")
                    .font(.system(size: 40, weight: .bold))
                    .background(Color.white)
                    .foregroundColor(.orange)
                    .multilineTextAlignment(.center)
                    .padding(.top)
                
                Spacer()
                
                Image(systemName: "fork.knife.circle")
                    .resizable()
                    .frame(width: 175, height: 175)
                    .padding()
                
                Spacer()
                
                VStack {
                    NavigationLink(destination: LoginView()) {
                        Text("Log In")
                            .font(.title2)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.orange)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .padding(.horizontal)
                    
                    NavigationLink(destination: CreateAccountView()) {
                        Text("Create Account")
                            .font(.title2)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.orange)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .padding(.horizontal)
                    .padding(.top, 10)
                }
                .padding(.bottom)
                
                Spacer()
            }
            .padding()
        }
    }
}

#Preview {
    ContentView()
}
