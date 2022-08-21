//
//  Helpers.swift
//  RickAndMorty
//
//  Created by Александр Сенюк on 20.08.2022.
//

import Foundation

class Helpers {
  static func fetchData<T: Decodable>(with urlString: String, completionHandler: @escaping ((_ dataResponse: T) -> Void), errorHandler: @escaping () -> Void) {
    if let url = URL(string: urlString) {
      let session = URLSession(configuration: .default)
      let task = session.dataTask(with: url) { data, response, error in
        if error != nil {
          return errorHandler()
        }
        guard let decodedData: T = self.parseJSON(data) else {
          return errorHandler()
        }
        completionHandler(decodedData)
      }
      task.resume()
    }
  }

  static func parseJSON<T: Decodable>(_ data: Data?) -> T? {
    guard let safeData = data else {
      return nil
    }
    let decoder = JSONDecoder()
    do {
      let decodedData = try decoder.decode(T.self, from: safeData)
      return decodedData
    } catch {
      return nil
    }
  }
}
