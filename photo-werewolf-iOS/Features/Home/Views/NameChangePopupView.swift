//
//  NameChangePopupView.swift
//  photo-werewolf-iOS
//
//  Created by 太田和希 on 2023/01/31.
//

import SwiftUI

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
					FirebaseAuthBase.shared.setDisplayName(name: setName)
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
}
