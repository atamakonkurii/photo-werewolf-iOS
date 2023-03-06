//
//  UserEntity.swift
//  photo-werewolf-iOS
//
//  Created by 太田和希 on 2023/03/07.
//

import FirebaseFirestore
import FirebaseFirestoreSwift

// firestoreのユーザーデータを格納する構造体
struct User: Codable {
	@DocumentID var id: String?
	var userId: String
	var name: String
}
