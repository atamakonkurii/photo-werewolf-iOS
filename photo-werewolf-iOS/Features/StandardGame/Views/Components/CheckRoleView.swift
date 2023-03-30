//
//  ConfirmationRoleView.swift
//  photo-werewolf-iOS
//
//  Created by 太田和希 on 2022/12/08.
//

import SwiftUI

struct CheckRoleView: View {
	var gameRoom: GameRoom?
	var users: [GameUser]
	var viewModel: CheckRoleViewModel

	@State var showingPopUp = false

	private var own: GameUser? {
		get {
			guard let ownUserId = FirebaseAuthClient.shared.firestoreUser?.userId else { return nil }

			for gameUser in users {
				if gameUser.userId == ownUserId {
					return gameUser
				}
			}
			return nil
		}
	}

	private var isOwner: Bool {
		gameRoom?.owner.userId == FirebaseAuthClient.shared.firestoreUser?.userId
	}

	var body: some View {
		ZStack {
			Color(red: 0.133, green: 0.157, blue: 0.192)
				.ignoresSafeArea()
				.navigationBarBackButtonHidden(true)

			VStack {
				Text("役職確認")
					.font(.system(size: 40, design: .rounded))
					.foregroundColor(.white)
					.fontWeight(.black)
					.padding(.bottom, 16)


				ZStack {
					Rectangle()
						.fill(.clear)
						.cornerRadius(24)
						.overlay(
							RoundedRectangle(cornerRadius: 24)
								.stroke(Color(.purple), lineWidth: 1.0)
						)

					VStack {
						Button(action: {
							withAnimation {
								showingPopUp = true
							}
						}, label: {
							Text("あなたの\n役職確認")
								.font(.system(size: 24, design: .rounded))
								.foregroundColor(.white)
								.fontWeight(.black)
						})
						.padding()
						.accentColor(Color.white)
						.background(Color.purple)
						.cornerRadius(32)
						.padding(.bottom, 16)

						Group {
							Text("参加者")
								.font(.system(size: 32, design: .rounded))
								.foregroundColor(.white)
								.fontWeight(.black)
								.padding(.bottom, 8)

							VStack(alignment: .leading, spacing: 12) {

								// usersから取得したユーザーの名前を表示する
								ForEach(users) { user in
									Text("\(user.name)")
										.font(.system(size: 16, design: .rounded))
										.foregroundColor(.white)
										.fontWeight(.black)
										.lineLimit(1)
								}
							}
							.frame(maxWidth: .infinity, alignment: .leading)

							// オーナーのみ次の画面に進むボタンが押せる
							if isOwner {
								Button {
									Task {
										guard let roomId = gameRoom?.id else { return }
										// 話し合い画面に遷移する
										await viewModel.changeStatusToConversation(roomId: roomId)
									}
								} label: {
									Text("話し合いへ")
										.font(.system(size: 24, design: .rounded))
										.foregroundColor(.white)
										.fontWeight(.black)
										.padding()
										.accentColor(Color.white)
										.background(Color.purple)
										.cornerRadius(32)
								}

							} else {
								Text("オーナーの操作待ち")
									.font(.system(size: 16, design: .rounded))
									.foregroundColor(.white)
									.fontWeight(.black)
									.padding()
									.accentColor(Color.white)
									.background(Color.gray)
									.cornerRadius(32)
							}
						}
						.frame(width: 180)
					}
				}
				.frame(width: 300)
			}

			if showingPopUp {
				ConfirmationRoolPopupView(isPresent: $showingPopUp, gameRole: own?.role)
			}
		}
	}

	struct ConfirmationRoolPopupView: View {
		@Binding var isPresent: Bool
		var gameRole :StandardGameRole?

		var body: some View {
			ZStack {
				Color(red: 0.34, green: 0.4, blue: 0.49, opacity: 0.5)
					.ignoresSafeArea()
				VStack {
					if gameRole == .werewolf {
						Text("あなたは「人狼」です。\n他の人狼と写真が入れ替わります。")
							.font(.system(size: 24, design: .rounded))
							.foregroundColor(.white)
							.fontWeight(.black)
					} else if gameRole == .villager {
						Text("あなたは「市民」です。\n自分の写真について語ってください。")
							.font(.system(size: 24, design: .rounded))
							.foregroundColor(.white)
							.fontWeight(.black)
					}


					Button(action: {
						withAnimation {
							isPresent = false
						}
					}, label: {
						Text("閉じる")
							.font(.system(size: 24, design: .rounded))
							.foregroundColor(.white)
							.fontWeight(.black)
					})
					.padding()
					.accentColor(Color.white)
					.background(Color.purple)
					.cornerRadius(32)
					.padding(.bottom, 16)
				}
				.frame(width: 280, alignment: .center)
				.padding()
				.background(Color(red: 0.133, green: 0.157, blue: 0.192))
				.cornerRadius(36)
			}
		}
	}

	struct ConfirmationRoleView_Previews: PreviewProvider {
		static private var gameRoom: GameRoom = GameRoom(owner: GameUser(userId: "testUserId01", name: "テストNAME01"),
														 roomName: "テストルーム",
														 status: .checkRole,
														 gameType: .standard,
														 createdAt: nil)

		static private var users: [GameUser] = [GameUser(userId: "testUserId01", name: "テストNAME01"),
												GameUser(userId: "testUserId02", name: "テストNAME02"),
												GameUser(userId: "testUserId03", name: "テストNAME03"),
												GameUser(userId: "testUserId04", name: "テストNAME04"),
												GameUser(userId: "testUserId05", name: "テストNAME05")]

		static var previews: some View {
			CheckRoleView(gameRoom: gameRoom, users: users, viewModel: CheckRoleViewModel())
		}
	}
}
