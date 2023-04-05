import SwiftUI
import Kingfisher

struct VoteView: View {
	var gameRoom: GameRoom?
	var users: [GameUser]
	var viewModel: VoteViewModel

	private var isOwner: Bool {
		gameRoom?.owner.userId == FirebaseAuthClient.shared.firestoreUser?.userId
	}

	private var isEnableNextToScreen: Bool {
		users.allSatisfy { $0.photoUrl != nil }
	}

	var body: some View {
		ZStack {
			Color(red: 0.133, green: 0.157, blue: 0.192)
				.ignoresSafeArea()
				.navigationBarBackButtonHidden(true)
			VStack {
				Text("投票")
					.font(.system(size: 40, design: .rounded))
					.foregroundColor(.white)
					.fontWeight(.black)
					.padding(.bottom, 8)

				Text("写真をタップして投票してください")
					.font(.system(size: 16, design: .rounded))
					.foregroundColor(.white)
					.fontWeight(.black)
					.padding(.bottom, 16)

				ScrollView(.horizontal) {
					HStack {
						ForEach(users) { user in
							VStack {
								if let exchangePhotoUrl = user.exchangePhotoUrl {
									Button(action: {
										// この人に投票する
									}){
										KFImage(URL(string: exchangePhotoUrl))
											.resizable()
											.scaledToFit()
											.frame(width: 180, height: 240)
									}
								}

								Text("\(user.name)")
									.font(.system(size: 16, design: .rounded))
									.foregroundColor(.white)
									.fontWeight(.black)
									.lineLimit(1)
							}
						}

					}
				}
				.padding(.bottom, 32)

				VStack(alignment: .leading, spacing: 12) {

					// usersから取得したユーザーの名前を表示する
					ForEach(users) { user in
						HStack {
							if user.photoUrl != nil {
								Image(systemName: "checkmark.circle.fill")
									.font(.system(size: 16))
									.foregroundColor(.green)
							} else {
								Image(systemName: "checkmark.circle.fill")
									.font(.system(size: 16))
									.foregroundColor(.gray)
							}

							Text("\(user.name)")
								.font(.system(size: 16, design: .rounded))
								.foregroundColor(.white)
								.fontWeight(.black)
								.lineLimit(1)
						}
					}
				}

				// オーナーのみ次の画面に進むボタンが押せる
				if isOwner, isEnableNextToScreen {
					Button {
						Task {
							guard let roomId = gameRoom?.id else { return }
							// 写真選択画面に遷移する
							await viewModel.changeStatusToResult(roomId: roomId)
						}
					} label: {
						Text("結果確認へ")
							.font(.system(size: 24, design: .rounded))
							.foregroundColor(.white)
							.fontWeight(.black)
							.padding()
							.accentColor(Color.white)
							.background(Color.purple)
							.cornerRadius(32)
					}

				} else {
					Text(isEnableNextToScreen ? "オーナーの操作待ち" : "全員の投票待ち")
						.font(.system(size: 16, design: .rounded))
						.foregroundColor(.white)
						.fontWeight(.black)
						.padding()
						.accentColor(Color.white)
						.background(Color.gray)
						.cornerRadius(32)
				}
			}
		}
	}
}

struct VoteView_Previews: PreviewProvider {
	static private var gameRoom: GameRoom = GameRoom(owner: GameUser(userId: "testUserId01", name: "テストNAME01"),
													 roomName: "テストルーム",
													 status: .photoSelect,
													 gameType: .standard,
													 createdAt: nil)

	static private var users: [GameUser] = [GameUser(userId: "testUserId01", name: "テストNAME01",exchangePhotoUrl: "https://placehold.jp/80x80.png"),
											GameUser(userId: "testUserId02", name: "テストNAME02",exchangePhotoUrl: "https://placehold.jp/100x100.png"),
											GameUser(userId: "testUserId03", name: "テストNAME03",exchangePhotoUrl: "https://placehold.jp/120x120.png"),
											GameUser(userId: "testUserId04", name: "テストNAME04",exchangePhotoUrl: "https://placehold.jp/150x150.png"),
											GameUser(userId: "testUserId05", name: "テストNAME05",exchangePhotoUrl: "https://placehold.jp/400x400.png")]

    static var previews: some View {
        VoteView(gameRoom: gameRoom, users: users, viewModel: VoteViewModel())
    }
}
