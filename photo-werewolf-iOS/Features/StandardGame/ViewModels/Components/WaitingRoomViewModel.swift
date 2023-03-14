//
//  WaitingRoomViewModel.swift
//  photo-werewolf-iOS
//
//  Created by 太田和希 on 2023/02/02.
//

import Foundation

class WaitingRoomViewModel {
	func changeStatusToPhotoSelect(roomId: String) async {
		await FirestoreApiClient.shared.updateStatusGameRoom(roomId: roomId, status: .photoSelect)
	}
}
