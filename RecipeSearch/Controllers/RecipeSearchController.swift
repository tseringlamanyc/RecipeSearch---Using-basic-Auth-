//
//  RecipeSearchController.swift
//  RecipeSearch
//
//  Created by Alex Paul on 12/9/19.
//  Copyright © 2019 Alex Paul. All rights reserved.
//

import UIKit

class RecipeSearchController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var reciepeSearch: UISearchBar!
    
    var recipes = [Recipe]() {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    var currentRecipe = ""
    
    func searchRecipe(userReciepe: String) {
        currentRecipe = userReciepe
        ReciepeAPI.getReciepe(searchQuery: userReciepe) { (result) in
            switch result {
            case .failure(let appError):
                print("\(appError)")
            case .success(let reciepe):
                self.recipes = reciepe
            }
        }
    }
    
    override func viewDidLoad() {
        tableView.dataSource = self
        reciepeSearch.delegate = self
        searchRecipe(userReciepe: currentRecipe)
    }
}

extension RecipeSearchController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "recipeCell", for: indexPath)
        let aReciepe = recipes[indexPath.row]
        cell.textLabel?.text = aReciepe.label
        return cell
    }
}

extension RecipeSearchController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text else {
            print("missing search text!")
            return
        }
        currentRecipe = searchText
        searchRecipe(userReciepe: searchText)
    }
}
