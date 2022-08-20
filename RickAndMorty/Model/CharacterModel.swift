//
//  CharacterModel.swift
//  RickAndMorty
//
//  Created by Александр Сенюк on 20.08.2022.
//

import Foundation

struct CharacterModel {
  var id: Int
  var name: String
  var status: StatusData
  var location: LastKnownLocationData
  var firstSeenEpisode: String
  var imageURL: URL?
}
