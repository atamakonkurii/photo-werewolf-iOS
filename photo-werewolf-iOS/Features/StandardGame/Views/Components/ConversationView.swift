import SwiftUI
import Kingfisher

struct ConversationView: View {
	var gameRoom: GameRoom?
	var users: [GameUser]

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

				ScrollView(.horizontal) {
					HStack {
						ForEach(users) { user in
							VStack {
								if let exchangePhotoUrl = user.exchangePhotoUrl {
									KFImage(URL(string: exchangePhotoUrl))
										.resizable()
										.scaledToFit()
										.frame(width: 180, height: 240)
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

	static private var users: [GameUser] = [GameUser(userId: "testUserId01", name: "テストNAME01",photoUrl: "https://placehold.jp/80x80.png"),
											GameUser(userId: "testUserId02", name: "テストNAME02",photoUrl: "https://placehold.jp/100x100.png"),
											GameUser(userId: "testUserId03", name: "テストNAME03",photoUrl: "https://placehold.jp/120x120.png"),
											GameUser(userId: "testUserId04", name: "テストNAME04",photoUrl: "https://placehold.jp/150x150.png"),
											GameUser(userId: "testUserId05", name: "テストNAME05",photoUrl: "https://placehold.jp/400x400.png")]

	static var previews: some View {
		ConversationView(gameRoom: gameRoom, users: users)
	}
}
