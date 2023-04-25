//
//  FIrebaseAuthBase.swift
//  photo-werewolf-iOS
//
//  Created by 太田和希 on 2023/01/31.
//

import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift

final public class FirebaseAuthClient: ObservableObject {
	public static let shared = FirebaseAuthClient()
	@Published var firestoreUser: User?

	private init() {}

	func anonymousLogin() {
		// 未ログインの場合、必ず匿名ログインをする
		if Auth.auth().currentUser == nil {
			Auth.auth().signInAnonymously { _, error in
				self.setFirestoreUser()
				if error != nil { print("error:\(String(describing: error))") }
			}
		} else {
			setFirestoreUser()
		}
	}

	func setFirestoreUser() {
		// 現在ログイン中のユーザーデータがfirestoreにあるか確認、なければ作成
		guard let user = Auth.auth().currentUser else {
			print("currentUserが存在しません")
			return
		}
		let docRef = FirestoreApiClient.shared.db.collection("users").document(user.uid)

		docRef.getDocument(as: User.self) { result in
			switch result {
			case .success(let firestoreUser):
				self.firestoreUser = firestoreUser
			case .failure(let error):
				switch error {
				case DecodingError.valueNotFound(_, _):
					print("ユーザーが存在しないので新規作成")
					self.firestoreUser = User(userId: user.uid, name: "名無し")
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

	func setDisplayName(name: String) async {
		if let user = Auth.auth().currentUser {
			let docRef = FirestoreApiClient.shared.db.collection("users").document(user.uid)
			do {
				try await docRef.updateData(["name": "\(name)"])
				setFirestoreUser()
			} catch {
				print(error)
			}
		}
	}
}
