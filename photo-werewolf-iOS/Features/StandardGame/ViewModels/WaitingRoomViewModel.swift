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
}
