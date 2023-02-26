//
//  path.swift
//  photo-werewolf-iOS
//
//  Created by 太田和希 on 2023/02/25.
//

import Foundation

enum NavigationPath: Hashable {
	case homeView
	case waitingRoom(roomNumber: String)
	case photoSelect
	case confirmationRoll
}
