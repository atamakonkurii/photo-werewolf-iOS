//
//  HomeView.swift
//  photo-werewolf-iOS
//
//  Created by 太田和希 on 2022/11/16.
//

import SwiftUI

struct HomeView: View {
	@State private var value1: String = ""
    var body: some View {
		ZStack {
			Color(red: 0.34, green: 0.4, blue: 0.49).ignoresSafeArea()
			VStack {
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

				TextField("# _ _ _ _", text: $value1)
					.textFieldStyle(RoundedBorderTextFieldStyle())
					.font(.system(size: 36))
					.frame(width: 200.0)
					.padding()
					.multilineTextAlignment(.center)

				Text("もしくは")
					.font(.system(size: 16, design: .rounded))
					.foregroundColor(.white)
					.fontWeight(.black)

				Button(action: {
					print("tap buton")
				}, label: {
					Text("部屋をつくる")
						.font(.system(size: 24, design: .rounded))
						.foregroundColor(.white)
						.fontWeight(.black)
				})
				.padding()
				.accentColor(Color.white)
				.background(Color.orange)
				.cornerRadius(26)
			}

		}
	}
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
