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
    
    func getPreferredLeague() -> Int {
        return self.preferredLeague
    }
    
    func getPreferredTeamName() -> String {
        return self.preferredTeamName
    }
    
    func getPreferredTeamLogo() -> String {
        return self.preferredTeamLogo
    }
    
    func getPreferredWayToWatch() -> Bool {
        return self.preferredWayToWatch
    }
    
    func setUserData(name: String, leagueCode: Int, teamName: String, teamLogo: String, wayToWatch: Bool) {
        self.userName = name
        self.preferredLeague = leagueCode
        self.preferredTeamName = teamName
        self.preferredTeamLogo = teamLogo
        self.preferredWayToWatch = wayToWatch
    }
}
