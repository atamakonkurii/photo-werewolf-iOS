//
//  WaitingRoomViewModel.swift
//  photo-werewolf-iOS
//
//  Created by 太田和希 on 2023/02/02.
//

import Foundation

@MainActor
class WaitingRoomViewModel: ObservableObject {
	@Published var model: WaitingRoomModel

	init(model: WaitingRoomModel) {
		self.model = model
		subscriptionGameRoom(roomId: model.roomId)
	}

	var roomId: String {
		return model.roomId
	}

	var fetchState: FetchState {
		get {
			return model.fetchState
		}
		set {
			model.fetchState = newValue
		}
	}

	var gameRoom: GameRoom? {
		get {
			return model.gameRoom
		}
		set {
			model.gameRoom = newValue
		}
	}

	var users: [User] {
		get {
			return model.users
		}
		set {
			model.users = newValue
		}
	}

	func subscriptionGameRoom(roomId: String) {
		FirestoreApiClient.shared.subscriptionRoom(roomId: roomId) { result in
			if let gameRoom = result {
				self.gameRoom = gameRoom
				print("GameRoom:sucess:\(String(describing: self.gameRoom))")
				// Roomの情報が取れたらUserの情報を取得しにいく
				self.subscriptionGameRoomUsers(roomId: roomId)
			} else {
				self.gameRoom = nil
				print("fail:\(String(describing: self.gameRoom))")
			}
		}
	}

	func subscriptionGameRoomUsers(roomId: String) {
		FirestoreApiClient.shared.subscriptionRoomUsers(roomId: roomId) { result in
			if let users = result {
				self.users = users
				print("User:sucess:\(String(describing: self.users))")
			} else {
				self.users = []
				print("fail:\(String(describing: self.users))")
			}
		}
	}
}
