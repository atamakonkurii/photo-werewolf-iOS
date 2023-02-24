//
//  FIrebaseAuthBase.swift
//  photo-werewolf-iOS
//
//  Created by 太田和希 on 2023/01/31.
//

import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift

final public class FirebaseAuthBase {
	public static let shared = FirebaseAuthBase()
	var firestoreUser: FirestoreUser?

	let currentUser = Auth.auth().currentUser

	private init() {}

	func anonymousLogin() {
		// 未ログインの場合、必ず匿名ログインをする
		if currentUser == nil {
			Auth.auth().signInAnonymously { _, error in
				if error != nil { return }
			}
		}

		setFirestoreUser()
	}

	func setFirestoreUser() {
		// 現在ログイン中のユーザーデータがfirestoreにあるか確認、なければ作成
		guard let user = currentUser else {
			return
		}
		let docRef = Firestore.firestore().collection("users").document(user.uid)

		docRef.getDocument(as: FirestoreUser.self) { result in
			switch result {
			case .success(let firestoreUser):
				self.firestoreUser = firestoreUser
			case .failure(let error):
				switch error {
				case DecodingError.valueNotFound(_, _):
					print("ユーザーが存在しないので新規作成")
					self.firestoreUser = FirestoreUser(userId: user.uid, name: "名無し")
					do {
						try docRef.setData(from: self.firestoreUser)
					}
					catch {
						print(error)
					}
				default:
					print("error:\(error)")
				}
			}
		}


	}

	func setDisplayName(name: String) {
		if let user = currentUser {
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

// firestoreのユーザーデータを格納する構造体
struct FirestoreUser: Codable {
	@DocumentID var id: String?
	var userId: String
	var name: String
}
