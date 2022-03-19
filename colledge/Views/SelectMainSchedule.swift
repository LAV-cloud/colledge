//
//  SelectMainSchedule.swift
//  colledge
//
//  Created by Ромка Бережной on 19.03.2022.
//

import SwiftUI

struct SelectMainSchedule: View {
    
    @State private var newMain: Schedule? = nil
    @State private var type: ScheduleType = .teacher
    @State private var loading: Bool = false
    @State private var error: Bool = false
    @State private var teachers: [Teacher] = []
    @State private var groups: [Group] = []
    
    @Binding var main: Schedule?
    @Binding var schedule: Data
    @Binding var select: Bool
    
    var body: some View {
        VStack {
            Picker(selection: $type, label: Text("Выберите")) {
                Text("Преподаватели").tag(ScheduleType.teacher)
                Text("Группы").tag(ScheduleType.student)
            }
            .pickerStyle(.segmented)
            if loading && !error {
                Spacer()
                ProgressView()
                Spacer()
            } else if error {
                Spacer()
                Text("Ошибка")
                Spacer()
            } else {
                ScrollView {
                    if type == .teacher {
                        ForEach(teachers, id:\.id) { teacher in
                            Button(action: {
                                if teacher.id != main?.id {
                                    let schedule: Schedule = Schedule(id: teacher.id, name: teacher.print, type: .teacher)
                                    self.newMain = schedule
                                }
                            }, label: {
                                HStack {
                                    Text(teacher.print)
                                    Spacer()
                                }
                                .padding(.horizontal)
                                .foregroundColor(.primary)
                                .padding(.vertical, 15)
                                .frame(maxWidth: .infinity)
                                .background(teacher.id == newMain?.id ? Color.blue : (teacher.id == main?.id ? .gray.opacity(0.4) : .gray.opacity(0.2)))
                                .cornerRadius(4)
                            })
                        }
                    } else {
                        ForEach(groups, id:\.id) { group in
                            Button(action: {
                                if group.id != main?.id {
                                    let schedule: Schedule = Schedule(id: group.id, name: group.print, type: .student)
                                    self.newMain = schedule
                                }
                            }, label: {
                                HStack {
                                    Text(group.print)
                                    Spacer()
                                }
                                .padding(.horizontal)
                                .foregroundColor(.primary)
                                .padding(.vertical, 15)
                                .frame(maxWidth: .infinity)
                                .background(group.id == newMain?.id ? Color.blue : (group.id == main?.id ? .gray.opacity(0.4) : .gray.opacity(0.2)))
                                .cornerRadius(4)
                            })
                        }
                    }
                }
                Button(action: {
                    storage.save(sourceData: newMain) { result in
                        guard let result = result else { return }
                        self.schedule = result
                        self.main = newMain
                        self.select = false
                    }
                }, label: {
                    Text("Выбрать")
                        .foregroundColor(newMain?.id == main?.id || newMain == nil ? .secondary :.white)
                        .frame(height: 60)
                        .frame(maxWidth: .infinity)
                        .background(newMain?.id == main?.id || newMain == nil ? Color.gray.opacity(0.4) : Color.blue)
                        .cornerRadius(8)
                })
                .padding(.top)
                .padding(.bottom)
                .disabled(newMain?.id == main?.id || newMain == nil)
            }
        }
        .navigationTitle("Выбор")
        .navigationBarTitleDisplayMode(.large)
        .padding(.horizontal)
        .onAppear(perform: {
            self.loading = true
            if main != nil { self.type = main!.type }
            api.getTeachers { result in
                guard let result = result else {
                    self.error = true
                    return
                }
                self.teachers = result
            }
            api.getGroups { result in
                guard let result = result else {
                    self.error = true
                    return
                }
                self.groups = result
                self.loading = false
            }
        })
    }
}
