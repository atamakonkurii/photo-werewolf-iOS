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
		case .checkRole:
			CheckRoleView(gameRoom: viewModel.gameRoom, users: viewModel.users, viewModel: CheckRoleViewModel())
		case .conversation:
			ConversationView(gameRoom: viewModel.gameRoom, users: viewModel.users, viewModel: ConversationViewModel())
		case .vote:
			VoteView(gameRoom: viewModel.gameRoom, users: viewModel.users, viewModel: VoteViewModel())
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
