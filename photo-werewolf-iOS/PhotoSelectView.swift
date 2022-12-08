//
//  PhotoSelectView.swift
//  photo-werewolf-iOS
//
//  Created by 太田和希 on 2022/12/08.
//

import SwiftUI

struct PhotoSelectView: View {
	@State var image: UIImage?
	@State var showingAlert: Bool = false

	var body: some View {
		ZStack {
			Color(red: 0.133, green: 0.157, blue: 0.192)
				.ignoresSafeArea()
				.navigationBarBackButtonHidden(true)

			VStack {
				Text("写真選択")
					.font(.system(size: 40, design: .rounded))
					.foregroundColor(.white)
					.fontWeight(.black)
					.padding(.bottom, 16)

				Text("自分が語りたい写真を選択してください")
					.font(.system(size: 14, design: .rounded))
					.foregroundColor(.white)
					.fontWeight(.black)

				Button {
					showingAlert = true
				} label: {
					if let image = image {
						Image(uiImage: image)
							.resizable()
							.frame(width: 200, height: 200)
					} else {
						Text("No Image")
							.font(.system(size: 24, design: .rounded))
							.foregroundColor(Color.white)
							.frame(width: 200, height: 200)
							.background(Color(UIColor.lightGray))
					}
				}
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

						NavigationLink(destination: PhotoSelectView()) {
							Text("役職割振へ")
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
			.sheet(isPresented: $showingAlert) {
			} content: {
				ImagePicker(image: $image)
			}
		}
	}
}

struct PhotoSelectView_Previews: PreviewProvider {
	static var previews: some View {
		PhotoSelectView()
	}
}

import PhotosUI

struct ImagePicker: UIViewControllerRepresentable {
	@Environment(\.presentationMode) var presentationMode
	@Binding var image: UIImage?

	func makeCoordinator() -> Coordinator {
		Coordinator(self)
	}

	func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> PHPickerViewController {
		var configuration = PHPickerConfiguration()
		configuration.filter = .images
		configuration.selectionLimit = 1
		let picker = PHPickerViewController(configuration: configuration)
		picker.delegate = context.coordinator
		return picker
	}

	func updateUIViewController(_ uiViewController: PHPickerViewController, context: UIViewControllerRepresentableContext<ImagePicker>) {}

	class Coordinator: NSObject, UINavigationControllerDelegate, PHPickerViewControllerDelegate {
		let parent: ImagePicker

		init(_ parent: ImagePicker) {
			self.parent = parent
		}

		func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
			parent.presentationMode.wrappedValue.dismiss()

			if let itemProvider = results.first?.itemProvider, itemProvider.canLoadObject(ofClass: UIImage.self) {
				itemProvider.loadObject(ofClass: UIImage.self) { [weak self] image, _ in
					guard let image = image as? UIImage else {
						return
					}
					DispatchQueue.main.sync {
						self?.parent.image = image
					}
				}
			}
		}
	}
}
