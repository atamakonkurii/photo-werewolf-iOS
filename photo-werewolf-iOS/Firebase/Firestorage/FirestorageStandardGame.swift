import Foundation.NSUUID
import UIKit.UIImage

// FirestorageStandardGame
extension FirestorageApiClient {

	// POST
	func uploadStandardGameUserPhoto(roomId: String, selectedImage: UIImage?) {
		guard let image = selectedImage,
			  let data = image.jpegData(compressionQuality: 0.5),
			  let userId = FirebaseAuthClient.shared.firestoreUser?.userId else { return }

		let storageRef = storage.reference().child("standardGame/\(roomId)/\(userId)-\(UUID().uuidString).jpg")


		storageRef.putData(data, metadata: nil) { _, error in
			if let error = error {
				print("アップロードに失敗しました: \(error)")
			} else {
				storageRef.downloadURL { url, error in
					if let error = error {
						print("画像のURLの取得に失敗しました: \(error)")
					} else if let url = url{
						Task {
							await FirestoreApiClient.shared.updatePhotoUrlGameRoomUser(roomId: roomId, imageUrl: url)
						}
					}
				}
			}
		}
	}
}
