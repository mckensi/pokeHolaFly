//
//  PokemonDetailView.swift
//  pokeHolaFly
//
//  Created by Daniel Murcia Almanza on 17/11/23.
//

import SwiftUI

struct PokemonDetailView: View {
    
    @State private var scrollOffset: CGFloat = 0.0
    @State private var minOffset: CGFloat = 0.0
    let itemAdaptativeTypes = GridItem(.adaptive(minimum: 80))
    
    var pokemon: Pokemon
    var body: some View {
        ZStack {
            VStack {
                if scrollOffset > 0 && scrollOffset < 1000 {
                    Rectangle()
                        .fill(getColorBackground(type: pokemon.types.first ?? TypeElement(slot: 1, name: "")))
                        .frame(height: max(min(scrollOffset, 1000), 0))
                }
                Spacer()
            }
            .ignoresSafeArea()
            ScrollView {
                VStack(alignment: .leading) {
                    HStack {
                        Spacer()
                        AsyncImage(url: pokemon.sprites.other.officialArtwork.frontDefault) { image in
                            image
                                .resizable()
                                .scaledToFit()
                                .frame(width: 200, height: 240, alignment: .center)
                        } placeholder: {
                            EmptyView()
                        }
                        Spacer()
                    }
                    .background(getColorBackground(type: pokemon.types.first ?? TypeElement(slot: 1, name: "")))
                    .ignoresSafeArea()
                    Text("Stats")
                        .font(.title3)
                        .padding(.leading)
                    VStack(alignment: .leading) {
                        ForEach(pokemon.stats) { stat in
                            HStack {
                                Text(stat.name)
                                    .frame(width: 100, alignment: .leading)
                                    .font(.footnote)
                                HStack {
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(Color(white: 0.9))
                                        .frame(width: 200)
                                        .overlay {
                                            HStack {
                                                RoundedRectangle(cornerRadius: 8)
                                                    .fill(getColorBackground(type: pokemon.types.first ?? TypeElement(slot: 1, name: "")))
                                                    .frame(width: CGFloat( 200 * stat.baseStat / 100))
                                                Spacer()
                                            }
                                        }
                                }
                            }
                            .padding(.trailing, 10)
                         
                        }
                    }
                    .padding(.leading)
                    Text("Abilities")
                        .font(.title3)
                        .padding(.leading)
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
                    .padding(.leading)
                    Text("Moves")
                        .font(.title3)
                        .padding(.leading)
                    VStack(alignment: .leading) {
                        ForEach(pokemon.moves) { move in
                            Text(move.name)
                                .font(.footnote)
                        }
                    }
                    .padding(.leading)
                }
                .navigationTitle(pokemon.name.capitalized)
                .navigationBarTitleDisplayMode(.inline)
                .background(
                    GeometryReader { geometry -> Color in
                        let minY = geometry.frame(in: .global).minY
                        DispatchQueue.main.async {
                            if minY > 0 {
                                self.scrollOffset = minY
                            }
                        }
                        return Color.clear
                    }
                )
            }
            .safeAreaInset(edge: .top, spacing: 0) {
                Rectangle()
                    .fill(getColorBackground(type: pokemon.types.first ?? TypeElement(slot: 1, name: "")))
                    .frame(height: UIDevice.topInsetSize)
            }
        .ignoresSafeArea()
        }
    }
}

#Preview {
    NavigationStack {
        PokemonDetailView(pokemon: .test)
    }
}

