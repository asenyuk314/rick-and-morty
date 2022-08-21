//
//  CharacterCardView.swift
//  RickAndMorty
//
//  Created by Александр Сенюк on 20.08.2022.
//

import SwiftUI

struct CharacterCardView: View {
  let character: CharacterModel

  var body: some View {
    HStack {
      AsyncImage(url: character.imageURL) { image in
        image.resizable()
          .aspectRatio(contentMode: .fit)
          .frame(maxWidth: 100, maxHeight: 100)
      } placeholder: {
        ProgressView()
          .frame(width: 100, height: 100)
      }

      VStack(alignment: .leading) {
        Text(character.name)
          .foregroundColor(Color("OrangeColor"))
          .font(.title2)
          .bold()
        Text(character.location.name)
          .foregroundColor(.secondary)
          .font(.headline)
        if character.firstSeenEpisode.count > 0 {
          Text("Episode:")
            .foregroundColor(.secondary)
            .font(.headline)
          Text(character.firstSeenEpisode)
            .foregroundColor(.secondary)
            .font(.subheadline)
        }
      }
    }
    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 100, maxHeight: 100, alignment: .leading)
    .background(.white)
    .cornerRadius(10)
    .shadow(color: .gray, radius: 10, x: 0, y: 10)
  }
}

struct CharacterCardView_Previews: PreviewProvider {
  static var previews: some View {
    CharacterCardView(character: CharacterModel(id: 1, name: "Rick Sanchez", status: .Alive, location: LastKnownLocationData(name: "Citadel of Ricks", url: ""), firstSeenEpisode: "Pilot", imageURL: URL(string: "https://rickandmortyapi.com/api/character/avatar/1.jpeg")))
  }
}
