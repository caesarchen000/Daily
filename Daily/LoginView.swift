//
//  LoginView.swift
//  Daily
//
//  Created by 陳胤亮 on 2025/7/6.
//

import SwiftUI
import FirebaseAuth

struct LoginView: View {
    @EnvironmentObject var auth: AuthService
    @State private var email = ""
    @State private var password = ""
    @State private var errorMessage: String?
    @State private var isLoading = false

    var body: some View {
        VStack(spacing: 30) {
            // App Logo/Title
            VStack(spacing: 16) {
                Image(systemName: "target")
                    .font(.system(size: 80))
                    .foregroundColor(.blue)
                
                Text("Daily Goals")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Text("Track your daily achievements")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .padding(.top, 50)
            
            // Login Form
            VStack(spacing: 20) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Email")
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    TextField("Enter your email", text: $email)
                        .keyboardType(.emailAddress)
                        .textContentType(.emailAddress)
                        .autocapitalization(.none)
                        .textFieldStyle(.roundedBorder)
                        .disabled(isLoading)
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Password")
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    SecureField("Enter your password", text: $password)
                        .textContentType(.password)
                        .textFieldStyle(.roundedBorder)
                        .disabled(isLoading)
                }
                
                if let errorMessage = errorMessage {
                    HStack {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .foregroundColor(.red)
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .font(.subheadline)
                    }
                    .padding(.horizontal)
                }
                
                Button(action: signIn) {
                    HStack {
                        if isLoading {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                .scaleEffect(0.8)
                        } else {
                            Text("Sign In")
                                .fontWeight(.semibold)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
                .disabled(email.isEmpty || password.isEmpty || isLoading)
            }
            .padding(.horizontal, 30)
            
            Divider()
                .padding(.horizontal, 30)
            
            NavigationLink("New here? Sign up", destination: SignUpView())
                .font(.subheadline)
                .foregroundColor(.blue)
                .disabled(isLoading)
            
            Spacer()
        }
        .navigationTitle("Sign In")
        .navigationBarHidden(true)
    }
    
    private func signIn() {
        isLoading = true
        errorMessage = nil
        
        Task {
            do {
                try await auth.signIn(email: email, password: password)
            } catch {
                let ns = error as NSError
                let code = AuthErrorCode.Code(rawValue: ns.code)
                
                switch code {
                case .wrongPassword:
                    errorMessage = "Wrong password. Please try again."
                case .invalidEmail:
                    errorMessage = "No account found with that email."
                case .userNotFound:
                    errorMessage = "Email not registered. Please sign up first."
                case .internalError:
                    errorMessage = "Something went wrong. Please try again."
                default:
                    errorMessage = ns.localizedDescription
                }
            }
            isLoading = false
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
