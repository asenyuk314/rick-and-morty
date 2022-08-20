//
//  AlsoFromViewModel.swift
//  RickAndMorty
//
//  Created by Александр Сенюк on 20.08.2022.
//

import Foundation

class AlsoFromViewModel: CharactersViewModel {
  override func updateCharacters(with characters: [CharacterModel]) {
    DispatchQueue.main.async {
      self.characters = characters
    }
  }
  
  func swapCharacters(oldCharacter: CharacterModel, newCharacter: CharacterModel) {
    var filteredCharacters = characters.filter { character in
      character.id != newCharacter.id
    }
    filteredCharacters.append(oldCharacter)
    characters = filteredCharacters.sorted(by: { a, b in
      a.id < b.id
    })
  }
}
