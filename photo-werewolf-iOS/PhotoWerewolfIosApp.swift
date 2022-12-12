//
//  photo_werewolf_iOSApp.swift
//  photo-werewolf-iOS
//
//  Created by 太田和希 on 2022/11/15.
//

import SwiftUI
import FirebaseCore
import FirebaseAuth

class AppDelegate: NSObject, UIApplicationDelegate {
	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
		FirebaseApp.configure()

		return true
	}
}

@main
struct 	PhotoWerewolfIosApp: App {
	// register app delegate for Firebase setup
	@UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    var body: some Scene {
        WindowGroup {
            HomeView()
        }
    }
}
