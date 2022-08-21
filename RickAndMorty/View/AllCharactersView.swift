//
//  AllCharactersView.swift
//  RickAndMorty
//
//  Created by Александр Сенюк on 20.08.2022.
//

import SwiftUI

struct AllCharactersView: View {
  @StateObject var allCharactersVM = AllCharactersViewModel()

  var body: some View {
    NavigationView {
      List {
        ForEach(Array(allCharactersVM.characters.enumerated()), id: \.element.id) { index, item in
          ZStack {
            CharacterCardView(character: item)
              .onAppear {
                if index == allCharactersVM.characters.count - 1 {
                  allCharactersVM.fetchCharactersPage()
                }
              }
            NavigationLink(destination: SelectedCharacterView(selectedCharacter: item)) {
              EmptyView()
            }
            .opacity(0)
          }
          .listRowSeparator(.hidden)
        }
        if allCharactersVM.isLoading {
          ProgressView()
            .frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
            .listRowSeparator(.hidden)
        }
      }
      .environment(\.defaultMinListRowHeight, 120)
      .listStyle(.inset)
      .navigationTitle("Rick and Morty")
    }
    .onAppear(perform: allCharactersVM.fetchCharactersPage)
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    AllCharactersView()
  }
}
