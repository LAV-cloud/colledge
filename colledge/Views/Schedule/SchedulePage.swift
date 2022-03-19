//
//  SchedulePage.swift
//  colledge
//
//  Created by Ромка Бережной on 19.03.2022.
//

import SwiftUI

struct SchedulePage: View {
    
    var loading: Bool
    var error: Bool
    var selectedDay: Day?
    var scheduleItems: [[ScheduleItem]]
    var schedule: Schedule
    
    var body: some View {
        if (scheduleItems.count == 0 && !loading && !error) || (!loading && !error && selectedDay != nil && scheduleItems[selectedDay!.idOfWeek - 1].count == 0) {
            Spacer()
            Text("Пусто")
            Spacer()
        } else if error {
            Spacer()
            Text("Ошибка")
            Spacer()
        } else if loading {
            Spacer()
            ProgressView()
            Spacer()
        } else
        if selectedDay != nil && scheduleItems.count > 0 {
            ScrollView {
            ScheduleList(
                schedule: schedule,
                items: scheduleItems[selectedDay!.idOfWeek - 1]
            )
            }
        }
    }
}
