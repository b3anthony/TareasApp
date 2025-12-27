//
//  MainTabView.swift
//  TareasApp
//
//  Created by Anthony on 27/12/25.
//

import SwiftUI

struct MainTabView: View {
    @StateObject private var viewModel = TareasViewModel()
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            // Tab 1: Mis Tareas
            MisTareasView(viewModel: viewModel, selectedTab: $selectedTab)
                .tabItem {
                    Label("Mis Tareas", systemImage: "list.bullet.clipboard")
                }
                .tag(0)
            
            // Tab 2: Nueva Tarea
            NuevaTareaView(viewModel: viewModel, selectedTab: $selectedTab)
                .tabItem {
                    Label("Nueva Tarea", systemImage: "plus.circle.fill")
                }
                .tag(1)
        }
        .accentColor(.blue)
    }
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
    }
}
