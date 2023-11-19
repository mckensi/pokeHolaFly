//
//  SpeciesInfoView.swift
//  pokeHolaFly
//
//  Created by Alex Murcia on 19/11/23.
//

import SwiftUI

struct SpeciesInfoView: View {
    let itemAdaptativeTypes = GridItem(.adaptive(minimum: 80))
    
    let pokemon: Pokemon
    var body: some View {
        VStack {
            HStack {
                Text("Species")
                    .font(.headline)
                    .padding([.leading, .top], 10)
                Spacer()
            }
            VStack {
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
                .padding(.top, 8)
                HStack {
                    Spacer()
                    VStack {
                        Image(systemName: "ruler")
                            .rotationEffect(Angle(degrees: 45))
                        Spacer(minLength: 8)
                        Text("\(pokemon.height)'")
                            .font(.caption2)
                    }
                    .padding(8)
                    VStack {
                        Image(systemName: "lineweight")
                        Spacer(minLength: 8)
                        Text("\(pokemon.weight) lbs")
                            .font(.caption2)
                    }
                    .padding(8)
                    Spacer()
                }
            }
            .background {
                RoundedRectangle(
                    cornerRadius: 10,
                    style: .circular
                )
                .fill(Color(UIColor.systemBackground))
                .shadow(
                    color: .gray.opacity(0.3),
                    radius: 4,
                    x: 0,
                    y: 4
                )
            }
            .padding(.horizontal, 10)
        }
    }
}

#Preview {
    SpeciesInfoView(pokemon: .test)
        .frame(height: 160)
}
