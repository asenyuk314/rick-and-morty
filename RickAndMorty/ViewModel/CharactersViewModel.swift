//
//  CharactersViewModel.swift
//  RickAndMorty
//
//  Created by Александр Сенюк on 20.08.2022.
//

import Foundation

class CharactersViewModel: ObservableObject {
  @Published var characters: [CharacterModel] = []
  @Published var isLoading = false

  func fetchEpisodes(for characters: [CharacterData]) {
    var episodesSet: Set<String> = []
    characters.forEach { character in
      if let firstEpisode = character.episode.first {
        let episodeNumber = firstEpisode.replacingOccurrences(of: "\(K.URLS.episodes)/", with: "")
        episodesSet.insert(episodeNumber)
      }
    }
    let episodesUrl = "\(K.URLS.episodes)/\(episodesSet.joined(separator: ","))"
    if episodesSet.count == 1 {
      Helpers.fetchData(with: episodesUrl) { (dataResponse: EpisodeData) in
        self.parseCharacters(characters: characters, episodes: [dataResponse])
      } errorHandler: {
        self.fetchErrorHandler()
      }
    } else {
      Helpers.fetchData(with: episodesUrl) { (dataResponse: [EpisodeData]) in
        self.parseCharacters(characters: characters, episodes: dataResponse)
      } errorHandler: {
        self.fetchErrorHandler()
      }
    }
  }

  private func parseCharacters(characters: [CharacterData], episodes: [EpisodeData]) {
    var episodesDict: [String : String] = [:]
    episodes.forEach { episode in
      episodesDict.updateValue(episode.name, forKey: "\(K.URLS.episodes)/\(episode.id)")
    }
    let nextCharacters: [CharacterModel] = characters.map { character in
      CharacterModel(id: character.id, name: character.name, status: character.status, location: character.location, firstSeenEpisode: episodesDict[character.episode.first ?? ""] ?? "", imageURL: URL(string: character.image))
    }
    updateCharacters(with: nextCharacters)
  }

  func updateCharacters(with characters: [CharacterModel]) {
    setIsLoading(false)
  }

  func fetchErrorHandler() {
    setIsLoading(false)
  }

  func setIsLoading(_ nextIsLoading: Bool) {
    DispatchQueue.main.async {
      self.isLoading = nextIsLoading
    }
  }
}
