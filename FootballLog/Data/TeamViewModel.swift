//
//  Team.swift
//  FootballLog
//
//  Created by Yune Cho on 4/15/24.
//

import Foundation

struct Team: Codable, Identifiable {
    var id: Int
    var name: String
    var logo: String
}

struct TeamsResponse: Codable {
    struct Response: Codable {
        var team: Team
    }
    
    var response: [Response]
}

class TeamViewModel: ObservableObject {
    @Published var teams: [Team] = []
    
    let headers = [
        "X-RapidAPI-Key": Bundle.main.infoDictionary?["APIKey"] as! String,
        "X-RapidAPI-Host": "api-football-v1.p.rapidapi.com"
    ]

    func fetchTeams(leagueCode: Int) {
        guard let url = URL(string: "https://api-football-v1.p.rapidapi.com/v3/teams?league=\(leagueCode)&season=2023") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else { return }
            if let responseTeams = try? JSONDecoder().decode(TeamsResponse.self, from: data) {
                DispatchQueue.main.async {
                    self.teams = responseTeams.response.map { $0.team }
                }
            }
        }.resume()
    }
}
