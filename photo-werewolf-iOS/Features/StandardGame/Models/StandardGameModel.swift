//
//  StandardGameModel.swift
//  photo-werewolf-iOS
//
//  Created by 太田和希 on 2023/03/14.
//

import Foundation

struct StandardGameModel {
	let roomId: String
	var gameRoom: GameRoom? = nil
	var users: [User] = []

	init(roomId: String) {
		self.roomId = roomId
	}
}
