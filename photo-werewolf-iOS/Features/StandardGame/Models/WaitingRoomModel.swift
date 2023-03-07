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
	var users: [User] = []

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
				// Roomの情報が取れたらUserの情報を取得しにいく
				self.subscriptionRoomUsers(roomId: roomId)
			} else {
				self.gameRoom = nil
				print("fail:\(String(describing: self.gameRoom))")
			}
		}
	}

	func subscriptionRoomUsers(roomId: String) {
		FirestoreApiClient.shared.subscriptionRoomUsers(roomId: roomId) { result in
			if let users = result {
				self.users = users
				print("sucess:\(String(describing: self.users))")
			} else {
				self.users = []
				print("fail:\(String(describing: self.users))")
			}
		}
	}
}
