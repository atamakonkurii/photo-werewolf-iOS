import SwiftUI

struct WaitingRoomView: View {
	let MAX_USER_COUNT = 8
	let IS_ENABLE_STRAT_USER_COUNT = 5

	var viewModel: WaitingRoomViewModel
	var gameRoom: GameRoom?
	var users: [GameUser]
	var roomId: String
	@Environment(\.dismiss) var dismiss

	private var isOwner: Bool {
		gameRoom?.owner.userId == FirebaseAuthClient.shared.firestoreUser?.userId
	}

	private var isEnableNextToScreen: Bool {
		users.count >= IS_ENABLE_STRAT_USER_COUNT
	}

	var body: some View {
		ZStack {
			Color(red: 0.133, green: 0.157, blue: 0.192)
				.ignoresSafeArea()
				.navigationBarBackButtonHidden(true)
				.toolbar {
					ToolbarItem(placement: .navigationBarLeading) {
						Button(
							action: {
								dismiss()
							}, label: {
								Text("部屋を出る")
									.font(.system(size: 16, design: .rounded))
									.foregroundColor(.gray)
									.fontWeight(.black)
							}
						)
						.tint(.orange)
					}
				}

			VStack {
				ZStack {
					Rectangle()
						.fill(.clear)
						.cornerRadius(24)
						.overlay(
							RoundedRectangle(cornerRadius: 24)
								.stroke(Color(.orange), lineWidth: 1.0)
						)

					VStack {
						if let roomName = gameRoom?.roomName {
							Text("\(roomName)")
								.font(.system(size: 32, design: .rounded))
								.foregroundColor(.white)
								.fontWeight(.black)
								.padding(.bottom, 8)
						} else {
							Text("写真人狼部屋")
								.font(.system(size: 32, design: .rounded))
								.foregroundColor(.white)
								.fontWeight(.black)
								.padding(.bottom, 8)
						}


						HStack(alignment: .bottom) {
							Text("部屋コード")
								.font(.system(size: 16, design: .rounded))
								.foregroundColor(.white)
								.fontWeight(.black)

							Button(
								action: {
									sharePost(shareText: "iOS-Docs", shareUrl: "https://ios-docs.dev")
								}, label: {
									Image(systemName: "square.and.arrow.up.fill")
										.font(.system(size: 30))
										.foregroundColor(.gray)
								}
							)
						}

						Button(action: {
							UIPasteboard.general.string = "\(roomId)"
						}, label: {
							ZStack {
								RoundedRectangle(cornerRadius: 24)
									.fill(.white)
									.frame(width: 196, height: 64)
								HStack {
									Text("# ")
										.font(.system(size: 32, design: .rounded))
										.foregroundColor(.gray)
										.fontWeight(.black)

									Text("\(roomId)")
										.font(.system(size: 32, design: .rounded))
										.foregroundColor(.black)
										.fontWeight(.black)
								}

							}
						})
					}
				}
				.frame(width: 300, height: 200)
				
				Spacer(minLength: 24)

				ZStack {
					Rectangle()
						.fill(.clear)
						.cornerRadius(24)
						.overlay(
							RoundedRectangle(cornerRadius: 24)
								.stroke(Color(.orange), lineWidth: 1.0)
						)

					VStack {

						Spacer(minLength: 24)

						Group {
							HStack(alignment: .bottom) {
								Text("参加者")
									.font(.system(size: 24, design: .rounded))
									.foregroundColor(.white)
									.fontWeight(.black)
								Text("\(String(IS_ENABLE_STRAT_USER_COUNT))人~\(String(MAX_USER_COUNT))人")
									.font(.system(size: 12, design: .rounded))
									.foregroundColor(.gray)
									.fontWeight(.medium)
							}

							Text("\(String(IS_ENABLE_STRAT_USER_COUNT))人集まったらスタートできます")
								.font(.system(size: 12, design: .rounded))
								.foregroundColor(.gray)
								.fontWeight(.medium)
								.padding(.bottom, 8)

							VStack(alignment: .leading, spacing: 8) {

								// usersから取得したユーザーの名前を表示する
								ForEach(users) { user in
									Text("\(user.name)")
										.font(.system(size: 16, design: .rounded))
										.foregroundColor(.white)
										.fontWeight(.black)
										.lineLimit(1)
								}

								// スケルトンスクリーンを表示
								ForEach(0..<( MAX_USER_COUNT - users.count ), id: \.self) { _ in
									Rectangle()
										.fill(.gray)
										.frame(height: 24)
								}
							}
						}
						.frame(maxWidth: .infinity, alignment: .leading)

						Spacer(minLength: 24)

						// オーナーのみスタートボタンが押せる
						if isOwner, isEnableNextToScreen {
							Button {
								Task {
									// 写真選択画面に遷移する
									await viewModel.changeStatusToPhotoSelect(roomId: roomId)
								}
							} label: {
								Text("スタート")
									.font(.system(size: 24, design: .rounded))
									.foregroundColor(.white)
									.fontWeight(.black)
									.padding()
									.accentColor(Color.white)
									.background(Color.orange)
									.cornerRadius(32)
							}

						} else {
							Text(isEnableNextToScreen ? "オーナーの操作待ち" : "\(String(IS_ENABLE_STRAT_USER_COUNT))人からスタートできます")
								.font(.system(size: 16, design: .rounded))
								.foregroundColor(.white)
								.fontWeight(.black)
								.padding()
								.accentColor(Color.white)
								.background(Color.gray)
								.cornerRadius(32)
						}

						Spacer(minLength: 24)
					}
					.frame(width: 180)
				}
				.frame(width: 300)

				Spacer(minLength: 50)
			}
		}
	}

	func sharePost(shareText: String, shareUrl: String) {
		let activityItems = [shareText, URL(string: shareUrl)!] as [Any]
		let activityVC = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
		let viewController = UIApplication.shared.windows.first?.rootViewController
		viewController?.present(activityVC, animated: true)
	}
}

struct WaitingRoomView_Previews: PreviewProvider {
	static private var gameRoom: GameRoom = GameRoom(owner: GameUser(userId: "testUserId01", name: "テストNAME01"),
													 roomName: "テストルーム",
													 status: .waiting,
													 gameType: .standard,
													 createdAt: nil)
	static private var users: [GameUser] = [GameUser(userId: "testUserId01", name: "テストNAME01"),
											GameUser(userId: "testUserId02", name: "テストNAME02"),
											GameUser(userId: "testUserId03", name: "テストNAME03"),
											GameUser(userId: "testUserId04", name: "テストNAME04"),
											GameUser(userId: "testUserId05", name: "テストNAME05")]
	static private var roomId: String = "111112"

	static var previews: some View {
		WaitingRoomView(viewModel: WaitingRoomViewModel(), gameRoom: gameRoom, users: users, roomId: roomId)
	}
}
