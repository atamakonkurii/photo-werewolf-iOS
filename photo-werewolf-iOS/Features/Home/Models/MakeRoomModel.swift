//
//  HomeModel.swift
//  photo-werewolf-iOS
//
//  Created by 太田和希 on 2023/01/31.
//

import Foundation

struct MakeRoomModel {
	var isActiveWaitingRoomView: Bool = false

	mutating func navigationWaitingRoom(gameRoom: GameRoom) {
		isActiveWaitingRoomView = true
	}
}
