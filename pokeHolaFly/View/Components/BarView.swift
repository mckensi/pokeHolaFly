//
//  BarView.swift
//  pokeHolaFly
//
//  Created by Alex Murcia on 18/11/23.
//

import SwiftUI

struct BarView: View {
    var value: Double
    var color: Color = .blue
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 10)
                    .frame(width: geometry.size.width, height: 16)
                    .foregroundColor(Color.gray.opacity(0.3))
                
                RoundedRectangle(cornerRadius: 10)
                    .frame(width: CGFloat(self.value > 100 ? 100 : self.value) / 100 * geometry.size.width, height: 16)
                    .foregroundColor(color)
                    .animation(.easeInOut, value: value)
                Text("\(Int(value))")
                    .font(.caption2)
                    .padding(.leading, 8)
            }
        }
    }
    
}

#Preview {
    BarView(value: 20)
}
