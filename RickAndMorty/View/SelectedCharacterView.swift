//
//  SelectedCharacterView.swift
//  RickAndMorty
//
//  Created by Александр Сенюк on 20.08.2022.
//

import SwiftUI
import Kingfisher

struct SelectedCharacterView: View {
  @State var selectedCharacter: CharacterModel
  @StateObject var alsoFromVM = AlsoFromViewModel()

  var body: some View {
    ScrollViewReader { proxy in
      List {
        HStack(alignment: .top) {
          KFImage(selectedCharacter.imageURL)
            .resizable()
            .placeholder({
              ProgressView()
            })
            .aspectRatio(contentMode: .fit)
            .frame(width: 125, height: 125)
            .cornerRadius(10)
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
        .id(1)
        .listRowSeparator(.hidden)
        if alsoFromVM.characters.count > 0 {
          Section {
            ForEach(alsoFromVM.characters, id: \.id) { item in
              Button {
                swapSelectedCharacter(with: item)
                withAnimation {
                  proxy.scrollTo(1, anchor: .top)
                }
              } label: {
                CharacterCardView(character: item)
              }
            }
          } header: {
            Text("Also from \"\(selectedCharacter.location.name)\"")
              .font(.title)
              .bold()
              .foregroundColor(.primary)
          }
          .listRowSeparator(.hidden)
        }
        if alsoFromVM.isLoading {
          ProgressView()
            .frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
            .listRowSeparator(.hidden)
        }
      }
      .environment(\.defaultMinListRowHeight, 120)
      .listStyle(.inset)
    }
    .navigationTitle(selectedCharacter.name)
    .onAppear {
      alsoFromVM.fetchLocation(for: selectedCharacter)
    }
  }

  private func swapSelectedCharacter(with character: CharacterModel) {
    alsoFromVM.swapCharacters(oldCharacter: selectedCharacter, newCharacter: character)
    selectedCharacter = character
  }
}

struct SelectedCharacterView_Previews: PreviewProvider {
  static var previews: some View {
    SelectedCharacterView(selectedCharacter: CharacterModel(id: 1, name: "Rick Sanchez", status: .Alive, location: LastKnownLocationData(name: "Citadel of Ricks", url: ""), firstSeenEpisode: "Pilot", imageURL: URL(string: "https://rickandmortyapi.com/api/character/avatar/1.jpeg")))
  }
}
