import FirebaseFirestore
import FirebaseFirestoreSwift

final public class FirestoreApiClient {
	public static let shared = FirestoreApiClient()
	let db = Firestore.firestore()

	private init() {}
}

