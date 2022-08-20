//
//  SelectedCharacterView.swift
//  RickAndMorty
//
//  Created by Александр Сенюк on 20.08.2022.
//

import SwiftUI

struct SelectedCharacterView: View {
  @State var selectedCharacter: CharacterModel
  @StateObject var alsoFromViewModel = AlsoFromViewModel()
  
  var body: some View {
    VStack {
      Text(selectedCharacter.name)
        .font(.largeTitle)
        .bold()
      HStack {
        AsyncImage(url: selectedCharacter.imageURL) { image in
          image.resizable()
            .aspectRatio(contentMode: .fit)
            .frame(maxWidth: 200, maxHeight: 200)
        } placeholder: {
          ProgressView()
        }
        VStack(alignment: .leading, spacing: 0) {
          Text("Last known location:")
            .foregroundColor(Color("OrangeColor"))
            .font(.headline)
          Text(selectedCharacter.location.name)
            .foregroundColor(.secondary)
            .font(.subheadline)
          if selectedCharacter.firstSeenEpisode.count > 0 {
            Text("First seen in:")
              .foregroundColor(Color("OrangeColor"))
              .font(.headline)
            Text(selectedCharacter.firstSeenEpisode)
              .foregroundColor(.secondary)
              .font(.subheadline)
          }
          Text("Status:")
            .foregroundColor(Color("OrangeColor"))
            .font(.headline)
          HStack {
            Circle()
              .foregroundColor(K.statusesColors[selectedCharacter.status])
              .frame(width: 10, height: 10)
            Text(selectedCharacter.status.rawValue)
              .foregroundColor(.secondary)
              .font(.subheadline)
          }
          
        }
      }
      if alsoFromViewModel.characters.count > 0 {
        Text("Also from \(selectedCharacter.location.name)")
          .font(.title)
      }
      List {
        ForEach(alsoFromViewModel.characters, id: \.id) { item in
          Button {
            swapSelectedCharacter(with: item)
          } label: {
            CharacterCardView(character: item)
          }
        }
      }
    }
    .onAppear(perform: fetchLocation)
  }
  
  private func fetchLocation() {
    Helpers.fetchData(with: selectedCharacter.location.url, completionHandler: fetchCharacters)
  }
  
  private func fetchCharacters(at location: LocationData) {
    if location.residents.count > 0 {
      let charactersIds = location.residents.map { item in
        item.replacingOccurrences(of: "\(K.URLS.characters)/", with: "")
      }.filter { item in
        item != String(selectedCharacter.id)
      }
      let charactersUrl = "\(K.URLS.characters)/\(charactersIds.joined(separator: ","))"
      if charactersIds.count == 1 {
        Helpers.fetchData(with: charactersUrl) { (dataResponse: CharacterData) in
          alsoFromViewModel.fetchEpisodes(for: [dataResponse])
        }
      } else {
        Helpers.fetchData(with: charactersUrl, completionHandler: alsoFromViewModel.fetchEpisodes)
      }
    } else {
      alsoFromViewModel.fetchEpisodes(for: [])
    }
  }
  
  private func swapSelectedCharacter(with character: CharacterModel) {
    alsoFromViewModel.swapCharacters(oldCharacter: selectedCharacter, newCharacter: character)
    selectedCharacter = character
  }
}

struct SelectedCharacterView_Previews: PreviewProvider {
  static var previews: some View {
    SelectedCharacterView(selectedCharacter: CharacterModel(id: 1, name: "Rick Sanchez", status: .Alive, location: LastKnownLocationData(name: "Citadel of Ricks", url: ""), firstSeenEpisode: "Pilot", imageURL: URL(string: "https://rickandmortyapi.com/api/character/avatar/1.jpeg")))
  }
}
