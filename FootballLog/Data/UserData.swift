//
//  UserData.swift
//  FootballLog
//
//  Created by Yune Cho on 4/13/24.
//

import Foundation
import SwiftUI

class UserData {
    @AppStorage("userName") private var userName = ""
    @AppStorage("preferredLeague") private var preferredLeague = 39
    @AppStorage("preferredTeamName") private var preferredTeamName = ""
    @AppStorage("preferredTeamLogo") private var preferredTeamLogo = ""
    @AppStorage("preferredWayToWatch") private var preferredWayToWatch = true
    
    static let shared = UserData()
    
    init() {}
    
    func getUserName() -> String {
        return self.userName
    }
    
    func setUserName(name: String) {
        self.userName = name
    }
    
    func getPreferredLeague() -> Int {
        return self.preferredLeague
    }
    
    func setPreferredLeague(leagueCode: Int) {
        self.preferredLeague = leagueCode
    }
    
    func getPreferredTeamName() -> String {
        return self.preferredTeamName
    }
    
    func setPreferredTeamName(teamName: String) {
        self.preferredTeamName = teamName
    }
    
    func getPreferredTeamLogo() -> String {
        return self.preferredTeamLogo
    }
    
    func setPreferredTeamLogo(logo: String) {
        self.preferredTeamLogo = logo
    }
    
    func getPreferredWayToWatch() -> Bool {
        return self.preferredWayToWatch
    }
    
    func setPreferredWayToWatch(wayToWatch: Bool) {
        self.preferredWayToWatch = wayToWatch
    }
}
