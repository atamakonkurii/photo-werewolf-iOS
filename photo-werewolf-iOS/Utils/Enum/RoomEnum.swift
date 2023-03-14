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

enum RoomStatus: String, Codable {
	case waiting
	case photoSelect
	case rollCheck
	case conversation
	case vote
	case result
	case done
}
