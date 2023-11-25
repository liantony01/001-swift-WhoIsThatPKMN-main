//
//  PokemonManager.swift
//  who is that pokemon
//
//  Created by Liantony Pozo on 11/24/23.
//

import Foundation

protocol PokemonManagerDelegate {
    func didUpdatePokemon(pokemons: [PokemonModel])
    func didFail(error: Error)
}

struct PokemonManager{
    let pokemonURL: String = "https://pokeapi.co/api/v2/pokemon?limit=1292&offset=0"
    var delegate: PokemonManagerDelegate?
    
    func fetchPokemon() {
        performRequest(with: pokemonURL)
    }
    
    func performRequest(with urlString: String) {
        // 1. Create/get URL
        if let url = URL(string: urlString) {
            // 2. Create the URLSession
            let session = URLSession(configuration: .default)
            // Create a data task from the URLSession.
            // This task will retrieve content from the URL, then execute the completion handler once done.
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil {
                    self.delegate?.didFail(error: error!)
                }
                
                if let safeData = data {
                    // Try to parse the JSON from 'safeData' using the 'parseJSON' method.
                    // If successful, it will return an array of 'PokemonModel' and assign it to 'pokemon'
                    if let pokemon = self.parseJSON(pokemonData: safeData) {
                        self.delegate?.didUpdatePokemon(pokemons: pokemon)
                    }
                }
                
            }
            // 4. Start the task
            task.resume()
        }
    }
    
    // Define a function 'parseJSON' that takes 'pokemonData' of type 'Data' as a parameter.
    // It attempts to decode the data into an array of 'PokemonModel' and returns it.
    // If the process fails, it returns 'nil'.
    
    func parseJSON(pokemonData: Data) -> [PokemonModel]? {
        let decoder = JSONDecoder()
        do {
            // Attempt to decode the 'pokemonData' into a 'PokemonData' structure.
            // The 'try' keyword is used because the decoding process can throw an error.

            let decodedData = try decoder.decode(PokemonData.self, from: pokemonData)
            // Map the 'results' from 'decodedData' to an array of 'PokemonModel'.
            // If a result has a 'nil' name or URL, it substitutes an empty string.
            
            let pokemon = decodedData.results?.map {
                PokemonModel(name: $0.name ?? "", imageUrl: $0.url ?? "")
            }
            return pokemon
        } catch {
            print(error)
            return nil
        }
    }
}
