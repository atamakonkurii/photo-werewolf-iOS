//
//  GameRoomEntity.swift
//  photo-werewolf-iOS
//
//  Created by 太田和希 on 2023/03/07.
//

import FirebaseFirestore
import FirebaseFirestoreSwift

struct GameRoom: Codable {
	@DocumentID var id: String?
	var owner: User
	var roomName: String
	var status: RoomStatus
	var gameType: GameType
	@ServerTimestamp var createdAt: Timestamp?
}