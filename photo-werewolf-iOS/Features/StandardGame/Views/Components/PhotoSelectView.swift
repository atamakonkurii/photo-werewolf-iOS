import SwiftUI

struct PhotoSelectView: View {
	var gameRoom: GameRoom?
	var users: [GameUser]

	@State var selectedImage: UIImage?
	@State var showingAlert: Bool = false

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
					showingAlert = true
				} label: {
					if let image = selectedImage {
						Image(uiImage: image)
							.resizable()
							.frame(width: 180, height: 240)
					} else {
						Image(systemName: "photo")
							.font(.system(size: 32, design: .rounded))
							.foregroundColor(Color.white)
							.frame(width: 180, height: 240)
							.background(Color(UIColor.lightGray))
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
												.font(.system(size: 24))
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

						NavigationLink(destination: ConfirmationRollView()) {
							Text("役職確認へ")
								.font(.system(size: 24, design: .rounded))
								.foregroundColor(.white)
								.fontWeight(.black)
						}
						.padding()
						.accentColor(Color.white)
						.background(Color.purple)
						.cornerRadius(32)

						Spacer(minLength: 24)
					}
					.frame(width: 180)
				}
			}
			.frame(width: 300)
			.sheet(isPresented: $showingAlert) { //onDismissで画像アップロードの関数を呼び出す
			} content: {
				ImagePicker(image: $selectedImage)
			}
		}
	}
}





struct PhotoSelectView_Previews: PreviewProvider {
	static private var users: [GameUser] = [GameUser(userId: "testUserId01", name: "テストNAME01"),
											GameUser(userId: "testUserId02", name: "テストNAME02"),
											GameUser(userId: "testUserId03", name: "テストNAME03")]

	static var previews: some View {
		PhotoSelectView(users: users)
	}
}
