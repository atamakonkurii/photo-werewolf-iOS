//
//  HomeModel.swift
//  photo-werewolf-iOS
//
//  Created by 太田和希 on 2023/01/31.
//
import Foundation

struct HomeModel {
	var showingMakeRoomPopUp: Bool = false
	var showingNameChangePopUp: Bool = false

	func getGameRoom(roomId: String) async throws -> GameRoom? {
		let gameRoom = try await FirestoreApiClient.shared.getGameRoom(roomId: roomId)
		print("gameRoom")
		print("\(String(describing: gameRoom))")
		return gameRoom
	}

	func postGameRoomUser(roomId: String) async throws {
		try await FirestoreApiClient.shared.postGameRoomUser(roomId: roomId)
	}
}
