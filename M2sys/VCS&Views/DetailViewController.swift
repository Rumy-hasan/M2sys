//
//  DetailViewController.swift
//  M2sys
//
//  Created by Paradox Space Rumy M1 on 24/5/22.
//

import UIKit
import Combine

final class DetailViewController: UIViewController {
    private var searchViewModel: SearchViewModel!
    private var subscriptions = Set<AnyCancellable>()
    
    @IBOutlet weak var detailText: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialSetup()
    }
    
    private func initialSetup() {
        if let havesearchViewModel = DependencyContainer.shared.resolve(type: SearchViewModel.self){
            self.searchViewModel = havesearchViewModel
        }else{
            self.searchViewModel = SearchViewModel(with: CityDataFatcher(session: URLSession.shared))
            DependencyContainer.shared.register(type: SearchViewModel.self, component: self.searchViewModel!)
        }
        bindDataWithLbl()
        bindErrorWithLBL()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.subscriptions.removeAll()
    }
}


//MARK: bing with view model
extension DetailViewController{
    private func bindDataWithLbl() {
        self.searchViewModel.$currentCity.receive(on: DispatchQueue.main).sink { [weak self] city in
            guard let self = self, let city = city else{return}
            self.detailText.backgroundColor = .clear
            self.detailText.text = "City Name: \(city.name),\nWelcome Message: \(city.welcome.message)\nCountry Code: \(city.welcome.stations.first?.countryCode ?? "nothing")"
        }.store(in: &subscriptions)
    }
    
    private func bindErrorWithLBL() {
        self.searchViewModel.$err.receive(on: DispatchQueue.main).sink { [weak self] err in
            guard let self = self, let _ = err else{return}
            self.detailText.backgroundColor = UIColor.red
            self.detailText.text = err?.localizedDescription
        }.store(in: &subscriptions)
    }
}
