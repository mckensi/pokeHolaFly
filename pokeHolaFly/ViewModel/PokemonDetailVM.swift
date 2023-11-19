//
//  PokemonDetailVM.swift
//  pokeHolaFly
//
//  Created by Alex Murcia on 19/11/23.
//

import SwiftUI

final class PokemonDetailVM: ObservableObject {
    let network: DataInteractor
    let pokemon: Pokemon
    
    @Published var movesDetails: [MoveDetail] = []
    @Published var alertMsg: String = ""
    @Published var showAlert: Bool = false
    
    init(network: DataInteractor = Network(), pokemon: Pokemon) {
        self.network = network
        self.pokemon = pokemon
        
        Task {
            await getMovesDetails()
        }
        
    }

    private func getMovesDetails() async {
        var movesUrls: [URL?] = []
        
        pokemon.moves.forEach { move in
            movesUrls.append(move.url)
        }

        do {
            let movesDetails = try await network.getMoveDetail(urls: movesUrls)
            await MainActor.run {
                self.movesDetails = movesDetails
            }
        } catch {
            print(error)
            await MainActor.run {
                self.alertMsg = "\(error)"
                self.showAlert.toggle()
            }
        }
    }
}

#if DEBUG
extension PokemonDetailVM {
    var testHooks: TestHooks {
        return TestHooks(target: self)
    }
    
    struct TestHooks {
        private let target: PokemonDetailVM
        
        fileprivate init(target: PokemonDetailVM) {
            self.target = target
        }
        
        func getMovesDetails() async {
            await target.getMovesDetails()
        }
    }
}
#endif
