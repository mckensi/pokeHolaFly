//
//  PokemonDetailView.swift
//  pokeHolaFly
//
//  Created by Daniel Murcia Almanza on 17/11/23.
//

import SwiftUI

struct PokemonDetailView: View {
    @Environment(\.dismiss) var dismiss
    
    @State private var scrollOffset: CGFloat = 0.0
    @State private var minOffset: CGFloat = 0.0
    
    let itemAdaptativeMoves = GridItem(.flexible(minimum: 30, maximum: 60))
    
    var pokemon: Pokemon
    var body: some View {
        ZStack {
            BackgroundTopDynamicView(scrollOffset: $scrollOffset, backgroundColor: getColorBackground(type: pokemon.types.first))
            ScrollView {
                VStack(alignment: .center, spacing: 14) {
                    TopImageView(
                        url: pokemon.sprites.other.officialArtwork.frontDefault,
                        backgroundColor: getColorBackground(type: pokemon.types.first)
                    )
                    SpeciesInfoView(pokemon: pokemon)
                    PokemonStatsView(stats: pokemon.stats, barColor: getColorBackground(type: pokemon.types.first))
                    VStack {
                        HStack {
                            Text("Moves")
                                .font(.headline)
                            Spacer()
                        }
                        ScrollView(.horizontal) {
                            LazyHGrid(rows: [itemAdaptativeMoves]) {
                                ForEach(pokemon.moves) { move in
                                    VStack(alignment: .leading) {
                                        Text(move.name.capitalized)
                                            .font(.caption)
                                            .bold()
                                            .padding(6)
                                        Text("Alguna descripción que me gustarìa tener acá")
                                            .font(.caption2)
                                            .padding(6)
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
                                    .frame(width: 140, height: 100)
                                    .padding(.vertical, 10)
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 8)
                }
                .navigationTitle(pokemon.name.capitalized)
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
