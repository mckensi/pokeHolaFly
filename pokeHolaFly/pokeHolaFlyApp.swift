//
//  pokeHolaFlyApp.swift
//  pokeHolaFly
//
//  Created by Daniel Murcia Almanza on 16/11/23.
//

import SwiftUI

@main
struct pokeHolaFlyApp: App {
    @StateObject var vm = PokemonsVM()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(vm)
        }
    }
}
