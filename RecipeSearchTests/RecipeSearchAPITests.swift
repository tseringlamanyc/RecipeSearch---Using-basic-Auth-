//
//  RecipeSearchAPITests.swift
//  RecipeSearchTests
//
//  Created by Alex Paul on 12/9/19.
//  Copyright © 2019 Alex Paul. All rights reserved.
//

import XCTest
@testable import RecipeSearch

class RecipeSearchAPITests: XCTestCase {
    
    func testchristmasCookies() {
        // arrange
        // url friendly string
        let searchQuery = "christmas cookies".addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        let exp = XCTestExpectation(description: "search found")
        let recipeEndpointURL = "https://api.edamam.com/search?q=\(searchQuery)&app_id=\(SecretKeys.appId)&app_key=\(SecretKeys.appKey)&from=0&to=50"
        
        let request = URLRequest(url: URL(string: recipeEndpointURL)!)
        
        // act
        NetworkHelper.shared.performDataTask(with: request) { (result) in
            switch result {
            case .failure(let appError):
                XCTFail("\(appError)")
            case .success(let data):
                exp.fulfill()
                XCTAssertGreaterThan(data.count, 800000)
            }
        }
        wait(for: [exp], timeout: 5.0)
    }
    
    func testReciepeCount() {
        // arrange
        let query = "christmas cookies".addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        
        // exp
        let exp = XCTestExpectation(description: "search found")
        
        // act
        ReciepeAPI.getReciepe(searchQuery: query) { (result) in
            // assert
            var dataHit = [Recipe]()
            switch result {
            case .failure(let appError):
                XCTFail("\(appError)")
            case .success(let recipes):
                dataHit = recipes
                // check if array count is 50
                // fullfill
                exp.fulfill()
                XCTAssertEqual(dataHit.count, 50)
            }
        }
        // wait
        wait(for: [exp], timeout: 5.0)
    }
}

