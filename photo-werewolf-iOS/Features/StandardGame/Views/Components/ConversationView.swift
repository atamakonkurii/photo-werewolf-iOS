import SwiftUI

struct ConversationView: View {
	var body: some View {
		ZStack {
			Color(red: 0.133, green: 0.157, blue: 0.192)
				.ignoresSafeArea()
				.navigationBarBackButtonHidden(true)
			VStack {
				Text("話し合い")
					.font(.system(size: 40, design: .rounded))
					.foregroundColor(.white)
					.fontWeight(.black)
					.padding(.bottom, 16)
			}
		}
	}
}

struct ConversationView_Previews: PreviewProvider {
	static var previews: some View {
		ConversationView()
	}
}
