//
//  PokemonCell.swift
//  pokeHolaFly
//
//  Created by Daniel Murcia Almanza on 17/11/23.
//

import SwiftUI

struct PokemonCell: View {
    
    let pokemon: Pokemon
    
    let itemAdaptativeTypes = GridItem(.adaptive(minimum: 80))
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Spacer()
                Text("\(pokemon.id)")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                    .padding([.trailing, .top], 8)
            }
            HStack {
                Spacer()
                AsyncImage(url: pokemon.sprites.frontDefault) { image in
                    image
                        .resizable()
                        .frame(width: 100, height: 100)
                        .scaledToFit()
                } placeholder: {
                    Image(systemName: "tortoise")
                        .resizable()
                        .symbolVariant(.circle)
                        .frame(width: 100, height: 100)
                        .opacity(0.1)
                }
                Spacer()
            }
            .padding(.top, 10)
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
                                .fill(getColorBackgroundType(type: type))
                        }
                }
            }
            .padding([.leading, .trailing, .bottom], 8)
        }
        .background {
            RoundedRectangle(cornerRadius: 10)
                .fill(getColorBackground(type: pokemon.types.first ?? TypeElement(slot: 1, name: "")))
        }
    }
}

#Preview {
    PokemonCell(pokemon: .test)
}
