//
//  CityDataFatcher.swift
//  FetchData
//
//  Created by Paradox Space Rumy M1 on 23/5/22.
//

import Foundation

final class CityDataFatcher{
    private let session: URLSession
    private let decoder = JSONDecoder()
    private let api = AmbeeAPI()
    init(session: URLSession = .shared) {
        self.session = session
    }
}


extension CityDataFatcher{
    func fetch(with city: String, completionHandler: @escaping (City?, NetworkError?) -> Void){
        let component = makeCityDataComponents(withCity: city)
        var error:NetworkError! = nil
        guard let url = component.url else {
            error = NetworkError.network(description: "Couldn't create URL")
            DispatchQueue.main.async {
                completionHandler(nil,error)
            }
            return
        }
        
        let request = getRequest(with: url)
        
        session.dataTask(with: request) { [weak self] jsonData, res, err in
            guard let self = self else {return}
            if(err != nil){
                error = NetworkError.network(description: err!.localizedDescription)
            }else if let response = res as? HTTPURLResponse, !response.isResponseOK(){
                error = NetworkError.network(description: HTTPURLResponse.localizedString(forStatusCode: response.statusCode))
            }else{
                do{
                    let welcome = try self.decoder.decode(Welcome.self, from: jsonData!)
                    let city = City(name: city, welcome: welcome)
                    DispatchQueue.main.async {
                        completionHandler(city,nil)
                    }
                }catch let err{
                    error = .parsing(description: err.localizedDescription)
                }
            }
            if error != nil {
                DispatchQueue.main.async {
                    completionHandler(nil,error)
                }
            }
        }.resume()
    }
}


//MARK: create components and resuest
extension CityDataFatcher{
    private func makeCityDataComponents(
        withCity city: String
    ) -> URLComponents {
        var components = URLComponents()
        components.scheme = EndPoints.scheme.rawValue
        components.host = EndPoints.host.rawValue
        components.path = EndPoints.AllPath.city.rawValue
        components.port = nil
        
        components.queryItems = [
            URLQueryItem(name: "city", value: city)
        ]
        return components
    }
    
    private func getRequest(with url: URL)->URLRequest{
        var request = URLRequest(url: url)
        for (key,value) in api.headers {
            request.setValue(value, forHTTPHeaderField: key)
        }
        return request
    }
}
