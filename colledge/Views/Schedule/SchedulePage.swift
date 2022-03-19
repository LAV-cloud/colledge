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
    var selectedDay: Day
    var scheduleItems: [[ScheduleItem]]
    var schedule: Schedule
    
    var body: some View {
        if (
            scheduleItems.count == 0 &&
            !loading && !error
        ) || (
            !loading &&
            !error &&
            scheduleItems.count > 0 &&
            scheduleItems[selectedDay.idOfWeek - 1].count == 0
        ) {
            Text("Пусто")
        } else if error {
            Text("Ошибка")
        } else if loading {
            ProgressView()
        } else {
            ScrollView {
                ScheduleList(
                    schedule: schedule,
                    items: scheduleItems[selectedDay.idOfWeek - 1]
                )
            }
        }
    }
}
