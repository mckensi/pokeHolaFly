//
//  PokemonStatsView.swift
//  pokeHolaFly
//
//  Created by Alex Murcia on 19/11/23.
//

import SwiftUI

struct PokemonStatsView: View {
    
    let stats: [Stat]
    let barColor: Color
    
    var body: some View {
        VStack {
            HStack {
                Text("Stats")
                    .font(.headline)
                Spacer()
            }
            .padding(.horizontal, 10)
            VStack(alignment: .leading) {
                ForEach(stats) { stat in
                    HStack {
                        Text(stat.name)
                            .frame(width: 100, alignment: .leading)
                            .font(.footnote)
                        BarView(
                            value: Double(stat.baseStat),
                            color: barColor
                        )
                    }
                    .padding(.trailing, 10)
                    
                }
            }
            .padding()
            .background {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color(UIColor.systemBackground))
                    .shadow(
                        color: .gray.opacity(0.3),
                        radius: 4,
                        x: 0,
                        y: 4
                    )
            }
            .padding(.horizontal, 12)
        }
    }
}


#Preview {
    PokemonStatsView(stats: Pokemon.test.stats, barColor: getColorBackground(type: Pokemon.test.types.first))
        .frame(height: 240)
}
