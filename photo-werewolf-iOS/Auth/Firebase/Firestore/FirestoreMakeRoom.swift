//
//  FirestoreMakeRoom.swift
//  photo-werewolf-iOS
//
//  Created by 太田和希 on 2023/02/17.
//

import FirebaseFirestore

struct FirestoreMakeRoom {
	let firestoreBase = Firestore.firestore()

	func makeRoom() {
		// 現在ログイン中のユーザーデータがfirestoreにあるか確認、なければ作成
		guard let user = FirebaseAuthBase().currentUser else {
			return
		}

		let docRef = firestoreBase.collection("rooms").document(user.uid)
		docRef.setData(["test": "テスト"])
	}

}
