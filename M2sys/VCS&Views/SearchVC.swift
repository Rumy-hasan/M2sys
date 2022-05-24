//
//  ViewController.swift
//  M2sys
//
//  Created by Paradox Space Rumy M1 on 24/5/22.
//

import UIKit
import Combine

final class SearchVC: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var suggectionView: UITableView!
    @IBOutlet weak var searchBtn: UIButton!
    
    private var searchViewModel: SearchViewModel!
    private var subscriptions = Set<AnyCancellable>()
    private var filteredCities:[String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialSetup()
    }
    
    private func initialSetup(){
        if let havesearchViewModel = DependencyContainer.shared.resolve(type: SearchViewModel.self){
            self.searchViewModel = havesearchViewModel
        }else{
            self.searchViewModel = SearchViewModel(with: CityDataFatcher(session: URLSession.shared))
            DependencyContainer.shared.register(type: SearchViewModel.self, component: self.searchViewModel!)
        }
        self.searchBar.delegate = searchViewModel!
        self.suggectionView.delegate = self
        self.suggectionView.dataSource = self
        self.bindTVWithViewModel()
    }
    
    
    @IBAction func searchBtnClick(_ sender: Any) {
        self.searchViewModel.searchForKey()
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Detail") as! DetailViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    deinit{
        subscriptions.removeAll()
    }
    
}

//MARK: bind view with view models
extension SearchVC{
    private func bindTVWithViewModel(){
        let sub = self.searchViewModel.$filteredCities.sink { [weak self] v in
            guard let self = self else{return}
            self.filteredCities = v
            self.suggectionView.reloadData()
        }
        sub.store(in: &subscriptions)
    }
}

extension SearchVC:UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.filteredCities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = self.filteredCities[indexPath.item]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.searchViewModel.searchField = self.filteredCities[indexPath.row]
        self.searchBtnClick(self.searchBtn!)
    }
}



