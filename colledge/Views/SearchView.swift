//
//  SearchView.swift
//  colledge
//
//  Created by Ромка Бережной on 16.03.2022.
//

import SwiftUI

struct SearchView: View {
    
    @State private var search: String = ""
    @State private var favorites: [Schedule] = []
    @State private var main: Schedule? = nil
    @State private var type: ScheduleType = .teacher
    @State private var groupData: [Group] = []
    @State private var teacherData: [Teacher] = []
    @State private var loading: Bool = false
    @State private var error: Bool = false
    
    @FocusState private var fieldFocus: FieldFocusState?
    
    @Binding var schedule: Data
    @Binding var schedules: Data
    
    var searchTeacher: [Teacher] {
        if self.search.isEmpty {
            return teacherData
        } else {
            return teacherData.filter {
                $0.secondName.contains(self.search) || $0.firstName.contains(self.search) || $0.thirdName.contains(self.search)
            }
        }
    }
    
    var searchGroup: [Group] {
        if self.search.isEmpty {
            return groupData
        } else {
            return groupData.filter { $0.print.contains(self.search)}
        }
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                Picker("Type", selection: $type) {
                    Text("Преподаватели").tag(ScheduleType.teacher)
                    Text("Группы").tag(ScheduleType.student)
                }
                .pickerStyle(.segmented)
                HStack {
                    HStack {
                        TextField("Поиск группы или преподавателя", text: $search)
                            .foregroundColor(.primary)
                            .focused($fieldFocus, equals: FieldFocusState.search)
                        Button(action: {
                            self.search = ""
                        }, label: {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.secondary)
                        })
                    }
                    .padding(10)
                    .background(.gray.opacity(0.2))
                    .cornerRadius(8)
                    if self.fieldFocus == .search {
                        Button(action: {
                            self.fieldFocus = nil
                        }, label: {
                            Text("Отмена")
                        })
                    }
                }
                .animation(.spring(), value: fieldFocus)
                .padding(.vertical, 20)
                if groupData.count == 0 && teacherData.count == 0 {
                    Spacer()
                    ProgressView ()
                    Spacer()
                } else {
                    ScrollView {
                        if type == .teacher {
                            ForEach(searchTeacher, id:\.id) { teacher in
                                SearchTeacherItem(teacher: teacher, main: main, favorites: $favorites, schedules: $schedules)
                            }
                        } else {
                            ForEach(searchGroup, id:\.id) { group in
                                SearchGroupItem(group: group, main: main, favorites: $favorites, schedules: $schedules)
                            }
                        }
                    }
                }
            }
            .onAppear(perform: {
                if !schedule.isEmpty {
                    storage.load(sourceData: schedule) { (result: Schedule?) in
                        guard let result = result else {
                            return
                        }
                        self.main = result
                    }
                }
                
                if !schedules.isEmpty {
                    storage.load(sourceData: schedules) { (result: [Schedule]?) in
                        guard let result = result else {
                            return
                        }
                        self.favorites = result
                    }
                }
                
                api.getTeachers { result in
                    guard let result = result else {
                        return
                    }
                    self.teacherData = result
                }
                
                api.getGroups { result in
                    guard let result = result else {
                        return
                    }
                    self.groupData = result
                }
            })
            .padding(.horizontal)
            .navigationTitle("Поиск")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

struct SearchTeacherItem: View {
    
    var teacher: Teacher
    var main: Schedule?
    
    @Binding var favorites: [Schedule]
    @Binding var schedules: Data
    
    init(teacher: Teacher, main: Schedule?, favorites: Binding<[Schedule]>, schedules: Binding<Data>) {
        self.teacher = teacher
        self.main = main
        self._favorites = favorites
        self._schedules = schedules
    }
    
    var teacherToSchedule: Schedule {
        return Schedule(id: self.teacher.id, name: self.teacher.print, type: .teacher)
    }
    
    var body: some View {
        NavigationLink(destination:
                        ScheduleView(
                            schedule: teacherToSchedule,
                            main: main,
                            favorites: $favorites,
                            schedules: $schedules
                        ), label: {
                            HStack {
                                Text(teacher.print)
                                Spacer()
                            }
                            .foregroundColor(.primary)
                            .padding(.vertical, 15)
                            .padding(.horizontal, 30)
                            .frame(maxWidth: .infinity)
                            .background(.gray.opacity(0.2))
                            .cornerRadius(8)
                        })
    }
}

struct SearchGroupItem: View {
    var group: Group
    var main: Schedule?
    
    @Binding var favorites: [Schedule]
    @Binding var schedules: Data
    
    init(group: Group, main: Schedule?, favorites: Binding<[Schedule]>, schedules: Binding<Data>) {
        self.group = group
        self.main = main
        self._favorites = favorites
        self._schedules = schedules
    }
    
    var groupToSchedule: Schedule {
        return Schedule(id: self.group.id, name: self.group.print, type: .student)
    }
    
    var body: some View {
        NavigationLink(destination:
                        ScheduleView(
                            schedule: groupToSchedule,
                            main: main,
                            favorites: $favorites,
                            schedules: $schedules
                        ), label: {
                            HStack {
                                Text(group.print)
                                Spacer()
                            }
                            .foregroundColor(.primary)
                            .padding(.vertical, 15)
                            .padding(.horizontal, 30)
                            .frame(maxWidth: .infinity)
                            .background(.gray.opacity(0.2))
                            .cornerRadius(8)
                        })
    }
}

enum FieldFocusState {
    case search
}
