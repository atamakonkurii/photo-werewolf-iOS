import SwiftUI
import Kingfisher

struct ImageView: View {
	let imageUrl: URL
	@State private var image: UIImage?

	var body: some View {
		KFImage(imageUrl)
			.resizable()
			.placeholder {
				VStack {
					ProgressView()
				}
			}
			.fade(duration: 0.25)
			.scaledToFit()
	}
}

struct ImageView_Previews: PreviewProvider {
    static var previews: some View {
		ImageView(imageUrl: URL(string: "https://placehold.jp/300x200.png")!)
    }
}
