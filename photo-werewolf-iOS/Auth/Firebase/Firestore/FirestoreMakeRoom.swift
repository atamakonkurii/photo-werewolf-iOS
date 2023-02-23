//
//  FirestoreMakeRoom.swift
//  photo-werewolf-iOS
//
//  Created by 太田和希 on 2023/02/17.
//

import FirebaseFirestore

struct FirestoreMakeRoom {
	let firestoreBase = Firestore.firestore()

	func makeRoom(roomName: String, gameType: String) {
		// 現在ログイン中のユーザーデータがfirestoreにあるか確認、なければ作成
		guard let user = FirebaseAuthBase.shared.firestoreUser else {
			return
		}

		// 部屋番号をランダム生成する
		let number = "0123456789"
		let randomNumber = String((0..<6).map { _ in number.randomElement()!})

		// roomドキュメントの作成
		let docRef = firestoreBase.collection("rooms").document(randomNumber)
		docRef.setData(["owner": "\(user.name)",
						"ownerName": "\(String(describing: user.name ))",
						"roomName": "\(roomName)",
						"status": "\(RoomStatus.waiting.rawValue)",
						"gameType": "\(gameType)",
						"createdAt": Timestamp(date: Date())])
	}

}
