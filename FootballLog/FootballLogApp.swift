//
//  FootballLogApp.swift
//  FootballLog
//
//  Created by Yune Cho on 4/11/24.
//

import SwiftUI
import SwiftData

@main
struct FootballLogApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: MatchData.self)
    }
}
