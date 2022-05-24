//
//  API.swift
//  FetchData
//
//  Created by Paradox Space Rumy M1 on 23/5/22.
//

import Foundation


struct AmbeeAPI{
    let headers:[String: String] = ["x-api-key":"f9b9baffa0a83743fcb8dbfd2bbd2594611c87429cdcaa19b5550fda6523a136",
                   "Content-type": "application/json"]
}

enum EndPoints : String{
    case scheme = "https"
    case host = "api.ambeedata.com"
    enum AllPath: String{
        case city = "/latest/by-city"
    }
}
