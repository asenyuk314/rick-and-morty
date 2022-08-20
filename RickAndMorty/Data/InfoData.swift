//
//  InfoData.swift
//  RickAndMorty
//
//  Created by Александр Сенюк on 20.08.2022.
//

import Foundation

struct InfoData: Decodable {
  var count: Int
  var pages: Int
  var next: String?
  var prev: String?
}
