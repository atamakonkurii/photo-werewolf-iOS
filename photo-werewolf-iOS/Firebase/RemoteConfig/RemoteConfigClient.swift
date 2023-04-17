import FirebaseRemoteConfig

final public class RemoteConfigClient {
	public static let shared = RemoteConfigClient()
	let remoteConfig = RemoteConfig.remoteConfig()
	let settings = RemoteConfigSettings()

	private init() {}

	func tempFetch() {
		remoteConfig.configSettings = settings

		remoteConfig.addOnConfigUpdateListener { configUpdate, error in
			guard let configUpdate, error == nil else {
				print("Error listening for config updates: \(String(describing: error))")
				return
			}

			print("Updated keys: \(configUpdate.updatedKeys)")

			self.remoteConfig.activate { changed, error in
				guard error == nil else { return }
				DispatchQueue.main.async {
					print("sucess:\(changed)")
					print("app_store_url\(String(describing: self.remoteConfig.configValue(forKey: "app_store_url").stringValue))")
					print("current_version\(String(describing: self.remoteConfig.configValue(forKey: "current_version").stringValue))")
					print("require_force_update\(String(describing: self.remoteConfig.configValue(forKey: "require_force_update").stringValue))")
				}
			}
		}
	}
}
