import SwiftUI
import FirebaseStorage
import Kingfisher

struct PhotoSelectView: View {
	var gameRoom: GameRoom?
	var users: [GameUser]
	var viewModel: PhotoSelectViewModel

	@State var isShowImagePicker: Bool = false
	@State var selectedImage: UIImage?
	@State private var isLoading = false

	private func uploadImage() {
		guard let roomId = gameRoom?.id else { return }
		isLoading = true
		FirestorageApiClient.shared.uploadStandardGameUserPhoto(roomId: roomId, selectedImage: selectedImage)
		isLoading = false
	}

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
		users.allSatisfy { $0.photoUrl != nil }
	}

	var body: some View {
		ZStack {
			Color(red: 0.133, green: 0.157, blue: 0.192)
				.ignoresSafeArea()
				.navigationBarBackButtonHidden(true)

			VStack {
				Text("写真選択")
					.font(.system(size: 40, design: .rounded))
					.foregroundColor(.white)
					.fontWeight(.black)
					.padding(.bottom, 16)

				Text("自分が語りたい写真を選択してください")
					.font(.system(size: 14, design: .rounded))
					.foregroundColor(.white)
					.fontWeight(.black)

				Button {
					/// photoUrlが存在しない場合は画像選択する
					if own?.photoUrl == nil {
						isShowImagePicker = true
					}
				} label: {
					ZStack {
						if let photoUrl = own?.photoUrl, let url = URL(string: photoUrl) {
							KFImage(url)
								.resizable()
								.scaledToFit()
								.frame(width: UIScreen.main.bounds.size.width - 40,
									   height: 320)
						} else {
							Image(systemName: "photo")
								.font(.system(size: 32, design: .rounded))
								.foregroundColor(Color.white)
								.frame(width: 180, height: 240)
								.background(Color(UIColor.lightGray))

							if isLoading {
								ProgressView()
							}
						}
					}
				}
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
						Spacer(minLength: 24)

						Group {
							Text("参加者")
								.font(.system(size: 24, design: .rounded))
								.foregroundColor(.white)
								.fontWeight(.black)
								.padding(.bottom, 8)

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
						}
						.frame(maxWidth: .infinity, alignment: .leading)

						Spacer(minLength: 24)

						// オーナーのみ次の画面に進むボタンが押せる
						if isOwner, isEnableNextToScreen {
							Button {
								Task {
									guard let roomId = gameRoom?.id else { return }
									// 写真選択画面に遷移する
									await viewModel.changeStatusToRoleCheck(roomId: roomId)
								}
							} label: {
								Text("役職確認へ")
									.font(.system(size: 24, design: .rounded))
									.foregroundColor(.white)
									.fontWeight(.black)
									.padding()
									.accentColor(Color.white)
									.background(Color.purple)
									.cornerRadius(32)
							}

						} else {
							Text(isEnableNextToScreen ? "オーナーの操作待ち" : "全員の写真選択待ち")
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
			}
			.frame(width: 300)
			.sheet(isPresented: $isShowImagePicker, onDismiss: {uploadImage()}) {
				ImagePicker(image: $selectedImage)
			}
		}
	}
}





struct PhotoSelectView_Previews: PreviewProvider {
	static private var gameRoom: GameRoom = GameRoom(owner: GameUser(userId: "testUserId01", name: "テストNAME01"),
													 roomName: "テストルーム",
													 status: .photoSelect,
													 gameType: .standard)

	static private var users: [GameUser] = [GameUser(userId: "testUserId01", name: "テストNAME01"),
											GameUser(userId: "testUserId02", name: "テストNAME02"),
											GameUser(userId: "testUserId03", name: "テストNAME03"),
											GameUser(userId: "testUserId04", name: "テストNAME04"),
											GameUser(userId: "testUserId05", name: "テストNAME05")]

	static var previews: some View {
		PhotoSelectView(gameRoom: gameRoom, users: users, viewModel: PhotoSelectViewModel())
	}
}
