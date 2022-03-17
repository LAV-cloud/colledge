//
//  ContentView.swift
//  colledge
//
//  Created by Ромка Бережной on 15.03.2022.
//

import SwiftUI

struct ContentView: View {
    
    @State
    private var state: ContentState = .onBoarding
    
    @AppStorage("schedule")
    private var schedule: Data = Data()
    
    @AppStorage("onBoarding")
    private var onBoarding: Bool = false
    
    var body: some View {
        switch state {
            case .splash:
            ProgressView()
        case .onBoarding:
            OnBoardingView(schedule: $schedule, onBoarding: $onBoarding, contentState: $state).onAppear(perform: {
                if self.onBoarding { self.state = .main }
            })
        case .main:
            MainView(schedule: $schedule)
        }
    }
}

enum ContentState {
    case splash, onBoarding, main
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
