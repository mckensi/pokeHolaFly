//
//  BackgroundTopDynamicView.swift
//  pokeHolaFly
//
//  Created by Alex Murcia on 19/11/23.
//

import SwiftUI

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

#Preview {
    BackgroundTopDynamicView(scrollOffset: .constant(80), backgroundColor: .red)
}
