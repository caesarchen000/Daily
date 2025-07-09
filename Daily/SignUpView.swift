//
//  SignUpView.swift
//  Daily
//
//  Created by 陳胤亮 on 2025/7/6.
//

import SwiftUI
import FirebaseAuth

struct SignUpView: View {
    @EnvironmentObject var auth: AuthService
    @Environment(\.dismiss) private var dismiss
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var errorMessage: String?
    @State private var isLoading = false

    var body: some View {
        VStack(spacing: 30) {
            // Header
            VStack(spacing: 16) {
                Image(systemName: "person.badge.plus")
                    .font(.system(size: 60))
                    .foregroundColor(.blue)
                
                Text("Create Account")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Text("Join us to start tracking your goals")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .padding(.top, 30)
            
            // Sign Up Form
            VStack(spacing: 20) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Email")
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    TextField("Enter your email", text: $email)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                        .textFieldStyle(.roundedBorder)
                        .disabled(isLoading)
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Password")
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    SecureField("Enter password (min 6 characters)", text: $password)
                        .textFieldStyle(.roundedBorder)
                        .disabled(isLoading)
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Confirm Password")
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    SecureField("Confirm your password", text: $confirmPassword)
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
                
                Button(action: createAccount) {
                    HStack {
                        if isLoading {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                .scaleEffect(0.8)
                        } else {
                            Text("Create Account")
                                .fontWeight(.semibold)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(isFormValid ? Color.blue : Color.gray)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
                .disabled(!isFormValid || isLoading)
            }
            .padding(.horizontal, 30)
            
            Spacer()
        }
        .navigationTitle("Sign Up")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private var isFormValid: Bool {
        !email.isEmpty && 
        !password.isEmpty && 
        !confirmPassword.isEmpty && 
        password == confirmPassword && 
        password.count >= 6 &&
        email.contains("@")
    }
    
    private func createAccount() {
        isLoading = true
        errorMessage = nil
        
        Task {
            do {
                try await auth.signUp(email: email, password: password)
                dismiss()
            } catch {
                let ns = error as NSError
                let code = AuthErrorCode.Code(rawValue: ns.code)
                
                switch code {
                case .emailAlreadyInUse:
                    errorMessage = "An account with this email already exists."
                case .weakPassword:
                    errorMessage = "Password is too weak. Please choose a stronger password."
                case .invalidEmail:
                    errorMessage = "Please enter a valid email address."
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

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
