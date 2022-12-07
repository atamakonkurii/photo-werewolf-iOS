//
//  PhotoSelectView.swift
//  photo-werewolf-iOS
//
//  Created by 太田和希 on 2022/12/08.
//

import SwiftUI

struct PhotoSelectView: View {
    var body: some View {
		ZStack {
			Color(red: 0.133, green: 0.157, blue: 0.192)
				.ignoresSafeArea()

			VStack {
				Text("写真選択")
					.font(.system(size: 40, design: .rounded))
					.foregroundColor(.white)
					.fontWeight(.black)
			}
		}
    }
}

struct PhotoSelectView_Previews: PreviewProvider {
    static var previews: some View {
        PhotoSelectView()
    }
}
