//
//  CharactersData.swift
//  RickAndMorty
//
//  Created by Александр Сенюк on 20.08.2022.
//

import Foundation

struct CharactersData: Decodable {
  var info: InfoData
  var results: [CharacterData]
}
