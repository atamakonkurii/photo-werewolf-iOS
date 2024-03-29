//
//  MakeRoomPopupView.swift
//  photo-werewolf-iOS
//
//  Created by 太田和希 on 2023/01/31.
//

import SwiftUI

struct MakeRoomPopupView: View {
	@Binding var isPresent: Bool
	@Binding var navigationPath: [NavigationPath]
	@State private var roomName: String = ""
	@StateObject var viewModel: MakeRoomViewModel

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

				TextField("例）写真人狼部屋", text: $roomName)
					.textFieldStyle(RoundedBorderTextFieldStyle())
					.font(.system(size: 24))
					.padding()

				Button {
					Task {
						// WaitingRoomにgameRoomのroomNumberを渡す
						let roomId = await FirestoreApiClient.shared.postGameRoom(roomName: roomName, gameType: GameType.standard)

						guard let roomId = roomId else {
							return
						}

						navigationPath.append(.standardGame(roomId: roomId))
					}

				} label: {
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
