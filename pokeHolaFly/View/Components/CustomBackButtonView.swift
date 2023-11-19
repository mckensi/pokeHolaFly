//
//  CustomBackButtonView.swift
//  pokeHolaFly
//
//  Created by Alex Murcia on 19/11/23.
//

import SwiftUI

struct CustomBackButtonView: View {
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


#Preview {
    CustomBackButtonView(action: {})
}
