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
    List {
      HStack(alignment: .top) {
        AsyncImage(url: selectedCharacter.imageURL) { image in
          image.resizable()
            .aspectRatio(contentMode: .fit)
            .frame(maxWidth: 125, maxHeight: 125)
            .cornerRadius(10)
        } placeholder: {
          ProgressView()
            .frame(width: 125, height: 125)
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
      .listRowSeparator(.hidden)
      Section(header: Text("Also from \"\(selectedCharacter.location.name)\"").font(.title).bold().foregroundColor(.primary)) {
        ForEach(alsoFromViewModel.characters, id: \.id) { item in
          Button {
            swapSelectedCharacter(with: item)
          } label: {
            CharacterCardView(character: item)
          }
        }
      }
      .listRowSeparator(.hidden)
    }
    .environment(\.defaultMinListRowHeight, 120)
    .listStyle(.inset)
    .navigationTitle(selectedCharacter.name)
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
