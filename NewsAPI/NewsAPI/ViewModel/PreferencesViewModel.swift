//
//  PreferencesViewModel.swift
//  NewsAPI
//
//  Created by Cuong Do Hung on 3/15/20.
//  Copyright © 2020 Cuong Do Hung. All rights reserved.
//
/* Get data for preference choice*/
class PreferencesViewModel {
    static var selectedPreference: String?
    let allPreferences = ["Bitcoin", "Apple", "Earthquake", "Animal"]
    func getTotalPreferences() -> Int {
        return allPreferences.count
    }
    func getPreference(index: Int) -> String? {
        if index >= allPreferences.count {
            return nil
        }
        return allPreferences[index]
    }
    func getIndex(preference: String) -> Int? {
        return allPreferences.firstIndex(of: preference)
    }
}
