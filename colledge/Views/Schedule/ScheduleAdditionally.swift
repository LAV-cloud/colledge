//
//  ScheduleAdditionally.swift
//  colledge
//
//  Created by Ромка Бережной on 17.03.2022.
//

import SwiftUI

struct ScheduleAdditionally: View {
    
    var item: ScheduleItem
    var items: [ScheduleItem]
    
    init(item: ScheduleItem, items: [ScheduleItem]) {
        self.item = item
        self.items = items
    }
    
    var nextItem: ScheduleItem? {
        let itemIndex = self.items.firstIndex { $0.id == item.id }!
        let haveNextItem = itemIndex < self.items.count - 1
        return haveNextItem ? self.items[itemIndex + 1] : nil
    }
    
    var body: some View {
        if item.sort != nextItem?.sort {
            if nextItem != nil {
                if nextItem!.time.start - item.time.end >= 20 {
                    ScheduleFood(item: item, nextItem: nextItem!)
                } else {
                    ScheduleRelax(item: item, nextItem: nextItem!)
                }
            } else {
                ScheduleHome()
            }
        }
    }
}

struct ScheduleRelax: View {
    
    var item: ScheduleItem
    var nextItem: ScheduleItem
    
    var body: some View {
        HStack {
            Image(systemName: "deskclock")
            VStack(alignment: .leading) {
                Text("Перерыв")
                Text("\(nextItem.time.start - item.time.end) мин")
            }
            .padding(.leading, 10)
            Spacer()
            Text("\(item.time.getEnd()) - \(nextItem.time.getStart())")
        }
        .foregroundColor(.secondary)
        .padding(10)
    }
}

struct ScheduleHome: View {
    var body: some View {
        HStack {
            Image(systemName: "house.fill")
                .foregroundColor(.blue)
            Text("Можно идти домой")
                .padding(.leading, 10)
            Spacer()
        }
        .foregroundColor(.secondary)
        .padding(10)
    }
}

struct ScheduleFood: View {
    
    var item: ScheduleItem
    var nextItem: ScheduleItem
    
    var body: some View {
        HStack {
            Image(systemName: "fork.knife")
                .foregroundColor(.orange)
            VStack(alignment:.leading) {
                Text("Обед")
                Text("\(nextItem.time.start - item.time.end) мин")
            }
            .padding(.leading, 10)
            Spacer()
            Text("\(item.time.getEnd()) - \(nextItem.time.getStart())")
        }
        .foregroundColor(.secondary)
        .padding(10)
    }
}
