//
//  ConfirmationRollView.swift
//  photo-werewolf-iOS
//
//  Created by 太田和希 on 2022/12/08.
//

import SwiftUI

struct ConfirmationRollView: View {
	@State var showingPopUp = false
    var body: some View {
		ZStack {
			Color(red: 0.133, green: 0.157, blue: 0.192)
				.ignoresSafeArea()
				.navigationBarBackButtonHidden(true)

			VStack {
				Text("役職確認")
					.font(.system(size: 40, design: .rounded))
					.foregroundColor(.white)
					.fontWeight(.black)
					.padding(.bottom, 16)

				Button(action: {
					withAnimation {
						showingPopUp = true
					}
				}, label: {
					Text("確認する")
						.font(.system(size: 24, design: .rounded))
						.foregroundColor(.white)
						.fontWeight(.black)
				})
				.padding()
				.accentColor(Color.white)
				.background(Color.purple)
				.cornerRadius(32)
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
						Group {
							Text("参加者")
								.font(.system(size: 32, design: .rounded))
								.foregroundColor(.white)
								.fontWeight(.black)
								.padding(.bottom, 8)

							VStack(alignment: .leading, spacing: 12) {
								HStack {
									Image(systemName: "checkmark.circle.fill")
										.font(.system(size: 24))
										.foregroundColor(.gray)

									Text("かずお")
										.font(.system(size: 24, design: .rounded))
										.foregroundColor(.white)
										.fontWeight(.black)
								}

								HStack {
									Image(systemName: "checkmark.circle.fill")
										.font(.system(size: 24))
										.foregroundColor(.green)

									Text("かずお")
										.font(.system(size: 24, design: .rounded))
										.foregroundColor(.white)
										.fontWeight(.black)
								}

								HStack {
									Image(systemName: "checkmark.circle.fill")
										.font(.system(size: 24))
										.foregroundColor(.green)

									Text("かずお")
										.font(.system(size: 24, design: .rounded))
										.foregroundColor(.white)
										.fontWeight(.black)
								}

								HStack {
									Image(systemName: "checkmark.circle.fill")
										.font(.system(size: 24))
										.foregroundColor(.gray)

									Text("かずお")
										.font(.system(size: 24, design: .rounded))
										.foregroundColor(.white)
										.fontWeight(.black)
								}

								HStack {
									Image(systemName: "checkmark.circle.fill")
										.font(.system(size: 24))
										.foregroundColor(.gray)

									Text("かずお")
										.font(.system(size: 24, design: .rounded))
										.foregroundColor(.white)
										.fontWeight(.black)
								}
							}
						}
						.frame(maxWidth: .infinity, alignment: .leading)

						NavigationLink(destination: EmptyView()) {
							Text("話し合いへ")
								.font(.system(size: 24, design: .rounded))
								.foregroundColor(.white)
								.fontWeight(.black)
						}
						.padding()
						.accentColor(Color.white)
						.background(Color.purple)
						.cornerRadius(32)
					}
					.frame(width: 180)
				}
			}
			.frame(width: 300)

			if showingPopUp {
				ConfirmationRoolPopupView(isPresent: $showingPopUp)
			}
		}
    }
}

struct ConfirmationRoolPopupView: View {
	@Binding var isPresent: Bool
	var body: some View {
		ZStack {
			Color(red: 0.34, green: 0.4, blue: 0.49, opacity: 0.5)
				.ignoresSafeArea()
			VStack {
				Text("あなたは「人狼」です。\n他の人狼と写真が入れ替わります")
					.font(.system(size: 24, design: .rounded))
					.foregroundColor(.white)
					.fontWeight(.black)

				Button(action: {
					withAnimation {
						isPresent = false
					}
				}, label: {
					Text("閉じる")
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

struct ConfirmationRollView_Previews: PreviewProvider {
    static var previews: some View {
        ConfirmationRollView()
    }
}
