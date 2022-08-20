//
//  LocationData.swift
//  RickAndMorty
//
//  Created by Александр Сенюк on 20.08.2022.
//

import Foundation

struct LocationData: Decodable {
  var id: Int
  var name: String
  var residents: [String]
}
