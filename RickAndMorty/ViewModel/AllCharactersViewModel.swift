//
//  AllCharactersViewModel.swift
//  RickAndMorty
//
//  Created by Александр Сенюк on 21.08.2022.
//

import Foundation

class AllCharactersViewModel: CharactersViewModel {
  var nextPageUrl: String? = K.URLS.characters

  func fetchCharactersPage() {
    if let urlString = nextPageUrl {
      setIsLoading(true)
      Helpers.fetchData(with: urlString, completionHandler: parseResults, errorHandler: fetchErrorHandler)
    }
  }

  private func parseResults(for charactersPage: CharactersData) {
    nextPageUrl = charactersPage.info.next
    fetchEpisodes(for: charactersPage.results)
  }

  override func updateCharacters(with characters: [CharacterModel]) {
    super.updateCharacters(with: characters)
    DispatchQueue.main.async {
      self.characters.append(contentsOf: characters)
    }
  }
}
