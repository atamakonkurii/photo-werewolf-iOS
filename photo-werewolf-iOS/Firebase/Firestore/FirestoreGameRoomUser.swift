import FirebaseFirestore
import FirebaseFirestoreSwift

// FirestoreGameRoomUser
extension FirestoreApiClient {

	/// GET
	func subscriptionRoomUsers(roomId: String, completion: @escaping ([GameUser]?) -> Void) {
		db.collection("rooms").document(roomId)
			.collection("gameUsers")
			.addSnapshotListener { documentSnapshot, error in
				guard let documents = documentSnapshot?.documents else {
					print("Error fetching document: \(error!)")
					completion(nil)
					return
				}

				do {
					let users = try documents.compactMap {
						return try $0.data(as: GameUser.self)
					}
					completion(users)
					return
				} catch {
					print("error")
					completion(nil)
					return
				}
			}
	}

	/// POST
	func postGameRoomUser(roomId: String) async throws {
		guard let user = FirebaseAuthClient.shared.firestoreUser else { return }
		guard let userId = user.id  else { return }

		let docRef = db.collection("rooms").document(roomId)
		let gameUser: GameUser = GameUser(userId: user.userId, name: user.name, photoUrl: nil)

		try docRef.collection("gameUsers").document(userId).setData(from: gameUser)
	}

	func updatePhotoUrlGameRoomUser(roomId: String, imageUrl: URL) async {
		guard let user = FirebaseAuthClient.shared.firestoreUser else { return }
		guard let userId = user.id  else { return }

		let docRef = db.collection("rooms").document(roomId)

		do {
			try await docRef.collection("gameUsers").document(userId).updateData(["photoUrl": "\(imageUrl)"])
		} catch {
			print(error)
		}
	}

	func updateVoteToUser(roomId: String, voteToUser: User) async {
		guard let user = FirebaseAuthClient.shared.firestoreUser else { return }
		guard let userId = user.id  else { return }

		let docRef = db.collection("rooms").document(roomId)

		do {
			try await docRef.collection("gameUsers").document(userId).updateData(["voteToUser": voteToUser])
		} catch {
			print(error)
		}
	}
}
