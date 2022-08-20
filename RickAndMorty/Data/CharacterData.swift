//
//  CharacterData.swift
//  RickAndMorty
//
//  Created by Александр Сенюк on 20.08.2022.
//

import Foundation

struct CharacterData: Decodable {
  var id: Int
  var name: String
  var status: StatusData
  var location: LastKnownLocationData
  var episode: [String]
  var image: String
}
