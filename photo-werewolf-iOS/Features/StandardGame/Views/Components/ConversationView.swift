import SwiftUI
import Kingfisher

struct ConversationView: View {
	var gameRoom: GameRoom?
	var users: [GameUser]
	var viewModel: ConversationViewModel

	private var isOwner: Bool {
		gameRoom?.owner.userId == FirebaseAuthClient.shared.firestoreUser?.userId
	}

	var body: some View {
		ZStack {
			Color(red: 0.133, green: 0.157, blue: 0.192)
				.ignoresSafeArea()
				.navigationBarBackButtonHidden(true)
			VStack {
				Text("話し合い")
					.font(.system(size: 40, design: .rounded))
					.foregroundColor(.white)
					.fontWeight(.black)
					.padding(.bottom, 16)

				ScrollView(.horizontal, showsIndicators: false) {
					HStack {
						Spacer()
							.frame(width: 20)

						ForEach(users) { user in
							VStack {
								if let exchangePhotoUrl = user.exchangePhotoUrl {
									KFImage(URL(string: exchangePhotoUrl))
										.resizable()
										.scaledToFit()
										.frame(width: UIScreen.main.bounds.size.width - 40,
											   height: 320)
								}

								Text("\(user.name)")
									.font(.system(size: 16, design: .rounded))
									.foregroundColor(.white)
									.fontWeight(.black)
									.lineLimit(1)
							}
						}

						Spacer()
							.frame(width: 20)
					}
				}
				.padding(.bottom, 32)

				// オーナーのみ次の画面に進むボタンが押せる
				if isOwner {
					Button {
						Task {
							guard let roomId = gameRoom?.id else { return }
							// 投票画面に遷移する
							await viewModel.changeStatusToVote(roomId: roomId)
						}
					} label: {
						Text("投票へ")
							.font(.system(size: 24, design: .rounded))
							.foregroundColor(.white)
							.fontWeight(.black)
							.padding()
							.accentColor(Color.white)
							.background(Color.purple)
							.cornerRadius(32)
					}

				} else {
					Text("話し合い中")
						.font(.system(size: 24, design: .rounded))
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

struct ConversationView_Previews: PreviewProvider {
	static private var gameRoom: GameRoom = GameRoom(owner: GameUser(userId: "testUserId01", name: "テストNAME01"),
													 roomName: "テストルーム",
													 status: .conversation,
													 gameType: .standard,
													 createdAt: nil)

	static private var users: [GameUser] = [GameUser(userId: "testUserId01", name: "テストNAME01",exchangePhotoUrl: "https://placehold.jp/80x80.png"),
											GameUser(userId: "testUserId02", name: "テストNAME02",exchangePhotoUrl: "https://placehold.jp/100x100.png"),
											GameUser(userId: "testUserId03", name: "テストNAME03",exchangePhotoUrl: "https://placehold.jp/120x120.png"),
											GameUser(userId: "testUserId04", name: "テストNAME04",exchangePhotoUrl: "https://placehold.jp/150x150.png"),
											GameUser(userId: "testUserId05", name: "テストNAME05",exchangePhotoUrl: "https://placehold.jp/400x400.png")]

	static var previews: some View {
		ConversationView(gameRoom: gameRoom, users: users, viewModel: ConversationViewModel())
	}
}
