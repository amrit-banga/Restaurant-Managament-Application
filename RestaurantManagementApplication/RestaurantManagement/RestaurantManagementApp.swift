//
//  RestaurantManagementApp.swift
//  RestaurantManagement
//
//  Created by Amrit Banga on 6/10/24.
//
import SwiftUI
import Firebase

@main
 struct RestaurantManagementApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView()
            }
        }
    }
}

