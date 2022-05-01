//
//  SearchViewController.swift
//  MusicPlayer
//
//  Created by Владимир  on 1.05.22.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol SearchDisplayLogic: class {
  func displayData(viewModel: Search.Model.ViewModel.ViewModelData)
}

class SearchViewController: UIViewController, SearchDisplayLogic {

  var interactor: SearchBusinessLogic?
  var router: (NSObjectProtocol & SearchRoutingLogic)?
    @IBOutlet weak var tabel: UITableView!
    let searchController = UISearchController(searchResultsController: nil)
    private var searchViewModel = SearchViewModel(cells: [])
    private var timer: Timer?
    

  
  // MARK: Setup
  
  private func setup() {
    let viewController        = self
    let interactor            = SearchInteractor()
    let presenter             = SearchPresenter()
    let router                = SearchRouter()
    viewController.interactor = interactor
    viewController.router     = router
    interactor.presenter      = presenter
    presenter.viewController  = viewController
    router.viewController     = viewController
  }
  
  // MARK: Routing
  

  
  // MARK: View lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupSearchBar()
    setupTableView()
    setup()
  }
    private func setupSearchBar() {
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self

    }
    
    private func setupTableView() {
        tabel.register(UITableViewCell.self, forCellReuseIdentifier: "cellId")
        let nib = UINib(nibName: "TrackCell", bundle: nil)
        tabel.register(nib, forCellReuseIdentifier: TrackCell.reuseId)
    }
    
    
  func displayData(viewModel: Search.Model.ViewModel.ViewModelData) {
    
    switch viewModel {
    case .some:
        print("viewController .some")
    case .displayTracks(let searchViewModel):
        print("viewController .displayTracks")
        self.searchViewModel = searchViewModel
        tabel.reloadData()
    }

  }
  
}
 
// MARK: - UITableViewDelegate, UITableViewDataSource

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchViewModel.cells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tabel.dequeueReusableCell(withIdentifier: TrackCell.reuseId, for: indexPath) as! TrackCell
        
        let cellViewModel = searchViewModel.cells[indexPath.row]
        print("\(cellViewModel.previewUrl)")
        cell.trackImageView.backgroundColor = .red
        cell.set(viewModel: cellViewModel)
         
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 84
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
        
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: {(_) in
            self.interactor?.makeRequest(request: Search.Model.Request.RequestType.getTracks(searchTerm: searchText))
        })
        
    }
}