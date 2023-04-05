import Foundation

final class ConversationViewModel {
	func changeStatusToVote(roomId: String) async {
		await FirestoreApiClient.shared.updateStatusGameRoom(roomId: roomId, status: .vote)
	}
}
