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

	func getGameRoom(roomId: String) async throws -> GameRoom? {
		try await model.getGameRoom(roomId: roomId)
	}

	func postGameRoomUser(roomId: String) async throws {
		try await model.postGameRoomUser(roomId: roomId)
	}

	func isRequireUpdate() -> Bool {
		let remoteConfig = RemoteConfigClient.shared.remoteConfig

		let requireForceUpdate = remoteConfig.configValue(forKey: "require_force_update").boolValue

		// 強制アップデートが不要な場合は早期リターン
		guard requireForceUpdate else {
			return false
		}

		guard let latestVersion = remoteConfig.configValue(forKey: "latest_version").stringValue else {
			return false
		}

		guard let currentVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String else {
			return false
		}

		/// ストアに公開されている最新バーションが今のアプリバージョンよりも新しい場合、強制アップデートをする
		if latestVersion > currentVersion  {
			/// appStoreUrlがnilの場合は強制アップデートをしない
			guard (remoteConfig.configValue(forKey: "app_store_url").stringValue != nil) else {
				return false
			}

			return true
		} else {
			return false
		}
	}
}
