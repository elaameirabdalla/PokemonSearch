//
//  SearchViewController.swift
//  PokemonSearch
//
//  Created by Abdalla Elaameir on 6/6/24.
//

import UIKit

class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UIScrollViewDelegate {
    
    
    // MARK: OUTLETS & FIELDS
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UITextField!
    
    let apiHandler = PokemonAPIHandler()
    var detailsPageViewModel: PokemonDetailsViewModel?
    var currentLimit = 20
    var loadingIndicator = UIActivityIndicatorView()
    var results: [PokemonSearchViewModel] = [] {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    // MARK: FUNCTIONS
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.accessibilityIdentifier = "SearchResultsTable"
        searchBar.delegate = self
        
        // sets up footer and loading indicator for pagination; Loads initial limit of Pokemon
        addPaginationFooter()
        addLoadingIndicator()
        loadPokemon(limit: currentLimit)
        
    }
    
    // Function to add footer to tableview for pagination cue
    func addPaginationFooter() {
        let footer = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 25))
        let label = UILabel(frame: footer.bounds)
        label.textAlignment = .center
        label.text = "Swipe up for more results!"
        label.textColor = .lightGray
        footer.addSubview(label)
        tableView.tableFooterView = footer
    }
    
    // Function that adds loading indicator when new results are being loaded from pagination
    func addLoadingIndicator() {
        loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: view.frame.midX - 50, y: view.frame.midY, width: 100, height: 50))
        loadingIndicator.startAnimating()
        loadingIndicator.isHidden = true
        view.addSubview(loadingIndicator)
    }
    
    // Function that loads Pokemon into TableView.
    // Limit parameter defines how many Pokemon will be loaded at once
    // Called upon initial view controller load and upon pagination with updated limit
    func loadPokemon(limit: Int) {
        apiHandler.getPokemonResults(limit: limit) { success, data in
            if let data = data, success {
                self.results = self.apiHandler.handleResults(data: data)
            }
            else if !success, data == nil {
                self.showAlert(message: "Something went wrong. Please try again.")
            }
        }
        
    }
    
    // MARK: Function for displaying alerts in error/invalid cases
    func showAlert(message: String) {
        let alertVC = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel))
        DispatchQueue.main.async {
            self.present(alertVC, animated: true)
        }
    }
    // MARK: DELEGATE FUNCTIONS
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "pokemonSearchCell", for: indexPath) as! PokemonSearchCell
        
        cell.model = results[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75.0
    }
    
    // MARK: TableView selectRow delegate function to handle displaying details page for specific pokemon selected
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let name = self.results[indexPath.row].name
        apiHandler.searchPokemon(searchTerm: name) { success, data in
            if let data = data, success {
                // Sets detail view model and performs segue
                self.detailsPageViewModel = self.apiHandler.handleDetails(data: data)
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "toDetailsPage", sender: self)
                }
            }
            else if !success, data == nil {
                // Show error alert for API failure
                self.showAlert(message: "Something went wrong. Please try again.")
            }
        }
    }
    // MARK: Prepare function to handle segue into PokemonDetailsViewController. Passes recently updated detailsPageViewModel that configures details page
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? PokemonDetailsViewController {
            guard let model = self.detailsPageViewModel else {
                return
            }
            destination.model = model
        }
    }
    
    // MARK: TextField delegate function for search bar functionality
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let text = textField.text, !text.isEmpty {
            // Calls searchPokemon function with lowercased text as required by API for results
            apiHandler.searchPokemon(searchTerm: text.lowercased()) { success, data in
                if let data = data, success {
                    let resultModel = self.apiHandler.handleDetails(data: data)
                    if resultModel == nil {
                        // Displays error alert if invalid search term
                        self.showAlert(message: "No Pokemon found. Please try again.")
                    }
                    else {
                        // Segues to details page for specific pokemon
                        self.detailsPageViewModel = self.apiHandler.handleDetails(data: data)
                        DispatchQueue.main.async {
                            self.performSegue(withIdentifier: "toDetailsPage", sender: self)
                        }
                    }
                }
                else if !success, data == nil {
                    // Show error alert for API failure
                    self.showAlert(message: "Something went wrong. Please try again.")
                }
            }
        }
        
        return true
    }
    
    // MARK: ScrollView Delegate function to handle pagination on dragging
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let dragThreshold = scrollView.contentSize.height + 25
        let distanceDragged = scrollView.contentOffset.y + scrollView.frame.size.height
        
        // Triggers API call for more results if user scrolls beyond last cell (threshold)
        if distanceDragged > dragThreshold {
            // Calls loadPokemon with incremented limit to display more results. Shows and hides loading indicator
            loadingIndicator.isHidden = false
            currentLimit += 20
            loadPokemon(limit: currentLimit)
            DispatchQueue.main.async {
                self.loadingIndicator.isHidden = true
            }
        }
    }
    
}

