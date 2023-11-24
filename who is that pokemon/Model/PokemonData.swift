//
//  PokemonData.swift
//  who is that pokemon
//
//  Created by Liantony Pozo on 11/24/23.
//

import Foundation

// MARK: - PokemonData
struct PokemonData: Codable {
    let results: [Result]?
}

// MARK: - Result
struct Result: Codable {
    let name: String?
    let url: String?
}
