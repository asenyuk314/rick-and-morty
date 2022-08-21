//
//  AlsoFromViewModel.swift
//  RickAndMorty
//
//  Created by Александр Сенюк on 20.08.2022.
//

import Foundation

class AlsoFromViewModel: CharactersViewModel {
  override func updateCharacters(with characters: [CharacterModel]) {
    super.updateCharacters(with: characters)
    DispatchQueue.main.async {
      self.characters = characters
    }
  }

  func fetchLocation(for character: CharacterModel) {
    if character.location.url.count > 0 {
      setIsLoading(true)
      Helpers.fetchData(with: character.location.url) { dataResponse in
        self.fetchCharacters(at: dataResponse, prohibitedId: character.id)
      } errorHandler: {
        self.fetchErrorHandler()
      }
    }
  }

  private func fetchCharacters(at location: LocationData, prohibitedId: Int) {
    let charactersIds = location.residents.map { item in
      item.replacingOccurrences(of: "\(K.URLS.characters)/", with: "")
    }.filter { item in
      item != String(prohibitedId)
    }
    let charactersUrl = "\(K.URLS.characters)/\(charactersIds.joined(separator: ","))"

    switch charactersIds.count {
    case 0:
      updateCharacters(with: [])
    case 1:
      Helpers.fetchData(with: charactersUrl) { (dataResponse: CharacterData) in
        self.fetchEpisodes(for: [dataResponse])
      } errorHandler: {
        self.fetchErrorHandler()
      }
    default:
      Helpers.fetchData(with: charactersUrl, completionHandler: fetchEpisodes, errorHandler: fetchErrorHandler)
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
