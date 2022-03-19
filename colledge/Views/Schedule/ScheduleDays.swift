//
//  ScheduleDays.swift
//  colledge
//
//  Created by Ромка Бережной on 17.03.2022.
//

import SwiftUI

struct ScheduleDays: View {
    
    var days: [Day]
    var today: Day?
    
    @Binding var selectedDay: Day?
    @Binding var currentIndex: Int
    
    var body: some View {
        HStack {
            ForEach(days) { day in
                VStack(alignment: .center, spacing: 0) {
                    if today != nil && today?.idOfWeek == day.idOfWeek && today?.idOfWeek != selectedDay?.idOfWeek {
                        Circle()
                            .foregroundColor(.accentColor)
                            .frame(width: 10, height: 10)
                            .padding(.bottom, 5)
                    } else {
                        Spacer()
                            .frame(width: 10, height: 10)
                            .padding(.bottom, 5)
                    }
                    ScheduleDay(selectedDay: $selectedDay, currentIndex: $currentIndex, day: day, count: days.count)
                }
                .animation(.spring(), value: selectedDay?.idOfWeek)
            }
        }
        .padding(.bottom)
    }
}
