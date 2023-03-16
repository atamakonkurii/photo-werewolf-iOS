import Foundation

class PhotoSelectViewModel {
	func changeStatusToRollCheck(roomId: String) async {
		await FirestoreApiClient.shared.updateStatusGameRoom(roomId: roomId, status: .checkRoll)
	}
}
