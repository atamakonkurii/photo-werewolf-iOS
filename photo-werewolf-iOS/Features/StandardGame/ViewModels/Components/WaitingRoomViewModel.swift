import Foundation

class WaitingRoomViewModel {
	func changeStatusToPhotoSelect(roomId: String) async {
		await FirestoreApiClient.shared.updateStatusGameRoom(roomId: roomId, status: .photoSelect)
	}
}
