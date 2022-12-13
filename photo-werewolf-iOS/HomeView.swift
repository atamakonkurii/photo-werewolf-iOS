//
//  HomeView.swift
//  photo-werewolf-iOS
//
//  Created by 太田和希 on 2022/11/16.
//

import SwiftUI
import FirebaseAuth

struct HomeView: View {
	@State private var value1: String = ""
	@State var showingMakeRoomPopUp = false
	@State var showingNameChangePopUp = false

	var body: some View {
		NavigationView {
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
								showingNameChangePopUp = true
							}
						}, label: {
							Text("\(Auth.auth().currentUser?.displayName ?? "ななし")")
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

					Image("character_hitsuji_ookami")
						.resizable()
						.scaledToFit()
						.frame(width: 300, height: 150)

					Text("コードを入力して部屋に入る")
						.font(.system(size: 16, design: .rounded))
						.foregroundColor(.white)
						.fontWeight(.black)

					TextField("# _ _ _ _ _", text: $value1)
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
							showingMakeRoomPopUp = true
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

				if showingNameChangePopUp {
					NameChangePopupView(isPresent: $showingNameChangePopUp)
				}

				if showingMakeRoomPopUp {
					MakeRoomPopupView(isPresent: $showingMakeRoomPopUp)
				}
			}
		}.onAppear {
			// ログインしていない場合は匿名ログインをする
			anonymousLogin()
		}
	}

	private func anonymousLogin() {
		if Auth.auth().currentUser == nil {
			Auth.auth().signInAnonymously { authResult, error in
				guard let user = authResult?.user else {
					return
				}
				print(user.uid)
			}
		}
	}
}

struct NameChangePopupView: View {
	@Binding var isPresent: Bool
	@State private var setName: String = ""
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

				Text("名前の変更")
					.font(.system(size: 24, design: .rounded))
					.foregroundColor(.white)
					.fontWeight(.black)

				TextField("例）かずお", text: $setName)
					.textFieldStyle(RoundedBorderTextFieldStyle())
					.font(.system(size: 24))
					.padding()

				Button(action: {
					setDisplayName(name: setName)
					withAnimation {
						isPresent = false
					}
				}, label: {
					Text("変更する")
						.font(.system(size: 24, design: .rounded))
						.foregroundColor(.white)
						.fontWeight(.black)
				})
				.padding()
				.accentColor(Color.white)
				.background(Color.orange)
				.cornerRadius(26)

			}
			.frame(width: 280, alignment: .center)
			.padding()
			.background(Color(red: 0.133, green: 0.157, blue: 0.192))
			.cornerRadius(36)
		}
	}

	private func setDisplayName(name: String) {
		if let user = Auth.auth().currentUser {
			let request = user.createProfileChangeRequest()
			request.displayName = name
			request.commitChanges { error in
				if error == nil {
					print("名前を設定しました")
				}
			}
		}
	}
}

struct MakeRoomPopupView: View {
	@Binding var isPresent: Bool
	@State private var value2: String = ""
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

				Text("部屋名を入力してください")
					.font(.system(size: 24, design: .rounded))
					.foregroundColor(.white)
					.fontWeight(.black)

				TextField("例）写真人狼部屋", text: $value2)
					.textFieldStyle(RoundedBorderTextFieldStyle())
					.font(.system(size: 24))
					.padding()

					NavigationLink(destination: WaitingRoomView()) {
						Text("決定")
							.font(.system(size: 24, design: .rounded))
							.foregroundColor(.white)
							.fontWeight(.black)
					}
					.padding()
					.accentColor(Color.white)
					.background(Color.orange)
					.cornerRadius(26)
			}
			.frame(width: 280, alignment: .center)
			.padding()
			.background(Color(red: 0.133, green: 0.157, blue: 0.192))
			.cornerRadius(36)
		}
	}
}

struct HomeView_Previews: PreviewProvider {
	static var previews: some View {
		HomeView()
	}
}
