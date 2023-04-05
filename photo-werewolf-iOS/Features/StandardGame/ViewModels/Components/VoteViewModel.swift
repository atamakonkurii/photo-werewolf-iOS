import Foundation

final class VoteViewModel {
	func changeStatusToResult(roomId: String) async {
		await FirestoreApiClient.shared.updateStatusGameRoom(roomId: roomId, status: .result)
	}
}
