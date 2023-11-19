//
//  TopImageView.swift
//  pokeHolaFly
//
//  Created by Alex Murcia on 19/11/23.
//

import SwiftUI

struct TopImageView: View {
    let url: URL?
    let backgroundColor: Color
    
    var body: some View {
        HStack {
            Spacer()
            AsyncImage(url: url) { image in
                image
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 240, alignment: .center)
            } placeholder: {
                EmptyView()
            }
            Spacer()
        }
        .background(backgroundColor)
        .ignoresSafeArea()
    }
}


#Preview {
    TopImageView(url:  Pokemon.test.sprites.other.officialArtwork.frontDefault, backgroundColor: getColorBackground(type: Pokemon.test.types.first))
}
