import Foundation
import FirebaseFunctions

final class PhotoSelectViewModel {
	lazy var functions = Functions.functions(region:"asia-northeast1")

	func changeStatusToRoleCheck(roomId: String) async {
		// 部屋のステータスを役職確認に変更する
		await FirestoreApiClient.shared.updateStatusGameRoom(roomId: roomId, status: .checkRole)

		// 人狼の写真を交換する
		functions.httpsCallable("standardGameExchangePhotoUrl").call(["gameRoomId": roomId]) { (_, error) in
			if let error = error  {
				print("error:\(error)")
			}
		}
	}
}
