//
//  City.swift
//  M2sys
//
//  Created by Paradox Space Rumy M1 on 24/5/22.
//


import Foundation

// MARK: - City
struct City: Codable{
    let name: String
    let welcome: Welcome
}

// MARK: - Welcome
struct Welcome: Codable {
    let message: String
    let stations: [Station]
}

// MARK: - Station
struct Station: Codable {
    let co, no2, ozone, pm10: Double
    let pm25, so2: Double
    let city, countryCode, division: String
    let lat, lng: Double
    let placeName, postalCode, state, updatedAt: String
    let aqi: Int
    let aqiInfo: AqiInfo

    enum CodingKeys: String, CodingKey {
        case co = "CO"
        case no2 = "NO2"
        case ozone = "OZONE"
        case pm10 = "PM10"
        case pm25 = "PM25"
        case so2 = "SO2"
        case city, countryCode, division, lat, lng, placeName, postalCode, state, updatedAt
        case aqi = "AQI"
        case aqiInfo
    }
}

// MARK: - AqiInfo
struct AqiInfo: Codable {
    let pollutant: String
    let concentration: Double
    let category: String
}

