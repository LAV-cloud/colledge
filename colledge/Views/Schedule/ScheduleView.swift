//
//  ScheduleView.swift
//  colledge
//
//  Created by Ромка Бережной on 17.03.2022.
//

import SwiftUI

struct ScheduleView: View {
    
    @State private var today: Day? = nil
    @State private var selectedDay: Day? = nil
    @State private var days: [Day] = []
    @State private var scheduleItems: [[ScheduleItem]] = []
    @State private var error: Bool = false
    @State private var loading: Bool = false
    @State private var currentIndex: Int = 0
    
    var schedule: Schedule
    var main: Schedule?
    
    @Binding var favorites: [Schedule]
    @Binding var schedules: Data
    
    var body: some View {
        VStack {
            ScheduleDays(
                days: days,
                today: today,
                selectedDay: $selectedDay,
                currentIndex: $currentIndex
            )
            GeometryReader { geometry in
                CarouselView(
                    numberOfImages: days.count,
                    offset: 20,
                    days: $days,
                    selectedDay: $selectedDay,
                    currentIndex: $currentIndex
                ) {
                    ForEach(0..<days.count, id:\.self) { index in
                        SchedulePage(
                            loading: loading,
                            error: error,
                            selectedDay: days[index],
                            scheduleItems: scheduleItems,
                            schedule: schedule
                        )
                        .frame(width: geometry.frame(in: .global).width)
                    }
                }
            }
        }
        .navigationTitle(schedule.name)
        .toolbar {
            HStack {
                Button(action: {
                    self.loading = true
                    let calendar = Calendar.current
                    let today = calendar.startOfDay(for: Date())
                    let dayOfWeek = calendar.component(.weekday, from: today)
                    let weekdays = calendar.range(of: .weekday, in: .weekOfYear, for: today)!
                    let days = (weekdays.lowerBound + 1 ..< weekdays.upperBound)
                        .compactMap { calendar.date(byAdding: .day, value: $0 - dayOfWeek, to: today) }
                    
                    let formatter = DateFormatter()
                    self.days = []
                    for date in days {
                        var newDay = Day(name: "", value: "", idOfWeek: 0)
                        
                        formatter.dateFormat = "E"
                        newDay.name = formatter.string(from: date)
                        
                        formatter.dateFormat = "d"
                        newDay.value = formatter.string(from: date)
                        
                        newDay.idOfWeek = calendar.component(.weekday, from: date) - 1
                        
                        self.days.append(newDay)
                    }
                    
                    var nowDay = Day(name: "", value: "", idOfWeek: 0)
                    
                    formatter.dateFormat = "E"
                    nowDay.name = formatter.string(from: today)
                    
                    formatter.dateFormat = "d"
                    nowDay.value = formatter.string(from: today)
                    
                    nowDay.idOfWeek = dayOfWeek == 1 ? dayOfWeek : dayOfWeek - 1
                    
                    self.today = nowDay
                    self.selectedDay = nowDay
                    self.currentIndex = selectedDay!.idOfWeek - 1
                    
                    formatter.dateFormat = "y"
                    let year = Int(formatter.string(from: today))!
                    
                    formatter.dateFormat = "w"
                    let week = Int(formatter.string(from: today))! - 1
                    
                    api.getSchedule(year: year, week: dayOfWeek == 1 ? week + 1 : week, type: schedule.type, id: schedule.id) { result in
                        guard let result = result else {
                            self.error = true
                            return
                        }
                        for day in self.days {
                            let items: [ScheduleItem] = result
                                .filter {$0.day == day.idOfWeek}
                                .sorted { $0.sort < $1.sort }
                            self.scheduleItems.append(items)
                        }
                        self.loading = false
                    }
                }, label: {
                    Image(systemName: "arrow.clockwise")
                        .foregroundColor(.primary)
                })
                Button(action: {
                    if main?.id != schedule.id && favorites.filter { $0.id == schedule.id}.count == 0 {
                        self.favorites.append(schedule)
                        storage.save(sourceData: self.favorites) { result in
                            guard let result = result else { return }
                            self.schedules = result
                        }
                    } else if main?.id != schedule.id {
                        let index: Int = self.favorites.firstIndex { $0.id == schedule.id }!
                        self.favorites.remove(at: index)
                        storage.save(sourceData: self.favorites) { result in
                            guard let result = result else {return}
                            self.schedules = result
                        }
                    }
                }, label: {
                    Image(systemName: main?.id == schedule.id || favorites.filter { $0.id == schedule.id }.count > 0 ? "star.fill" : "star")
                })
            }
        }
        .padding(.horizontal)
        .onAppear(perform: {
            self.loading = true
            let calendar = Calendar.current
            var today = calendar.startOfDay(for: Date())
            let dayOfWeek = calendar.component(.weekday, from: today)
            let weekdays = calendar.range(of: .weekday, in: .weekOfYear, for: today)!
            let days = (weekdays.lowerBound + 1 ..< weekdays.upperBound)
                .compactMap { calendar.date(byAdding: .day, value: $0 - dayOfWeek, to: today) }
            
            let formatter = DateFormatter()
            self.days = []
            for date in days {
                var newDay = Day(name: "", value: "", idOfWeek: 0)
                
                formatter.dateFormat = "E"
                newDay.name = formatter.string(from: date)
                
                formatter.dateFormat = "d"
                newDay.value = formatter.string(from: date)
                
                newDay.idOfWeek = calendar.component(.weekday, from: date) - 1
                
                self.days.append(newDay)
            }
            
            var nowDay = Day(name: "", value: "", idOfWeek: 0)
            
            formatter.dateFormat = "E"
            nowDay.name = formatter.string(from: today)
            
            formatter.dateFormat = "d"
            nowDay.value = formatter.string(from: today)
            
            nowDay.idOfWeek = dayOfWeek == 1 ? dayOfWeek : dayOfWeek - 1
            
            self.today = nowDay
            self.selectedDay = nowDay
            self.currentIndex = selectedDay!.idOfWeek - 1
            
            formatter.dateFormat = "y"
            let year = Int(formatter.string(from: today))!
            
            formatter.dateFormat = "w"
            let week = Int(formatter.string(from: today))!
            
            api.getSchedule(year: year, week: dayOfWeek == 1 ? week - 1 : week - 2, type: schedule.type, id: schedule.id) { result in
                guard let result = result else {
                    self.error = true
                    return
                }
                for day in self.days {
                    let items: [ScheduleItem] = result
                        .filter {$0.day == day.idOfWeek}
                        .sorted { $0.sort < $1.sort }
                    self.scheduleItems.append(items)
                }
                self.loading = false
            }
        })
    }
}

struct Day: Identifiable {
    var id = UUID()
    var name: String
    var value: String
    var idOfWeek: Int
}
