//
//  ContentView.swift
//  GeoTask
//
//  Created by MadushanSenavirathna on 2025-08-02.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var coordinator: AppNavigationCoordinator
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
    }
}

#Preview {
    ContentView()
        .environmentObject(AppNavigationCoordinator())
}
