//
//  OnBoardingView.swift
//  colledge
//
//  Created by Ромка Бережной on 16.03.2022.
//

import SwiftUI

struct OnBoardingView: View {
    
    @State private var state: OnBoardingState = .first
    @State private var type: ScheduleType = .none
    @State private var selectedSchedule: Schedule? = nil
    
    @Binding var schedule: Data
    @Binding var onBoarding: Bool
    @Binding var contentState: ContentState
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button(action: {
                    self.onBoarding = true
                    self.contentState = .main
                }, label: {
                    Text("Пропустить")
                        .foregroundColor(.secondary)
                })
            }
            switch state {
            case .first:
                OnBoardingFirstView(state: $state)
            case .second:
                OnBoardingSecondView(state: $state, type: $type)
            case .third:
                OnBoardingThirdView(type: type, state: state, contentState: $contentState, selectedSchedule: $selectedSchedule)
            }
            HStack {
                ForEach(1..<4) { circle in
                    Circle()
                        .foregroundColor(state.rawValue == circle ? .blue : .gray.opacity(0.2))
                        .frame(width: 10, height: 10)
                }
                .animation(.spring(), value: state)
            }
            HStack {
                switch state {
                case .first:
                    Spacer()
                    Button(action: {
                        self.state = .second
                    }, label: {
                        Text("Далее")
                            .foregroundColor(.white)
                            .padding(10)
                            .padding(.horizontal)
                            .background(Color.blue)
                            .cornerRadius(8)
                    })
                case .second:
                    Button(action: {
                        self.state = .first
                    }, label: {
                        Text("Назад")
                            .foregroundColor(.primary)
                            .padding(10)
                            .padding(.horizontal)
                            .cornerRadius(8)
                    })
                    Spacer()
                    Button(action: {
                        self.state = .third
                    }, label: {
                        Text("Далее")
                            .foregroundColor(self.type == .none ? .secondary :.white)
                            .padding(10)
                            .padding(.horizontal)
                            .background(self.type == .none ? Color.gray.opacity(0.4) : Color.blue)
                            .cornerRadius(8)
                    })
                    .disabled(self.type == .none)
                case .third:
                    Button(action: {
                        self.state = .second
                    }, label: {
                        Text("Назад")
                            .foregroundColor(.primary)
                            .padding(10)
                            .padding(.horizontal)
                            .cornerRadius(8)
                    })
                    Spacer()
                    Button(action: {
                        if selectedSchedule != nil {
                            storage.save(sourceData: selectedSchedule) { result in
                                guard let result = result else { return }
                                self.schedule = result
                            }
                            self.onBoarding = true
                            self.contentState = .main
                        }
                    }, label: {
                        Text("Завершить")
                            .foregroundColor(self.selectedSchedule == nil ? .secondary :.white)
                            .padding(10)
                            .padding(.horizontal)
                            .background(self.selectedSchedule == nil ? Color.gray.opacity(0.4) : Color.blue)
                            .cornerRadius(8)
                    })
                    .disabled(self.selectedSchedule == nil)
                }
            }
        }.padding(.horizontal, 30)
    }
}

struct OnBoardingFirstView: View {
    @Binding var state: OnBoardingState
    var body: some View {
        VStack {
            VStack {
                Text("Привет!")
                    .foregroundColor(.primary)
                    .font(.title)
            }
        }
        .frame(height: UIScreen.main.bounds.height / 2)
    }
}

struct OnBoardingSecondView: View {
    @Binding var state: OnBoardingState
    @Binding var type: ScheduleType
    var body: some View {
        VStack {
            VStack {
                Text("Выберите")
                    .font(.title2)
                    .foregroundColor(.secondary)
                Text("Кто вы?")
                    .foregroundColor(.primary)
                    .font(.title)
                HStack {
                    Button(action: {
                        self.type = .teacher
                    }, label: {
                        Text("Преподаватель")
                            .foregroundColor(.white)
                            .padding(10)
                            .frame(maxWidth: UIScreen.main.bounds.width / 2)
                            .background(self.type == .teacher ? Color.blue : Color.gray.opacity(0.2))
                            .cornerRadius(8)
                    })
                    Button(action: {
                        self.type = .student
                    }, label: {
                        Text("Студент")
                            .foregroundColor(.white)
                            .padding(10)
                            .frame(maxWidth: UIScreen.main.bounds.width / 2)
                            .background(self.type == .student ? Color.blue : Color.gray.opacity(0.2))
                            .cornerRadius(8)
                    })
                }
                .animation(.spring(), value: type)
            }
        }
        .frame(height: UIScreen.main.bounds.height / 2)
    }
}

struct OnBoardingThirdView: View {
    
    var type: ScheduleType
    var state: OnBoardingState
    
    @State var teachers: [Teacher] = []
    @State var groups: [Group] = []
    @State var err: Bool = false
    
    @Binding var contentState: ContentState
    @Binding var selectedSchedule: Schedule?
    
    var body: some View {
        VStack {
            if ((type == .teacher && teachers.count == 0) || (type == .student && groups.count == 0)) && !err {
                Spacer()
                ProgressView()
                Spacer()
            } else if err {
                Spacer()
                Text("Error")
                Spacer()
            }else {
                switch type {
                case .teacher:
                    Text("Выберите преподавателя")
                        .font(.title3)
                        .foregroundColor(.primary)
                    ScrollView {
                        ForEach(teachers, id:\.id) { teacher in
                            Button(action: {
                                self.selectedSchedule = Schedule(id: teacher.id, name: teacher.print, type: self.type)
                            }, label: {
                                Text(teacher.print)
                                    .foregroundColor(.white)
                                    .padding(.vertical, 15)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .multilineTextAlignment(.leading)
                                    .padding(.horizontal)
                                    .background(self.selectedSchedule?.id == teacher.id ? Color.blue : Color.gray.opacity(0.2))
                                    .cornerRadius(8)
                            })
                        }
                    }
                case .student:
                    Text("Выберите группу")
                        .font(.title3)
                        .foregroundColor(.primary)
                    ScrollView {
                        ForEach(groups, id:\.id) { group in
                            Button(action: {
                                self.selectedSchedule = Schedule(id: group.id, name: group.print, type: self.type)
                            }, label: {
                                Text(group.print)
                                    .foregroundColor(.white)
                                    .padding(.vertical, 15)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .multilineTextAlignment(.leading)
                                    .padding(.horizontal)
                                    .background(self.selectedSchedule?.id == group.id ? Color.blue : Color.gray.opacity(0.2))
                                    .cornerRadius(8)
                            })
                        }
                    }
                case .none:
                    ProgressView()
                }
            }
        }
        .onAppear(perform: {
            switch type {
            case .student:
                api.getGroups() { result in
                    guard let result = result else {
                        self.err = true
                        return
                    }
                    self.groups = result
                }
            case .teacher:
                api.getTeachers() { result in
                    guard let result = result else {
                        self.err = true
                        return
                    }
                    self.teachers = result
                }
            case .none:
                return
            }
        })
        .frame(minHeight: UIScreen.main.bounds.height / 2)
        .padding(.vertical)
    }
}

enum OnBoardingState: Int {
    case first = 1, second = 2, third = 3
}

enum ScheduleType: Int, Codable {
    case teacher = 1, student = 2, none = 3
}

struct Schedule: Codable {
    var id: Int
    var name: String
    var type: ScheduleType
}
