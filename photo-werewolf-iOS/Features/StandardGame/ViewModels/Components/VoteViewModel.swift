import Foundation
import FirebaseFunctions

final class VoteViewModel {
	lazy var functions = Functions.functions(region:"asia-northeast1")
	
	func changeStatusToResult(roomId: String) async {
		await FirestoreApiClient.shared.updateStatusGameRoom(roomId: roomId, status: .result)

		// 結果を計算する
		functions.httpsCallable("standardGameCalculateResult").call(["gameRoomId": roomId]) { (_, error) in
			if let error = error  {
				print("error:\(error)")
			}
		}
	}
}
