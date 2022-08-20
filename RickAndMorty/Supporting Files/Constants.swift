//
//  Constants.swift
//  RickAndMorty
//
//  Created by Александр Сенюк on 20.08.2022.
//

import SwiftUI

struct K {
  struct URLS {
    static let main = "https://rickandmortyapi.com/api"
    static let characters = "\(main)/character"
    static let episodes = "\(main)/episode"
  }
  
  static let statusesColors: [StatusData : Color] = [
    .Alive: .green,
    .Dead: .red,
    .unknown: .gray
  ]
}
