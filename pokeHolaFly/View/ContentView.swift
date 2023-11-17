//
//  ContentView.swift
//  pokeHolaFly
//
//  Created by Daniel Murcia Almanza on 16/11/23.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var vm: PokemonsVM
    
    let itemAdaptative = GridItem(.adaptive(minimum: 150))
    let itemAdaptativeTypes = GridItem(.adaptive(minimum: 80))
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid (columns: [itemAdaptative], spacing: 8, content: {
                    ForEach(vm.pokemons) { pokemon in
                        VStack(alignment: .leading) {
                            HStack {
                                Spacer()
                                AsyncImage(url: pokemon.sprites.frontDefault) { image in
                                    image
                                        .resizable()
                                        .frame(width: 100, height: 100)
                                        .scaledToFit()
                                } placeholder: {
                                    Image(systemName: "tortoise")
                                        .symbolVariant(.circle)
                                }
                                Spacer()
                            }
                            .padding(.top, 10)
                            Text("\(pokemon.id)")
                                .font(.caption2)
                                .foregroundStyle(.secondary)
                                .padding(.leading, 8)
                            Text(pokemon.name.capitalized)
                                .font(.headline)
                                .padding(.leading, 8)
                            LazyHGrid(rows: [itemAdaptativeTypes]) {
                                ForEach(pokemon.types) { type in
                                    Text(type.name.capitalized)
                                        .font(.caption)
                                        .padding(6)
                                        .background {
                                            RoundedRectangle(cornerRadius: 8)
                                                .fill(vm.getColorBackground(type: type))
                                        }
                                }
                            }
                            .padding([.leading, .trailing, .bottom], 8)
                        }
                        .background {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(vm.getColorBackground(type: pokemon.types.first ?? TypeElement(slot: 1, name: "")))
                        }
                     
                    }
                })
                .padding(12)
                .navigationTitle("POKEDESK")
            }
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(PokemonsVM.test)
}
