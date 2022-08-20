//
//  ContentView.swift
//  RickAndMorty
//
//  Created by Александр Сенюк on 20.08.2022.
//

import SwiftUI

struct ContentView: View {
  @StateObject var charactersViewModel = CharactersViewModel()
  @State var nextPageUrl: String?
  
  var body: some View {
    NavigationView {
      List {
        ForEach(Array(charactersViewModel.characters.enumerated()), id: \.element.id) { index, item in
          NavigationLink {
            SelectedCharacterView(selectedCharacter: item)
          } label: {
            CharacterCardView(character: item)
              .onAppear {
                if index == charactersViewModel.characters.count - 1 {
                  if let urlString = nextPageUrl {
                    fetchCharactersPage(with: urlString)
                  }
                }
              }
          }
        }
      }
    }
    .onAppear {
      fetchCharactersPage(with: K.URLS.characters)
    }
  }
  
  private func fetchCharactersPage(with stringUrl: String) {
    Helpers.fetchData(with: stringUrl, completionHandler: updateCharacters)
  }
  
  private func updateCharacters(with characters: CharactersData) {
    charactersViewModel.fetchEpisodes(for: characters.results)
    DispatchQueue.main.async {
      self.nextPageUrl = characters.info.next
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
