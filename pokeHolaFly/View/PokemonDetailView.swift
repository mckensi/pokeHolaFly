//
//  PokemonDetailView.swift
//  pokeHolaFly
//
//  Created by Daniel Murcia Almanza on 17/11/23.
//

import SwiftUI

struct PokemonDetailView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var pokemonDetailVM: PokemonDetailVM
    
    @State private var scrollOffset: CGFloat = 0.0
    @State private var minOffset: CGFloat = 0.0

    var body: some View {
        ZStack {
            BackgroundTopDynamicView(scrollOffset: $scrollOffset, backgroundColor: getColorBackground(type: pokemonDetailVM.pokemon.types.first))
            ScrollView {
                VStack(alignment: .center, spacing: 14) {
                    TopImageView(
                        url: pokemonDetailVM.pokemon.sprites.other.officialArtwork.frontDefault,
                        backgroundColor: getColorBackground(type: pokemonDetailVM.pokemon.types.first)
                    )
                    SpeciesInfoView(pokemon: pokemonDetailVM.pokemon)
                    PokemonStatsView(stats: pokemonDetailVM.pokemon.stats, barColor: getColorBackground(type: pokemonDetailVM.pokemon.types.first))
                    MovesGridView(moveDetails: $pokemonDetailVM.movesDetails)
                }
                .navigationTitle(pokemonDetailVM.pokemon.name.capitalized)
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarBackButtonHidden()
                .navigationBarItems(
                    leading: CustomBackButton(
                        action: {
                            dismiss()
                        }
                    )
                )
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
                    .fill(getColorBackground(type: pokemonDetailVM.pokemon.types.first ?? TypeElement(slot: 1, name: "")))
                    .frame(height: UIDevice.topInsetSize)
            }
        .ignoresSafeArea()
        }
    }
    
}

#Preview {
    NavigationStack {
        PokemonDetailView(pokemonDetailVM: PokemonDetailVM(network: DataTest(), pokemon: .test))
    }
}

struct BackgroundTopDynamicView: View {
    @Binding var scrollOffset: CGFloat
    let backgroundColor: Color
    var body: some View {
        VStack {
            if scrollOffset > 0 && scrollOffset < 1000 {
                Rectangle()
                    .fill(backgroundColor)
                    .frame(height: max(min(scrollOffset, 1000), 0))
            }
            Spacer()
        }
        .ignoresSafeArea()
    }
}

struct CustomBackButton: View {
    var action: () -> Void
    var body: some View {
        Button(action: {
            action()
        }, label: {
            Image(systemName: "chevron.left")
                .foregroundColor(.black)
        })
    }
}

struct MovesGridView: View {
    let itemAdaptativeMoves = GridItem(.fixed(100))
    @Binding var moveDetails: [MoveDetail]
    var body: some View {
        VStack {
            HStack {
                Text("Moves")
                    .font(.headline)
                Spacer()
            }
            ScrollView(.horizontal) {
                LazyHGrid(rows: [itemAdaptativeMoves]) {
                    ForEach(moveDetails) { move in
                        VStack(alignment: .leading) {
                            Text(move.name.capitalized)
                                .font(.caption)
                                .bold()
                                .padding(6)
                            Text(move.description)
                                .font(.caption2)
                                .padding(6)
                                .lineLimit(6, reservesSpace: true)
                        }
                        .background {
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color(UIColor.systemBackground))
                                .shadow(
                                    color: .gray.opacity(0.3),
                                    radius: 2,
                                    x: 0,
                                    y: 4
                                )
                        }
                        .frame(width: 140)
                        .padding(.vertical, 12)
                    }
                }
            }
        }
        .padding(.horizontal, 8)
    }
}
