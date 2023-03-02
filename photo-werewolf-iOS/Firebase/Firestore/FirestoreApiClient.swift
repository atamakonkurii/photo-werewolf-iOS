//
//  FirestoreBase.swift
//  photo-werewolf-iOS
//
//  Created by 太田和希 on 2023/02/28.
//

import FirebaseFirestore
import FirebaseFirestoreSwift

final public class FirestoreApiClient {
	public static let shared = FirestoreApiClient()
	let db = Firestore.firestore()

	private init() {}
}

