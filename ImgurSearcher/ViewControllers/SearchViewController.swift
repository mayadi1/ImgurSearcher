//
//  ViewController.swift
//  ImgurSearcher
//
//  Created by Mohamed Ayadi on 1/12/19.
//  Copyright © 2019 Mohamed Ayadi. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
    
    private let searchController = UISearchController(searchResultsController: nil)
    private let cellIdentifier = "parentCellIdentifier"
    private var searchText: String?
    private var pageNumber = 1
    
    private var results: [Result] = []{
        didSet{            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSearchController()
        gallerySearch(searchText: "Cat", atPage: self.pageNumber)
    }

    
      // Setup the Search Controller
    func setupSearchController(){
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search photos"
        tableView.tableHeaderView = searchController.searchBar
        searchController.searchBar.delegate = self
        definesPresentationContext = true
    }
    
    func gallerySearch(searchText: String, atPage: Int){
        NetworkingClient.shared.fetchResults(with: searchText, atPage: atPage) { (results) in
            DispatchQueue.main.async {
                self.pageNumber = 1
                self.navigationItem.title = searchText
                self.searchText = searchText
                self.searchController.isActive = false
                self.results = results?.results ?? []
            }
        }
    }

}

// MARK: - Search Bar

extension SearchViewController: UISearchBarDelegate{
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    
        if let searchText = searchController.searchBar.text {
            gallerySearch(searchText: searchText, atPage: self.pageNumber)
        }
    }
}

// MARK: - Table View

extension SearchViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        let result = results[indexPath.row]
     
        if let image = cell.viewWithTag(100) as? CustomImageView,
            let label = cell.viewWithTag(101) as? UILabel,
            let url = result.imageURLS?.first,
            "jpg" == url.pathExtension || "png" == url.pathExtension{
            
            label.text = result.title
            DispatchQueue.main.async {
                image.loadImage(with: url)
            }
            
        }else{
            print("Coudnt config cell")
        }
        
        cell.layer.cornerRadius = 30
        cell.layer.masksToBounds = true
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if indexPath.row == results.count - 1{
            let spinner = UIActivityIndicatorView(style: .gray)
            spinner.startAnimating()
            spinner.frame = CGRect(x: 0, y: 0, width: self.tableView.frame.width, height: 44)
            self.tableView.tableFooterView = spinner;
            guard let searchText = self.searchText else {return}
            
            NetworkingClient.shared.fetchResults(with: searchText, atPage: pageNumber + 1) { (results) in
                if let results = results {
                    DispatchQueue.main.async {
                        self.pageNumber = self.pageNumber + 1
                        self.results.append(contentsOf: results.results)
                        
                        //TODO: Insert cell insetead of reaload
                        tableView.reloadData()
                    }
                } else {
                    let label = UILabel()
                    label.frame = CGRect(x: 0, y: 0, width: self.tableView.frame.width, height: 44)
                    label.text = "Sorry Nothing More"
                    self.tableView.tableFooterView = label
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailVC"{
            
            guard let destinationVC = segue.destination as? detailViewController,
                  let indexPath = tableView.indexPathForSelectedRow,
                  let cell = self.tableView.cellForRow(at: indexPath),
                  let imageView = cell.viewWithTag(100) as? CustomImageView,
                  let label = cell.viewWithTag(101) as? UILabel,
                  let image = imageView.image else{
                print("Error in prepare for seg detailViewController")
                return
            }
            
            destinationVC.navigationItem.title = label.text
            destinationVC.image = image

        }
    }
}
