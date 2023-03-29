import Foundation
import FirebaseFunctions

class WaitingRoomViewModel {
	lazy var functions = Functions.functions(region:"asia-northeast1")

	func changeStatusToPhotoSelect(roomId: String) async {
		await FirestoreApiClient.shared.updateStatusGameRoom(roomId: roomId, status: .photoSelect)

		functions.httpsCallable("standardGameAssignRoles").call(["gameRoomId": roomId]) { (_, error) in
			if let error = error  {
				print("error:\(error)")
			}
		}
	}
}
