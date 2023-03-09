//
//  WaitingRoomModel.swift
//  photo-werewolf-iOS
//
//  Created by 太田和希 on 2023/02/27.
//

import Foundation

struct WaitingRoomModel {
	let roomId: String
	var fetchState: FetchState
	var gameRoom: GameRoom? = nil
	var users: [User] = []

	init(roomId: String) {
		self.roomId = roomId
		self.fetchState = .loading
	}
}
