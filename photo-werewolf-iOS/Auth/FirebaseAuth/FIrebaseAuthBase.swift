//
//  FIrebaseAuthBase.swift
//  photo-werewolf-iOS
//
//  Created by 太田和希 on 2023/01/31.
//

import FirebaseAuth
import FirebaseFirestore

struct FirebaseAuthBase {
	 func anonymousLogin() {
		// 未ログインの場合、必ず匿名ログインをする
		if Auth.auth().currentUser == nil {
			Auth.auth().signInAnonymously { _, error in
				if error != nil { return }
			}
		}
		// 現在ログイン中のユーザーデータがfirestoreにあるか確認、なければ作成
		 guard let currentUser = Auth.auth().currentUser else {
			 return
		 }

		 let docRef = Firestore.firestore().collection("users").document(currentUser.uid)

		docRef.getDocument { (document, _ ) in
			if let document = document, document.exists {
				let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
				print("Document data: \(dataDescription)")
			} else {
				print("Document does not exist")
				docRef.setData(["name": "名無し"])
			}
		}
	}

	func setDisplayName(name: String) {
		if let user = Auth.auth().currentUser {
			let request = user.createProfileChangeRequest()
			request.displayName = name
			request.commitChanges { error in
				if error == nil {
					print("名前を設定しました")
				}
			}
		}
	}
}
