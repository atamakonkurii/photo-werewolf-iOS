//
//  StandardGameView.swift
//  photo-werewolf-iOS
//
//  Created by 太田和希 on 2023/03/14.
//

import SwiftUI

struct StandardGameView: View {
	@StateObject var viewModel: StandardGameViewModel
	@Binding var navigationPath: [NavigationPath]

    var body: some View {
		switch viewModel.gameRoom?.status {
		case .waiting:
			WaitingRoomView(viewModel: WaitingRoomViewModel(), gameRoom: viewModel.gameRoom, users: viewModel.users, roomId: viewModel.roomId)
		case .photoSelect:
			PhotoSelectView(gameRoom: viewModel.gameRoom, users: viewModel.users, viewModel: PhotoSelectViewModel())
		case .checkRoll:
			CheckRollView()
		case .conversation:
			EmptyView()
		case .vote:
			EmptyView()
		case .result:
			EmptyView()
		default:
			EmptyView()
		}
    }
}

struct StandardGameView_Previews: PreviewProvider {
	@State static var navigationPath: [NavigationPath] = [.standardGame(roomId: "098765")]

    static var previews: some View {
		StandardGameView(viewModel: StandardGameViewModel(model: StandardGameModel(roomId: "098765")), navigationPath: $navigationPath)
    }
}
