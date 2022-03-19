//
//  FavoriteView.swift
//  colledge
//
//  Created by Ромка Бережной on 16.03.2022.
//

import SwiftUI

struct FavoriteView: View {
    
    @State private var search: String = ""
    @State private var error: Bool = false
    @State private var main: Schedule? = nil
    @State private var favorites: [Schedule] = []
    
    @Binding var schedules: Data
    @Binding var schedule: Data
    
    var searchResult: [Schedule] {
        if search.isEmpty {
            return favorites
        } else {
            return favorites.filter { $0.name == search }
        }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                if main == nil && searchResult.count == 0 && !error {
                    Text("Пусто")
                } else if error {
                    Text("Ошибка")
                } else {
                    ScrollView {
                        if main != nil {
                            NavigationLink(
                                destination:
                                    ScheduleView(
                                        schedule: main!,
                                        main: main,
                                        favorites: $favorites,
                                        schedules: $schedules
                                    ),
                                label: {
                                    HStack {
                                        HStack{
                                            Text("Основное")
                                                .padding(5)
                                                .padding(.horizontal, 10)
                                                .foregroundColor(.white)
                                                .background(Color.accentColor)
                                                .cornerRadius(20)
                                            Text(main!.name)
                                                .foregroundColor(.primary)
                                                .padding(.leading, 5)
                                        }
                                        Spacer()
                                    }
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(.gray.opacity(0.2))
                                    .cornerRadius(10)
                                })
                        }
                        ForEach(searchResult, id:\.id) { fav in
                            NavigationLink(
                                destination:
                                    ScheduleView(
                                        schedule: fav,
                                        main: main,
                                        favorites: $favorites,
                                        schedules: $schedules
                                ),
                                label: {
                                HStack {
                                    Text(fav.name)
                                        .foregroundColor(.primary)
                                    Spacer()
                                }
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(.gray.opacity(0.2))
                                .cornerRadius(10)
                                
                            })
                        }
                    }
                }
            }
            .padding(.horizontal)
            .navigationTitle("Избранные")
            .navigationBarTitleDisplayMode(.large)
        }
        .onAppear(perform: {
            if !schedule.isEmpty {
                storage.load(sourceData: schedule) { (result: Schedule?) in
                    guard let result = result else {
                        self.error = true
                        return
                    }
                    self.main = result
                }
            }
            
            if !schedules.isEmpty {
                storage.load(sourceData: schedules) { (result: [Schedule]?) in
                    guard let result = result else {
                        self.error = true
                        return
                    }
                    self.favorites = result
                }
            }
            
        })
    }
}
