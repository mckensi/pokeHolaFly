//
//  PokemonDetailVM.swift
//  pokeHolaFly
//
//  Created by Alex Murcia on 19/11/23.
//

import SwiftUI
import Combine

final class PokemonDetailVM: ObservableObject {
    let network: DataInteractor
    let pokemon: Pokemon
    
    @Published var movesDetails: [MoveDetail] = []
    @Published var alertMsg: String = ""
    @Published var showAlert: Bool = false
    
    var subscribers = Set<AnyCancellable>()
    
    init(network: DataInteractor = Network(), pokemon: Pokemon) {
        self.network = network
        self.pokemon = pokemon
    
        getMovesDetails()
    }

    private func getMovesDetails() {
        var movesUrls: [URL?] = []
        
        pokemon.moves.forEach { move in
            movesUrls.append(move.url)
        }
        
        let publishers = network.getMoveDetail(urls: movesUrls)
        
        let publisherMerged = Publishers.MergeMany(publishers)
        
        publisherMerged
            .collect()
            .sink { completion in
                if case .failure(let error) = completion, let networkErr = error as? NetworkError {
                    self.alertMsg = "\(networkErr.description)"
                    self.showAlert.toggle()
                }
            } receiveValue: { moveDetails in
                DispatchQueue.main.async {
                    let moveDetails = moveDetails.map { $0.toPresentation }.sorted { $0.id < $1.id }
                    self.movesDetails.append(contentsOf: moveDetails)
                }

            }
            .store(in: &subscribers)
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
        
        func getMovesDetails() {
            target.getMovesDetails()
        }
    }
}
#endif
