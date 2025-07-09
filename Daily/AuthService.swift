//
//  AuthService.swift
//  Daily
//
//  Created by 陳胤亮 on 2025/7/6.
//

import Foundation
import FirebaseAuth
import Combine

@MainActor
final class AuthService: ObservableObject {
    @Published private(set) var user: FirebaseAuth.User? 
    private var listener: AuthStateDidChangeListenerHandle?

    init() {
        user = Auth.auth().currentUser     // current session, if any
        listener = Auth.auth().addStateDidChangeListener { _, newUser in
            self.user = newUser            // fires on sign-in / out
        }
    }

    deinit { if let listener { Auth.auth().removeStateDidChangeListener(listener) } }

    func signIn(email: String, password: String) async throws {
        try await Auth.auth().signIn(withEmail: email, password: password)
    }

    func signUp(email: String, password: String) async throws {
        try await Auth.auth().createUser(withEmail: email, password: password)
    }

    func signOut() throws { try Auth.auth().signOut() }
}
