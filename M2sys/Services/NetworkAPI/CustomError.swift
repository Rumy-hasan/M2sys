//
//  CustomError.swift
//  FetchData
//
//  Created by Paradox Space Rumy M1 on 23/5/22.
//

import Foundation

enum NetworkError: Error {
  case parsing(description: String)
  case network(description: String)
}
