//
//  DataModel.swift
//  Persistant Demo
//
//  Created by John James Retina on 7/18/20.
//

import Foundation
import Combine

class UserSettings: ObservableObject {

  struct Settings: Codable {
    var username = ""
    var isPrivate = true
    var ringtone = "Chimes"
    var counter = 0
  }

  @Published var settings: Stored<Settings>

  let ringtones = ["Chimes", "Signal", "Waves"]
  let storageService: StorageService
  
  init(storageService: StorageService) {
    self.storageService = storageService
    settings = .init(defaultValue: Settings(), storage: storageService)
  }
  
  func incrementCounter()  {
    settings.counter += 1
  }
  func decrementCounter()  {
    settings.counter -= 1
  }
}
