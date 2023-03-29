import Foundation

final class CheckRoleViewModel {
	func changeStatusToConversation(roomId: String) async {
		await FirestoreApiClient.shared.updateStatusGameRoom(roomId: roomId, status: .conversation)
	}
}
