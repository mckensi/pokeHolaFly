//
//  PokemonsVM.swift
//  pokeHolaFly
//
//  Created by Daniel Murcia Almanza on 16/11/23.
//

import SwiftUI

final class PokemonsVM: ObservableObject {
    let network: DataInteractor
    
    @Published var pokemons: [Pokemon] = []
    
    init(network: DataInteractor = Network()) {
        self.network = network
        
        Task { await getPokemons() }
    }
    
    func getPokemons() async {
        do {
            let pokemons = try await network.getPokemonsList()
            await MainActor.run {
                self.pokemons = pokemons.sorted { $0.id < $1.id }
            }
        } catch {
            print(error)
//            await MainActor.run {
//                self.msg = "\(error)"
//                self.showAlert.toggle()
//            }
        }
    }
    
}
