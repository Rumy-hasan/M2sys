//
//  SearchViewModel.swift
//  M2sys
//
//  Created by Paradox Space Rumy M1 on 24/5/22.
//

import Foundation
import Combine
import UIKit

final class SearchViewModel: NSObject{
    @Published private(set) var filteredCities:[String] = []
    @Published private(set) var currentCity: City? = nil
    @Published private(set) var err: NetworkError? = nil
    private var allCity: [String] = [String](){
        didSet{
            filteredCities = allCity
        }
    }
    private(set) var searchField: String = ""
    private let networkApi: CityDataFatcher
    private var sharedCache:Cache<String, Any>
    
    init(with api: CityDataFatcher){
        networkApi = api
        DependencyContainer.shared.register(type: CityDataFatcher.self, component: networkApi)
        
        if let haveSharedCache = DependencyContainer.shared.resolve(type: Cache<String, Any>.self){
            self.sharedCache = haveSharedCache
        }else{
            self.sharedCache = Cache<String,Any>()
            DependencyContainer.shared.register(type: Cache<String, Any>.self, component: self.sharedCache)
        }
        super.init()
        allCity = fetchAllValidCities() ?? []
        self.sharedCache.cacheDelegate = self
    }
    
    
    
    func searchForKey() {
        if let dataIsInLocal = self.checkDataAvailability(for: searchField) {
            self.currentCity = dataIsInLocal
        }else{
            self.callNetwork()
        }
    }
}

//MARK: Access network layer
extension SearchViewModel{
    private func callNetwork(){
        networkApi.fetch(with: searchField) { [weak self] city, err in
            guard let self = self else{ return }
            if let city = city{
                self.sharedCache.removeValue(forKey: city.name)
                self.sharedCache.insert(city, forKey: city.name)
                self.cacheValidSearch(for: city.name)
                self.currentCity = city
            }else{
                self.err = err
            }
        }
    }
}


//MARK: Search bar delegates
extension SearchViewModel: UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchField = searchText
        if searchText == ""  {
            filteredCities = allCity
        }else{
            filteredCities = []
            for eachCity in allCity {
                if eachCity.uppercased().contains(searchText.uppercased()) {
                    filteredCities.append(eachCity)
                }
            }
        }
    }
}



//MARK: Cache
extension SearchViewModel: CacheUpdate{
    func isCacheUpdate() {
        self.allCity = self.fetchAllValidCities() ?? []
    }
    
    private func checkDataAvailability(for city: String) -> City? {
        return sharedCache[city] as? City
    }
    
    private func cacheValidSearch(for city: String){
        if var dataArray = self.sharedCache[CacheEnum.validSearch.rawValue] as? [String] {
            dataArray.append(city)
            sharedCache.insert(dataArray, forKey: CacheEnum.validSearch.rawValue)
        }else{
            sharedCache.insert([city], forKey: CacheEnum.validSearch.rawValue)
        }
    }
    
    private func fetchAllValidCities()->[String]?{
        return sharedCache[CacheEnum.validSearch.rawValue] as? [String]
    }
}
