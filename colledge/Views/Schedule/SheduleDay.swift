//
//  SheduleDay.swift
//  colledge
//
//  Created by Ромка Бережной on 17.03.2022.
//

import SwiftUI

struct ScheduleDay: View {
    
    @Binding var selectedDay: Day?
    @Binding var currentIndex: Int
    
    var day: Day
    var count: Int
    
    var body: some View {
        Button(action: {
            self.selectedDay = day
            self.currentIndex = selectedDay!.idOfWeek - 1
        }, label: {
            ZStack {
                Circle()
                    .foregroundColor(selectedDay?.idOfWeek == day.idOfWeek ? .accentColor : .gray.opacity(0.2))
                VStack {
                    Text(day.name)
                    Text(day.value)
                }
                .font(.system(size: 12, weight: .regular, design: .default))
                .foregroundColor(selectedDay?.idOfWeek == day.idOfWeek ? .white : .primary)
            }
            .frame(
                width: UIScreen.main.bounds.width / CGFloat(count + 2),
                height: UIScreen.main.bounds.width / CGFloat(count + 2)
            )
        })
    }
}

