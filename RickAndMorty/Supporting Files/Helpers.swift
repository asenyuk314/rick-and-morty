//
//  Helpers.swift
//  RickAndMorty
//
//  Created by Александр Сенюк on 20.08.2022.
//

import Foundation

class Helpers {
  static func fetchData<T: Decodable>(with urlString: String, completionHandler: @escaping ((_ dataResponse: T) -> Void)) {
    if let url = URL(string: urlString) {
      let session = URLSession(configuration: .default)
      let task = session.dataTask(with: url) { data, response, error in
        if error != nil {
          print("fetchData Error: \(error!)")
        }
        if let safeData = data {
          if let characters: T = self.parseJSON(safeData) {
            completionHandler(characters)
          }
        }
      }
      task.resume()
    }
  }

  static func parseJSON<T: Decodable>(_ data: Data) -> T? {
    let decoder = JSONDecoder()
    do {
      let decodedData = try decoder.decode(T.self, from: data)
      return decodedData
    } catch {
      print("parseJSON Error: \(error)")
      return nil
    }
  }
}
