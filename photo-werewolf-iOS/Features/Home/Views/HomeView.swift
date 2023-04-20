//
//  HomeView.swift
//  photo-werewolf-iOS
//
//  Created by 太田和希 on 2022/11/16.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct HomeView: View {
	@StateObject var viewModel: HomeViewModel
	@StateObject var firebaseAuth: FirebaseAuthClient

	@State private var navigationPath: [NavigationPath] = []

	@State private var roomIdText: String = ""
	@State private var isAlert: Bool = false

	var body: some View {
		NavigationStack(path: $navigationPath) {
			ZStack {
				Color(red: 0.133, green: 0.157, blue: 0.192)
					.ignoresSafeArea()
				VStack {
					HStack(alignment: .top) {
						Spacer()

						Image(systemName: "person.fill")
							.font(.system(size: 24))
							.foregroundColor(.white)

						Button(action: {
							withAnimation {
								viewModel.showingNameChangePopUp = true
							}
						}, label: {
							Text("\(firebaseAuth.firestoreUser?.name ?? "ななし")")
								.font(.system(size: 24, design: .rounded))
								.foregroundColor(.white)
								.fontWeight(.medium)
								.padding(.trailing, 32)
						})
					}
					.padding(.top, 32)

					Spacer()

					Text("写真人狼")
						.font(.system(size: 64, design: .rounded))
						.foregroundColor(.white)
						.fontWeight(.black)

					Image("photo_werewolf_icon")
						.resizable()
						.scaledToFit()
						.frame(width: 300, height: 150)

					Text("コードを入力して部屋に入る")
						.font(.system(size: 16, design: .rounded))
						.foregroundColor(.white)
						.fontWeight(.black)

					TextField("# _ _ _ _ _", text: $roomIdText,
							onCommit: {
								// 部屋が存在していた時だけ待機部屋に進む
								Task {

									// 強制アップデートが必要な場合はダイアログを表示し早期リターン
									guard !viewModel.isRequireUpdate() else {
										isAlert = true
										return
									}


									// 空文字の場合早期リターン
									guard !roomIdText.isEmpty else {
										return
									}

									// 部屋を取得
									let gameRoom = try await viewModel.getGameRoom(roomId: roomIdText)

									// 存在判定
									guard gameRoom != nil else {
										return
									}

									// gameRoomがwaitingでないと参加できない
									guard gameRoom?.status == .waiting  else {
										return
									}

									// 部屋にユーザーを追加
									try await viewModel.postGameRoomUser(roomId: roomIdText)


									// ゲーム画面に遷移
									navigationPath.append(.standardGame(roomId: roomIdText))

									// roomIdTextのリセット
									roomIdText = ""
								}
							}
						)
						.textFieldStyle(RoundedBorderTextFieldStyle())
						.font(.system(size: 32))
						.frame(width: 200.0)
						.padding()
						.multilineTextAlignment(.center)

					Text("もしくは")
						.font(.system(size: 16, design: .rounded))
						.foregroundColor(.white)
						.fontWeight(.black)

					Button(action: {
						withAnimation {
							// 強制アップデートが必要な場合はダイアログを表示し早期リターン
							guard !viewModel.isRequireUpdate() else {
								isAlert = true
								return
							}
							viewModel.showingMakeRoomPopUp = true
						}
					}, label: {
						Text("部屋をつくる")
							.font(.system(size: 24, design: .rounded))
							.foregroundColor(.white)
							.fontWeight(.black)
					})
					.padding()
					.accentColor(Color.white)
					.background(Color.orange)
					.cornerRadius(32)

					Spacer()
				}
				.alert("アップデートが必要です", isPresented: $isAlert, actions: {
					if let appStoreUrl = RemoteConfigClient.shared.remoteConfig.configValue(forKey: "app_store_url").stringValue, (URL(string: appStoreUrl) != nil) {
						Link("ストアを開く", destination: URL(string: appStoreUrl)!)
					}
				})

				if viewModel.showingNameChangePopUp {
					NameChangePopupView(isPresent: $viewModel.showingNameChangePopUp)
				}

				if viewModel.showingMakeRoomPopUp {
					MakeRoomPopupView(isPresent: $viewModel.showingMakeRoomPopUp, navigationPath: $navigationPath, viewModel: MakeRoomViewModel(model: MakeRoomModel()))
				}
			}
			.navigationDestination(for: NavigationPath.self) { destination in
				// TODO: 各Viewの画面遷移の実装を置き換える
				switch destination {
				case .standardGame(let roomId):
					StandardGameView(viewModel: StandardGameViewModel(model: StandardGameModel(roomId: roomId)), navigationPath: $navigationPath)
				case .homeView:
					EmptyView()
				}
			}
		}
		.onAppear {
			// ログインしていない場合は匿名ログインをする
			FirebaseAuthClient.shared.anonymousLogin()

			// RemoteConfigの値を監視する
			RemoteConfigClient.shared.subscription()
		}
	}
}

struct HomeView_Previews: PreviewProvider {
	static var previews: some View {
		HomeView(viewModel: HomeViewModel(model: HomeModel()), firebaseAuth: FirebaseAuthClient.shared)
	}
}
