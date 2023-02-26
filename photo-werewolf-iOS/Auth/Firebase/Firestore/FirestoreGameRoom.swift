//
//  FirestoreMakeRoom.swift
//  photo-werewolf-iOS
//
//  Created by 太田和希 on 2023/02/17.
//

import FirebaseFirestore
import FirebaseFirestoreSwift

struct FirestoreGameRoom {
	let firestoreBase = Firestore.firestore()

	func makeRoom(roomName: String, gameType: GameType) -> String? {
		// 現在ログイン中のユーザーデータがfirestoreにあるか確認、なければ作成
		guard let user = FirebaseAuthBase.shared.firestoreUser else {
			return nil
		}

		// 部屋番号をランダム生成する
		let number = "0123456789"
		let randomNumber = String((0..<6).map { _ in number.randomElement()!})

		// roomドキュメントの作成
		let docRef = firestoreBase.collection("rooms").document(randomNumber)
		let gameRoom = GameRoom(owner: user,
								roomName: roomName,
								status: RoomStatus.waiting,
								gameType: gameType,
								createdAt: Timestamp())
		do {
			try docRef.setData(from: gameRoom)
			return randomNumber
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
