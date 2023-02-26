//
//  WaitingRoomView.swift
//  photo-werewolf-iOS
//
//  Created by 太田和希 on 2022/12/07.
//

import SwiftUI

struct WaitingRoomView: View {
	let roomNumber: String
	@Environment(\.dismiss) var dismiss

	init(roomNumber: String) {
		self.roomNumber = roomNumber
	}

	var body: some View {
		ZStack {
			Color(red: 0.133, green: 0.157, blue: 0.192)
				.ignoresSafeArea()
				.navigationBarBackButtonHidden(true)
				.toolbar {
					ToolbarItem(placement: .navigationBarLeading) {
						Button(
							action: {
								dismiss()
							}, label: {
								Text("部屋を出る")
									.font(.system(size: 16, design: .rounded))
									.foregroundColor(.gray)
									.fontWeight(.black)
							}
						)
						.tint(.orange)
					}
				}

			VStack {
				ZStack {
					Rectangle()
						.fill(.clear)
						.cornerRadius(24)
						.overlay(
							RoundedRectangle(cornerRadius: 24)
								.stroke(Color(.orange), lineWidth: 1.0)
						)

					VStack {
						Text("写真人狼部屋")
							.font(.system(size: 32, design: .rounded))
							.foregroundColor(.white)
							.fontWeight(.black)
							.padding(.bottom, 8)

						HStack(alignment: .bottom) {
							Text("部屋コード")
								.font(.system(size: 16, design: .rounded))
								.foregroundColor(.white)
								.fontWeight(.black)

							Button(
								action: {
									sharePost(shareText: "iOS-Docs", shareUrl: "https://ios-docs.dev")
								}, label: {
									Image(systemName: "square.and.arrow.up.fill")
										.font(.system(size: 30))
										.foregroundColor(.gray)
								}
							)
						}

						Button(action: {
							UIPasteboard.general.string = "\(roomNumber)"
						}, label: {
							ZStack {
								RoundedRectangle(cornerRadius: 24)
									.fill(.white)
									.frame(width: 196, height: 64)
								HStack {
									Text("# ")
										.font(.system(size: 32, design: .rounded))
										.foregroundColor(.gray)
										.fontWeight(.black)

									Text("\(roomNumber)")
										.font(.system(size: 32, design: .rounded))
										.foregroundColor(.black)
										.fontWeight(.black)
								}

							}
						})
					}
				}
				.frame(width: 300, height: 200)

				ZStack {
					Rectangle()
						.fill(.clear)
						.cornerRadius(24)
						.overlay(
							RoundedRectangle(cornerRadius: 24)
								.stroke(Color(.orange), lineWidth: 1.0)
						)

					VStack {
						Group {
							HStack(alignment: .bottom) {
								Text("参加者")
									.font(.system(size: 24, design: .rounded))
									.foregroundColor(.white)
									.fontWeight(.black)
								Text("5人~8人")
									.font(.system(size: 12, design: .rounded))
									.foregroundColor(.gray)
									.fontWeight(.medium)
							}

							Text("5人集まったらスタートできます")
								.font(.system(size: 12, design: .rounded))
								.foregroundColor(.gray)
								.fontWeight(.medium)
								.padding(.bottom, 8)

							VStack(alignment: .leading, spacing: 8) {
								Text("かずお")
									.font(.system(size: 16, design: .rounded))
									.foregroundColor(.white)
									.fontWeight(.black)

								Text("かずお")
									.font(.system(size: 16, design: .rounded))
									.foregroundColor(.white)
									.fontWeight(.black)

								Text("かずお")
									.font(.system(size: 16, design: .rounded))
									.foregroundColor(.white)
									.fontWeight(.black)

								Text("かずお")
									.font(.system(size: 16, design: .rounded))
									.foregroundColor(.white)
									.fontWeight(.black)

								Text("かずお")
									.font(.system(size: 16, design: .rounded))
									.foregroundColor(.white)
									.fontWeight(.black)

								Rectangle()
									.fill(.gray)
									.frame(height: 24)

								Rectangle()
									.fill(.gray)
									.frame(height: 24)

								Rectangle()
									.fill(.gray)
									.frame(height: 24)
							}
						}
						.frame(maxWidth: .infinity, alignment: .leading)

						NavigationLink(destination: PhotoSelectView()) {
							Text("スタート")
								.font(.system(size: 24, design: .rounded))
								.foregroundColor(.white)
								.fontWeight(.black)
						}
						.padding()
						.accentColor(Color.white)
						.background(Color.orange)
						.cornerRadius(32)
					}
					.frame(width: 180)
				}
				.frame(width: 300)

				Spacer(minLength: 50)
			}
		}
	}

	func sharePost(shareText: String, shareUrl: String) {
		let activityItems = [shareText, URL(string: shareUrl)!] as [Any]
		let activityVC = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
		let viewController = UIApplication.shared.windows.first?.rootViewController
		viewController?.present(activityVC, animated: true)
	}
}

struct WaitingRoomView_Previews: PreviewProvider {
	static var previews: some View {
		WaitingRoomView(roomNumber: "051746")
	}
}
