//
//  StorageService.swift
//  Persistant Demo
//
//  Created by Joshua Homann on 7/25/20.
//

import Foundation

protocol StorageService {
  func save<SomeCodable: Codable>(_: SomeCodable, key: String) throws
  func load<SomeCodable: Codable>(_: SomeCodable.Type, key: String) throws -> SomeCodable?
}

final class MockStorageService: StorageService {
  private var storage: [String: Any] = [:]

  func save<SomeCodable: Codable>(_ value: SomeCodable, key: String) throws {
    storage[key] = value
  }

  func load<SomeCodable: Codable>(_ type: SomeCodable.Type, key: String) throws -> SomeCodable? {
    storage[key] as? SomeCodable
  }
}

final class UserDefaultsStorageService: StorageService {
  private let defaults: UserDefaults
  private let encoder: JSONEncoder
  private let decoder: JSONDecoder

  init(
    defaults: UserDefaults = .standard,
    encoder: JSONEncoder = JSONEncoder(),
    decoder: JSONDecoder = JSONDecoder()
  ) {
    self.defaults = defaults
    self.encoder = encoder
    self.decoder = decoder
  }

  func save<SomeCodable: Codable>(_ value: SomeCodable, key: String) throws {
    defaults.set(try encoder.encode(value), forKey: key)
  }

  func load<SomeCodable: Codable>(_ type: SomeCodable.Type, key: String) throws -> SomeCodable? {
    try defaults
      .data(forKey: key)
      .map { try decoder.decode(SomeCodable.self, from: $0) }
  }
}

final class FileStorageService: StorageService {
  private let filename: String
  private let encoder: JSONEncoder
  private let decoder: JSONDecoder

  init(
    filename: String,
    encoder: JSONEncoder = JSONEncoder(),
    decoder: JSONDecoder = JSONDecoder()
  ) {
    self.filename = filename
    self.encoder = encoder
    self.decoder = decoder
  }

  func save<SomeCodable: Codable>(_ value: SomeCodable, key: String) throws {
    let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor:nil, create:false)
    let fileURL = documentDirectory.appendingPathComponent(filename)
    let data = try encoder.encode(value)
    try data.write(to: fileURL)
  }

  func load<SomeCodable: Codable>(_ type: SomeCodable.Type, key: String) throws -> SomeCodable? {
    let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor:nil, create:false)
    let fileURL = documentDirectory.appendingPathComponent(filename)
    let data = try Data(contentsOf: fileURL)
    return try decoder.decode(type, from: data)
  }
}

@dynamicMemberLookup final class Stored<SomeCodable: Codable> {
  private var storedValue: SomeCodable
  private let key: String
  private let storage: StorageService
  init(
    defaultValue: SomeCodable,
    key: String = String(reflecting: SomeCodable.self),
    storage: StorageService
  ) {
    self.key = key
    self.storage = storage
    self.storedValue = (try? storage.load(SomeCodable.self, key: key)) ?? defaultValue
  }

  subscript<Value> (dynamicMember keyPath: WritableKeyPath<SomeCodable, Value>) -> Value {
    get {
      storedValue[keyPath: keyPath]
    }
    set {
      storedValue[keyPath: keyPath] = newValue
      try? storage.save(storedValue, key: key)
    }
  }
}

