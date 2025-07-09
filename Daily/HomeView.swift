//
//  HomeView.swift
//  Daily
//
//  Created by 陳胤亮 on 2025/7/7.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var auth: AuthService

    var body: some View {
        NavigationStack {
            GoalListView()
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Welcome back!")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Text(auth.user?.email ?? "User")
                                .font(.headline)
                                .foregroundColor(.primary)
                        }
                    }
                    
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Menu {
                            Button(action: {
                                try? auth.signOut()
                            }) {
                                Label("Sign Out", systemImage: "rectangle.portrait.and.arrow.right")
                            }
                        } label: {
                            Image(systemName: "person.circle")
                                .font(.title2)
                                .foregroundColor(.blue)
                        }
                    }
                }
        }
    }
}

#if DEBUG
struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView().environmentObject(AuthService())
    }
}
#endif
