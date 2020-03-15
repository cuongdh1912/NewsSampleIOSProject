//
//  UserDefaultManager.swift
//  NewsAPI
//
//  Created by Cuong Do Hung on 3/15/20.
//  Copyright © 2020 Cuong Do Hung. All rights reserved.
//
import Foundation
class UserDefaultManager {
    static let shared = UserDefaultManager()
    let profileKey = "ProfileKey"
    let preferenceKey = "PreferencKey"
    
    func saveProfile(profile: Profile?) {
        guard let profile = profile else { return }
        
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(profile) {
            let defaults = UserDefaults.standard
            defaults.set(encoded, forKey: profileKey)
        }
    }
    func removeProfile() {
        let defaults = UserDefaults.standard
        defaults.set(nil, forKey: profileKey)        
    }
    func getProfile() -> Profile? {
        let defaults = UserDefaults.standard
        if let profileData = defaults.object(forKey: profileKey) as? Data {
            let decoder = JSONDecoder()
            if let profile = try? decoder.decode(Profile.self, from: profileData) {
                return profile
            }
        }
        return nil
    }
    func updatePreference(preference: String?) {
        if let preference = preference, let profile = UserDefaultManager.shared.getProfile() {
            profile.preference = preference
            UserDefaultManager.shared.saveProfile(profile: profile)
        }
    }
    func getPreference() -> String? {
        if let profile = UserDefaultManager.shared.getProfile() {
            return profile.preference
        }
        return nil
    }
}
