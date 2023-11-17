//
//  ContentView.swift
//  pokeHolaFly
//
//  Created by Daniel Murcia Almanza on 16/11/23.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var vm: PokemonsVM
    @State var pokemonSearch: String = ""
    
    let itemAdaptative = GridItem(.adaptive(minimum: 150))

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid (columns: [itemAdaptative], spacing: 8, content: {
                    ForEach(vm.pokemons) { pokemon in
                        NavigationLink(value: pokemon) {
                            PokemonCell(pokemon: pokemon)
                        }
                        .buttonStyle(.plain)
                    }
                })
                .padding(12)
                .navigationTitle("POKEDESK")
            }
            .navigationDestination(for: Pokemon.self) { pokemon in
                PokemonDetailView(pokemon: pokemon)
            }
        }
        .searchable(text: $pokemonSearch)

    }
}

#Preview {
    ContentView()
        .environmentObject(PokemonsVM.test)
}

