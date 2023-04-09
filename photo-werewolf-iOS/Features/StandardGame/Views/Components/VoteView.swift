import SwiftUI
import Kingfisher

struct VoteView: View {
	var gameRoom: GameRoom?
	var users: [GameUser]
	var viewModel: VoteViewModel

	@State var showingPopUp = false
	@State var voteToUser: User = User(userId: "", name: "")

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

	private var isEnableNextToScreen: Bool {
		users.allSatisfy { $0.voteToUser != nil }
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
										// 自分以外に投票する
										if own?.userId != user.userId {
											voteToUser = User(userId: user.userId, name: user.name)
											showingPopUp = true
										}
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
							if user.voteToUser != nil {
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
							// 結果確認画面に遷移する
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

			if showingPopUp {
				VotePopupView(isPresent: $showingPopUp, roomId: gameRoom?.id ?? "", voteToUser: voteToUser, viewModel: viewModel)
			}
		}
	}
}

struct VotePopupView: View {
	@Binding var isPresent: Bool
	var roomId: String
	var voteToUser: User
	var viewModel: VoteViewModel

	var body: some View {
		ZStack {
			Color(red: 0.34, green: 0.4, blue: 0.49, opacity: 0.5)
				.ignoresSafeArea()
			VStack {
				Button(action: {
					withAnimation {
						isPresent = false
					}
				}, label: {
					HStack {
						Spacer()

						Image(systemName: "multiply.circle.fill")
							.font(.system(size: 30))
							.foregroundColor(.gray)
					}
				})

				Text("\(voteToUser.name)に投票しますか？")
					.font(.system(size: 24, design: .rounded))
					.foregroundColor(.white)
					.fontWeight(.black)


				Button(action: {
					Task {
						await FirestoreApiClient.shared.updateVoteToUser(roomId: roomId, voteToUser: voteToUser)
						isPresent = false
					}
				}, label: {
					Text("投票する")
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

struct VoteView_Previews: PreviewProvider {
	static private var gameRoom: GameRoom = GameRoom(owner: GameUser(userId: "testUserId01", name: "テストNAME01"),
													 roomName: "テストルーム",
													 status: .photoSelect,
													 gameType: .standard,
													 createdAt: nil)

	static private var users: [GameUser] = [GameUser(userId: "testUserId02", name: "テストNAME02",exchangePhotoUrl: "https://placehold.jp/100x100.png"),
											GameUser(userId: "testUserId01", name: "テストNAME01",exchangePhotoUrl: "https://placehold.jp/80x80.png"),

											GameUser(userId: "testUserId03", name: "テストNAME03",exchangePhotoUrl: "https://placehold.jp/120x120.png"),
											GameUser(userId: "testUserId04", name: "テストNAME04",exchangePhotoUrl: "https://placehold.jp/150x150.png"),
											GameUser(userId: "testUserId05", name: "テストNAME05",exchangePhotoUrl: "https://placehold.jp/400x400.png")]

    static var previews: some View {
		VoteView(gameRoom: gameRoom, users: users, viewModel: VoteViewModel())
    }
}
