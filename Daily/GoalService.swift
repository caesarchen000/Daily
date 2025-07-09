//
//  GoalService.swift
//  Daily
//
//  Created by 陳胤亮 on 2025/7/7.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift
import Combine

@MainActor
final class GoalsService: ObservableObject {
    @Published private(set) var goals: [Goal] = []
    private var listener: ListenerRegistration?

    init() { Task { await listen() } }

    private func path(for uid: String) -> CollectionReference {
        Firestore.firestore()
            .collection("users").document(uid)
            .collection("goals").document(Goal.todayKey)
            .collection("items")
    }

    private func listen() async {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        listener = path(for: uid)
            .order(by: "createdAt")
            .addSnapshotListener { [weak self] snap, _ in
                guard let docs = snap?.documents else { return }
                self?.goals = docs.compactMap { try? $0.data(as: Goal.self) }
            }
    }

    deinit { listener?.remove() }

    func add(text: String) async throws {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let g = Goal(id: nil, text: text, isDone: false, createdAt: Date())
        try path(for: uid).addDocument(from: g)
    }

    func toggle(_ g: Goal) async {
        guard let uid = Auth.auth().currentUser?.uid, let id = g.id else { return }
        try? await path(for: uid).document(id).updateData(["isDone": !g.isDone])
    }

    func delete(_ goal: Goal) async {
        guard let uid = Auth.auth().currentUser?.uid, let id = goal.id else { return }
        try? await path(for: uid).document(id).delete()
    }
}
