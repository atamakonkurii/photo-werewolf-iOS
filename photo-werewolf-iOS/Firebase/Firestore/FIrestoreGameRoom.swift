//
//  FIrestoreRoom.swift
//  photo-werewolf-iOS
//
//  Created by 太田和希 on 2023/03/02.
//

import FirebaseFirestore
import FirebaseFirestoreSwift

// FirestoreGameRoom
extension FirestoreApiClient {

	// GET
	func getGameRoom(roomId: String) async throws -> GameRoom? {
		let gameRoom = try await db.collection("rooms").document(roomId).getDocument(as: GameRoom.self)
		return gameRoom
	}

	func subscriptionRoom(roomId: String, completion: @escaping (GameRoom?) -> Void) {
		db.collection("rooms").document(roomId)
			.addSnapshotListener { documentSnapshot, error in
				guard let document = documentSnapshot else {
					print("Error fetching document: \(error!)")
					completion(nil)
					return
				}

				do {
					let gameRoom = try document.data(as: GameRoom.self)
					completion(gameRoom)
					return
				} catch {
					print("error")
					completion(nil)
					return
				}
			}
	}

	/// POST
	func postGameRoom(roomName: String, gameType: GameType) async -> String? {
		// 現在ログイン中のユーザー取得
		guard let user = FirebaseAuthClient.shared.firestoreUser else {
			return nil
		}

		// 部屋番号をランダム生成する
		let number = "0123456789"
		let roomId = String((0..<6).map { _ in number.randomElement()!})

		let gameUser: GameUser = GameUser(userId: user.userId, name: user.name, photoUrl: nil)

		// roomドキュメントの作成
		let docRef = db.collection("rooms").document(roomId)
		let gameRoom = GameRoom(owner: gameUser,
								roomName: roomName,
								status: RoomStatus.waiting,
								gameType: gameType,
								createdAt: Timestamp())
		do {
			try docRef.setData(from: gameRoom)
			try await postGameRoomUser(roomId: roomId)
			return roomId
		} catch {
			print(error)
			return nil
		}
	}

	func updateStatusGameRoom(roomId: String, status: RoomStatus) async {
		let docRef = db.collection("rooms").document(roomId)

		do {
			try await docRef.updateData(["status": "\(status.rawValue)"])
		} catch {
			print(error)
		}
	}
}
