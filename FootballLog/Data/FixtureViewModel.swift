//
//  MatchViewModel.swift
//  FootballLog
//
//  Created by Yune Cho on 4/16/24.
//

import Foundation

struct FixturesResponse: Decodable {
    let response: [Fixture]
}

struct Fixture: Decodable {
    let fixture: FixtureDetails
    let league: League
    let teams: Teams
    let goals: Goals
    let score: Score
}

struct FixtureDetails: Decodable, Identifiable {
    let id: Int
    let referee: String?
    let timezone: String
    let date: String
    let timestamp: Int
    let periods: Periods
    let venue: Venue
    let status: Status
}

struct Periods: Decodable {
    let first: Int
    let second: Int
}

struct Venue: Decodable {
    let id: Int
    let name: String
    let city: String
}

struct Status: Decodable {
    let long: String
    let short: String
    let elapsed: Int
}

struct League: Decodable {
    let id: Int
    let name: String
    let country: String
    let logo: String
    let flag: String
    let season: Int
    let round: String
}

struct Teams: Decodable {
    let home: TeamDetails
    let away: TeamDetails
}

struct TeamDetails: Decodable {
    let id: Int
    let name: String
    let logo: String
    let winner: Bool
}

struct Goals: Decodable {
    let home: Int?
    let away: Int?
}

struct Score: Decodable {
    let halftime: ScoreDetail?
    let fulltime: ScoreDetail?
    let extratime: ScoreDetail?
    let penalty: ScoreDetail?
}

struct ScoreDetail: Decodable {
    let home: Int?
    let away: Int?
}

class FixtureViewModel: ObservableObject {
    @Published var fixtures: [Fixture] = []

    let headers = [
        "X-RapidAPI-Key": Bundle.main.infoDictionary?["APIKey"] as! String,
        "X-RapidAPI-Host": "api-football-v1.p.rapidapi.com"
    ]

    func fetchFixtures(matchDate: Date, leagueCode: Int) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let matchDate = formatter.string(from: matchDate)
        
        let urlString = "https://api-football-v1.p.rapidapi.com/v3/fixtures?date=\(matchDate)&league=\(leagueCode)&season=2023"
        guard let url = URL(string: urlString) else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            guard let data = data, error == nil else { return }
            do {
                let decodedResponse = try JSONDecoder().decode(FixturesResponse.self, from: data)
                DispatchQueue.main.async {
                    self?.fixtures = decodedResponse.response
                }
            } catch {
                print("Failed to decode response: \(error)")
            }
        }.resume()
    }
}
