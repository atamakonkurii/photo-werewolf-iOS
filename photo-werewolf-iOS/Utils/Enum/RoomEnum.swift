//
//  GameType.swift
//  photo-werewolf-iOS
//
//  Created by 太田和希 on 2023/02/21.
//

import Foundation

enum GameType: String, Codable {
	case standard
}

enum StandardGameRoomStatus: String, Codable {
	case waiting
	case photoSelect
	case checkRole
	case conversation
	case vote
	case result
	case done
}

enum StandardGameRole: String, Codable {
	case villager
	case werewolf
}

enum GameResult: String, Codable {
	case win
	case lose
}
