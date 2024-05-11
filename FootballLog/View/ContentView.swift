//
//  ContentView.swift
//  FootballLog
//
//  Created by Yune Cho on 4/11/24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @State private var showMainView = false
    @State private var currentTab = 0
    @State private var updated = false
    
    var body: some View {
        if showMainView {
            TabView(selection: $currentTab) {
                MainTabView(updated: $updated)
                    .tabItem {
                        Image(systemName: "list.bullet")
                        Text("경기목록")
                    }
                    .tag(0)
                
                AddTabView(currentTab: $currentTab, updated: $updated)
                    .tabItem {
                        Image(systemName: "plus.square")
                        Text("기록추가")
                    }
                    .tag(1)
                
                UserTabView(currentTab: $currentTab, updated: $updated)
                    .tabItem {
                        Image(systemName: "person")
                        Text("사용자")
                    }
                    .tag(2)
            }
        } else {
            SplashView()
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        withAnimation {
                            showMainView = true
                        }
                    }
                }
        }
    }
}

#Preview {
    ContentView()
}
