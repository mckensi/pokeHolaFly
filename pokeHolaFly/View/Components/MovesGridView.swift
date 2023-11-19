//
//  MovesGridView.swift
//  pokeHolaFly
//
//  Created by Alex Murcia on 19/11/23.
//

import SwiftUI

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


#Preview {
    MovesGridView(moveDetails: .constant(MoveDetail.arrayTest))
}
