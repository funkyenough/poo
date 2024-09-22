//
//  ContentView.swift
//  poo
//
//  Created by YaoNing on 2024/09/21.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
    }
}

#Preview {
    LoginView()
}

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var showingRegistration = false

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Image(systemName: "seal.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100, height: 100)
                    .foregroundColor(.secondaryColor)

                Text("PooTracker")
                    .font(.largeTitle)
                    .fontWeight(.bold)

                TextField("Email", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .autocapitalization(.none)

                SecureField("Password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                Button(action: {
                    // Perform login action
                    print("Login tapped")
                }) {
                    Text("Log In")
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .padding()
                        .background(Color.secondaryColor)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }

                Button("Don't have an account? Sign Up") {
                    showingRegistration = true
                }
                .foregroundColor(.secondaryColor)
            }
            .padding()
            .navigationBarHidden(true)
        }
        .sheet(isPresented: $showingRegistration) {
            RegisterView()
        }
    }
}

struct RegisterView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Image(systemName: "seal.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100, height: 100)
                    .foregroundColor(.secondaryColor)

                Text("Create Account")
                    .font(.largeTitle)
                    .fontWeight(.bold)

                TextField("Email", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .autocapitalization(.none)

                SecureField("Password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                SecureField("Confirm Password", text: $confirmPassword)
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                Button(action: {
                    // Perform registration action
                    print("Register tapped")
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Register")
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .padding()
                        .background(Color.secondaryColor)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }

                Button("Already have an account? Log In") {
                    presentationMode.wrappedValue.dismiss()
                }
                .foregroundColor(.secondaryColor)
            }
            .padding()
            .navigationBarHidden(true)
        }
    }
}
