//
//  ReciepeAPI.swift
//  RecipeSearch
//
//  Created by Tsering Lama on 12/10/19.
//  Copyright © 2019 Alex Paul. All rights reserved.
//

import Foundation

struct ReciepeAPI {
    
    static func getReciepe(searchQuery: String, completionHandler: @escaping (Result<[Recipe],AppError>) -> ()) {
        
        let recipeEndpointURL = "https://api.edamam.com/search?q=\(searchQuery)&app_id=\(SecretKeys.appId)&app_key=\(SecretKeys.appKey)&from=0&to=50"
        
        guard let url = URL(string: recipeEndpointURL) else {
            completionHandler(.failure(.badURL(recipeEndpointURL)))
            return
        }
        
        let request = URLRequest(url: url)
    
        NetworkHelper.shared.performDataTask(with: request) { (result) in
            switch result {
            case .failure(let appError):
                completionHandler(.failure(.networkClientError(appError)))
            case .success(let data):
                do{
                    let results = try JSONDecoder().decode(ReciepeData.self, from: data)
                    
                    // TODO: make an array of recipes
                    // capture in completion handler
                    // let recipes = results.hits.map {$0.recipe}
                    var dataArr = [Recipe]()
                    let hits = results.hits
                    for hit in hits {
                        dataArr.append(hit.recipe)
                    }
                    completionHandler(.success(dataArr))
                } catch {
                    completionHandler(.failure(.decodingError(error)))
                }
            }
        }
    }
}
