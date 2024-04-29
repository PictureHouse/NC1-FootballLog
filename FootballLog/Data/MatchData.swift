//
//  MatchData.swift
//  FootballLog
//
//  Created by Yune Cho on 4/15/24.
//

import Foundation
import SwiftData

@Model
final class MatchData: Identifiable {
    var id: Int
    var matchDate: String
    var stadium: String
    var leagueName: String
    var leagueLogo: String
    var season: Int
    var round: String
    var homeTeamName: String
    var homeTeamLogo: String
    var homeGoals: Int
    var awayTeamName : String
    var awayTeamLogo: String
    var awayGoals: Int
    var wayToWatch: Bool
    var matchLog: String
    
    init(id: Int, matchDate: String, stadium: String, leagueName: String, leagueLogo: String, season: Int, round: String, homeTeamName: String, homeTeamLogo: String, homeGoals: Int, awayTeamName: String, awayTeamLogo: String, awayGoals: Int, wayToWatch: Bool, matchLog: String) {
        self.id = id
        self.matchDate = matchDate
        self.stadium = stadium
        self.leagueName = leagueName
        self.leagueLogo = leagueLogo
        self.season = season
        self.round = round
        self.homeTeamName = homeTeamName
        self.homeTeamLogo = homeTeamLogo
        self.homeGoals = homeGoals
        self.awayTeamName = awayTeamName
        self.awayTeamLogo = awayTeamLogo
        self.awayGoals = awayGoals
        self.wayToWatch = wayToWatch
        self.matchLog = matchLog
    }
}
