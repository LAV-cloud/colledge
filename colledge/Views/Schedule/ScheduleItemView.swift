//
//  ScheduleItemView.swift
//  colledge
//
//  Created by Ромка Бережной on 17.03.2022.
//

import SwiftUI

struct ScheduleItemView: View {
    
    var schedule: Schedule
    var item: ScheduleItem
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .foregroundColor(.gray.opacity(0.2))
            VStack(alignment: .leading, spacing: 0) {
                HStack {
                    HStack {
                        ZStack(alignment: .center) {
                            Circle()
                                .foregroundColor(.gray.opacity(0.2))
                            Text("\(item.sort)")
                                .foregroundColor(.secondary)
                        }
                        .frame(width: 24, height: 24)
                        Text("Пара")
                            .foregroundColor(.secondary)
                        Spacer()
                    }
                    Spacer()
                    Text("\(item.time.getStart()) - \(item.time.getEnd())")
                }
                .padding(.vertical, 10)
                .padding(.horizontal)
                HStack {
                    VStack(alignment:.leading, spacing: 0) {
                        VStack(alignment: .leading, spacing: 0) {
                            Text(item.subject.name)
                                .foregroundColor(.primary)
                                .font(.system(size: 20, weight: .bold, design: .rounded))
                                .padding(.bottom, 5)
                            if schedule.type == .student {
                                Text(item.teacher.print)
                                    .foregroundColor(.secondary)
                            } else {
                                Text(item.group.print)
                                    .foregroundColor(.secondary)
                            }
                        }
                        .padding(.bottom, 10)
                        Text("Этаж \(item.classroom.floor) Каб. \(item.classroom.name)")
                            .foregroundColor(.secondary)
                    }
                    .padding(.bottom, 10)
                    .padding(.horizontal)
                    .multilineTextAlignment(.leading)
                    Spacer()
                }
            }
        }.frame(maxWidth: .infinity)
    }
}
