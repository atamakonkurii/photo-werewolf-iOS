import SwiftUI
import Kingfisher

struct ResultView: View {
	var gameRoom: GameRoom?
	var users: [GameUser]

	var body: some View {
		ZStack {
			Color(red: 0.133, green: 0.157, blue: 0.192)
				.ignoresSafeArea()
				.navigationBarBackButtonHidden(true)

			VStack {
				Text("結果発表")
					.font(.system(size: 40, design: .rounded))
					.foregroundColor(.white)
					.fontWeight(.black)
					.padding(.bottom, 8)


				ForEach(users) { user in
					HStack {
						if user.role == .werewolf {
							Text("人狼：\(user.name)")
								.font(.system(size: 16, design: .rounded))
								.foregroundColor(.white)
								.fontWeight(.black)

						} else if user.role == .villager {
							Text("市民：\(user.name)")
								.font(.system(size: 16, design: .rounded))
								.foregroundColor(.white)
								.fontWeight(.black)
						}

						if user.result == .win {
							Text("勝ち")
								.font(.system(size: 16, design: .rounded))
								.foregroundColor(.white)
								.fontWeight(.black)
						} else if user.result == .lose {
							Text("負け")
								.font(.system(size: 16, design: .rounded))
								.foregroundColor(.white)
								.fontWeight(.black)
						} else {
							Text("結果待ち")
								.font(.system(size: 16, design: .rounded))
								.foregroundColor(.white)
								.fontWeight(.black)
						}
					}
				}
			}
		}
	}
}


struct ResultView_Previews: PreviewProvider {
	static private var gameRoom: GameRoom = GameRoom(owner: GameUser(userId: "testUserId01", name: "テストNAME01"),
													 roomName: "テストルーム",
													 status: .photoSelect,
													 gameType: .standard,
													 createdAt: nil)

	static private var users: [GameUser] = [GameUser(userId: "testUserId02", name: "テストNAME02",exchangePhotoUrl: "https://placehold.jp/100x100.png", role: .werewolf, result: .win),
											GameUser(userId: "testUserId01", name: "テストNAME01",exchangePhotoUrl: "https://placehold.jp/80x80.png"),

											GameUser(userId: "testUserId03", name: "テストNAME03",exchangePhotoUrl: "https://placehold.jp/120x120.png"),
											GameUser(userId: "testUserId04", name: "テストNAME04",exchangePhotoUrl: "https://placehold.jp/150x150.png"),
											GameUser(userId: "testUserId05", name: "テストNAME05",exchangePhotoUrl: "https://placehold.jp/400x400.png")]

    static var previews: some View {
		ResultView(gameRoom: gameRoom, users: users)
    }
}
