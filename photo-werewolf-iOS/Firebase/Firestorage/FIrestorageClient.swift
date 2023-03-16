import FirebaseStorage

final public class FirestorageApiClient {
	public static let shared = FirestorageApiClient()
	let storage = Storage.storage()

	private init() {}
}
