//
//  HomeViewModel.swift
//  photo-werewolf-iOS
//
//  Created by 太田和希 on 2023/01/31.
//

import Foundation

@MainActor
class HomeViewModel: ObservableObject {
	@Published var model: HomeModel

	init(model: HomeModel) {
		self.model = model
	}

	/// Getter

	var showingMakeRoomPopUp: Bool {
		get {
			return model.showingMakeRoomPopUp
		}
		set {
			model.showingMakeRoomPopUp = newValue
		}
	}

	var showingNameChangePopUp: Bool {
		get {
			return model.showingNameChangePopUp
		}
		set {
			model.showingNameChangePopUp = newValue
		}
	}
}
