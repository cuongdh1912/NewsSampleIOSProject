//
//  NewsAPITests.swift
//  NewsAPITests
//
//  Created by Cuong Do Hung on 3/14/20.
//  Copyright © 2020 Cuong Do Hung. All rights reserved.
//

import XCTest
@testable import NewsAPI

class NewsAPITests: XCTestCase {
    var preferenceViewModel:PreferencesViewModel!
    override func setUp() {
        preferenceViewModel = PreferencesViewModel()
    }

    override func tearDown() {
        preferenceViewModel = nil
        super.tearDown()
    }

    func testPreferenceViewModel() {
        XCTAssertEqual(preferenceViewModel.getTotalPreferences(), 4, "Get total of preferences wrong")
        XCTAssertEqual(preferenceViewModel.getPreference(index: 2), "Earthquake", "Get preference at index 2 wrong")
        
        XCTAssertEqual(preferenceViewModel.getIndex(preference: "Apple"), 1, "Get index of preference Apple wrong")
    }
}
