import Foundation

final class PhotoSelectViewModel {
	func changeStatusToRoleCheck(roomId: String) async {
		await FirestoreApiClient.shared.updateStatusGameRoom(roomId: roomId, status: .checkRole)
	}
}
