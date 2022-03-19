//
//  ProfileView.swift
//  colledge
//
//  Created by Ромка Бережной on 16.03.2022.
//

import SwiftUI

struct ProfileView: View {
    
    @State private var main: Schedule? = nil
    @State private var error: Bool = false
    @State private var select: Bool = false
    
    @Binding var schedule: Data
    
    var body: some View {
        NavigationView {
            VStack {
                ZStack {
                    RoundedRectangle(cornerRadius: 20)
                        .foregroundColor(.gray.opacity(0.2))
                    if main != nil {
                        HStack {
                            ZStack {
                                Circle()
                                    .foregroundColor(.gray.opacity(0.2))
                                Image(systemName: "person.fill")
                                    .resizable()
                                    .frame(width: 40, height: 40)
                                    .foregroundColor(.secondary)
                            }
                            .frame(width: 60, height: 60)
                            Spacer()
                            VStack(alignment: .leading, spacing: 0) {
                                VStack(alignment: .leading, spacing: 0) {
                                    Text(main!.type == .teacher ? "Преподаватель" : "Cтудент")
                                        .font(.system(size: 20, weight: .bold, design: .rounded))
                                        .foregroundColor(.primary)
                                    Text(main!.name)
                                        .foregroundColor(.secondary)
                                }
                                .padding(.bottom, 10)
                                NavigationLink(
                                    destination:
                                        SelectMainSchedule(
                                            main: $main,
                                            schedule: $schedule,
                                            select: $select
                                        ),
                                    isActive: $select,
                                    label: {
                                        Text("Поменять основное расписание")
                                            .foregroundColor(.accentColor)
                                    })
                            }
                        }
                        .padding(20)
                    } else if error {
                        Text("Ошибка")
                            .foregroundColor(.primary)
                            .padding(20)
                    } else {
                        NavigationLink(
                            destination:
                                SelectMainSchedule(
                                    main: $main,
                                    schedule: $schedule,
                                    select: $select
                                ),
                            isActive: $select,
                            label: {
                                Text("Выбрать основное расписание")
                                    .foregroundColor(.accentColor)
                            })
                        .padding(20)
                    }
                }
                .frame(height: 100)
                .frame(maxWidth: .infinity)
                .padding(.top, 20)
                List {
                    Text("Возможно скоро здесь что-то будет")
                        .foregroundColor(.secondary)
                        .font(.system(size: 16))
                }
            }
            .navigationTitle("Профиль")
            .navigationBarTitleDisplayMode(.large)
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
            })
            .padding(.horizontal)
        }
    }
}
