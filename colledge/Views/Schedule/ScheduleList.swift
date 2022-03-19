//
//  ScheduleList.swift
//  colledge
//
//  Created by Ромка Бережной on 17.03.2022.
//

import SwiftUI

struct ScheduleList: View {
    
    var schedule: Schedule
    var items: [ScheduleItem]
    
    var body: some View {
        ForEach(items, id:\.id) { item in
            VStack {
                ScheduleItemView(schedule: schedule, item: item)
                ScheduleAdditionally(item: item, items: items)
            }
        }
    }
}
