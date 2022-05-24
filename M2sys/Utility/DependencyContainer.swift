//
//  DependencyContainer.swift
//  M2sys
//
//  Created by Paradox Space Rumy M1 on 24/5/22.
//

import Foundation

protocol DIContainerProtocol {
  func register<Component>(type: Component.Type, component: Any)
  func resolve<Component>(type: Component.Type) -> Component?
}


final class DependencyContainer: DIContainerProtocol {
  static let shared = DependencyContainer()
  private init() {}
  var components: [String: Any] = [:]
  func register<Component>(type: Component.Type, component: Any) {
    components["\(type)"] = component
  }

  func resolve<Component>(type: Component.Type) -> Component? {
    return components["\(type)"] as? Component
  }
}
