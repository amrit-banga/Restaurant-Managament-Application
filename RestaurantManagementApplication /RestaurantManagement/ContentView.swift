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
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top)
                
                Image(systemName: "fork.knife")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .padding()
                
                Spacer()
                
                VStack {
                    NavigationLink(destination: LoginView()) {
                        Text("Log In")
                            .font(.title2)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .padding(.horizontal)
                    
                    NavigationLink(destination: CreateAccountView()) {
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

