import Foundation
import FirebaseFunctions

class WaitingRoomViewModel {
	lazy var functions = Functions.functions(region:"asia-northeast1")

	func changeStatusToPhotoSelect(roomId: String) async {
		// 部屋のステータスを写真選択中に変更する
		await FirestoreApiClient.shared.updateStatusGameRoom(roomId: roomId, status: .photoSelect)

		// ロールを割り振る
		functions.httpsCallable("standardGameAssignRoles").call(["gameRoomId": roomId]) { (_, error) in
			if let error = error  {
				print("error:\(error)")
			}
		}
	}
}
