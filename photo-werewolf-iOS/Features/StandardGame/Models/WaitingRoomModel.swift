//
//  WaitingRoomModel.swift
//  photo-werewolf-iOS
//
//  Created by 太田和希 on 2023/02/27.
//

import Foundation

class WaitingRoomModel {
	let roomId: String
	var fetchState: FetchState
	var gameRoom: GameRoom? = nil

	init(roomId: String) {
		self.roomId = roomId
		self.fetchState = .loading
		subscriptionRoom(roomId: roomId)
	}

	func subscriptionRoom(roomId: String) {
		FirestoreApiClient.shared.subscriptionRoom(roomId: roomId) { result in
			if let gameRoom = result {
				self.gameRoom = gameRoom
				print("sucess:\(String(describing: self.gameRoom))")
			} else {
				self.gameRoom = nil
				print("fail:\(String(describing: self.gameRoom))")
			}
		}
	}
}
