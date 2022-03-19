//
//  MainView.swift
//  colledge
//
//  Created by Ромка Бережной on 16.03.2022.
//

import SwiftUI

struct MainView: View {
    
    @State private var selectedTab: Int = 0
    
    @AppStorage("favorites") private var favorites: Data = Data()
    
    @Binding var schedule: Data
    
    var body: some View {
        TabView(selection: $selectedTab) {
            FavoriteView(schedules: $favorites, schedule: $schedule).tabItem({ Image(systemName: "calendar") }).tag(0)
            SearchView(schedule: $schedule, schedules: $favorites).tabItem({ Image(systemName: "magnifyingglass") }).tag(1)
            InformationView().tabItem({ Image(systemName: "clock") }).tag(2)
            ProfileView(schedule: $schedule).tabItem({ Image(systemName: "person.fill") }).tag(3)
        }
    }
}
