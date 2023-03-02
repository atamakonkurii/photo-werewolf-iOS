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

	func subscriptionRoom(roomId: String, completion: @escaping (GameRoom?) -> Void) {
		let litener = db.collection("rooms").document(roomId)
			.addSnapshotListener { documentSnapshot, error in
				guard let document = documentSnapshot else {
					print("Error fetching document: \(error!)")
					completion(nil)
					return
				}

				// addSnapshotListenerを使っても,Codableの形で取り出せるようにしたい
				do {
					let gameRoom = try document.data(as: GameRoom.self)
					completion(gameRoom)
				} catch {
					print("error")
					completion(nil)
					return
				}
			}
	}

	func postRoom(roomName: String, gameType: GameType) -> String? {
		// 現在ログイン中のユーザーデータがfirestoreにあるか確認、なければ作成
		guard let user = FirebaseAuthClient.shared.firestoreUser else {
			return nil
		}

		// 部屋番号をランダム生成する
		let number = "0123456789"
		let roomId = String((0..<6).map { _ in number.randomElement()!})

		// roomドキュメントの作成
		let docRef = db.collection("rooms").document(roomId)
		let gameRoom = GameRoom(owner: user,
								roomName: roomName,
								status: RoomStatus.waiting,
								gameType: gameType,
								createdAt: Timestamp())
		do {
			try docRef.setData(from: gameRoom)
			return roomId
		} catch {
			print(error)
			return nil
		}
	}
}

struct GameRoom: Codable {
	@DocumentID var id: String?
	var owner: FirestoreUser
	var roomName: String
	var status: RoomStatus
	var gameType: GameType
	@ServerTimestamp var createdAt: Timestamp?
}
