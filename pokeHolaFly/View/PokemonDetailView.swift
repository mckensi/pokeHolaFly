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
                    leading: CustomBackButtonView(
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
        .alert("Error", isPresented: $pokemonDetailVM.showAlert) {
            Button("Accept", role: .cancel) {
                pokemonDetailVM.showAlert.toggle()
            }
        } message: {
            Text(pokemonDetailVM.alertMsg)
        }
    }
    
}

#Preview {
    NavigationStack {
        PokemonDetailView(pokemonDetailVM: PokemonDetailVM(network: DataTest(), pokemon: .test))
    }
}
