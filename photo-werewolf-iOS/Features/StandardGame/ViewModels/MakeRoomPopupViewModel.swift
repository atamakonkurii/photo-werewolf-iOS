//
//  MakeRoomPopupViewModel.swift
//  photo-werewolf-iOS
//
//  Created by 太田和希 on 2023/02/15.
//

import Foundation

@MainActor
class MakeRoomViewModel: ObservableObject {
	@Published var model: MakeRoomModel

	init(model: MakeRoomModel) {
		self.model = model
	}

	func navigationWaitingRoom() {
		model.navigationWaitingRoom()
	}

	var isActiveWaitingRoomView: Bool {
		get {
			return model.isActiveWaitingRoomView
		}
		set {
			model.isActiveWaitingRoomView = newValue
		}
	}
}
