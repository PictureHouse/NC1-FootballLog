//
//  MainTabDetailView.swift
//  FootballLog
//
//  Created by Yune Cho on 4/11/24.
//

import SwiftUI
import SwiftData

struct MainTabDetailView: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.modelContext) var modelContext
    
    @Query var matches: [MatchData]
    var match: MatchData
    
    @Binding var isEditable: Bool
    @Binding var matchLog: String
    @Binding var updated: Bool
    
    @State private var preferredTeam = UserData.shared.getPreferredTeamName()
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .center) {
                VStack {
                    ZStack {
                        Circle()
                            .fill(match.homeTeamName == preferredTeam ? Color.clear : Color.gray)
                            .overlay(
                                Circle().strokeBorder(match.homeTeamName == preferredTeam ? Color.accentColor : Color.clear, lineWidth: 3)
                            )
                            .frame(width: 120, height: 120)
                        
                        AsyncImage(url: URL(string: match.homeTeamLogo)) { image in
                            image
                                .resizable()
                                .frame(width: 90, height: 90)
                        } placeholder: {
                            ProgressView()
                        }
                    }
                    .padding(.vertical)
                    
                    Text(match.homeTeamName)
                        .frame(height: 50)
                }
                
                Spacer()
                
                VStack {
                    AsyncImage(url: URL(string: match.leagueLogo)) { image in
                        image
                            .resizable()
                            .scaledToFit()
                            .frame(width: 60, height: 60)
                    } placeholder: {
                        ProgressView()
                    }
                    
                    Text("\(match.homeGoals) : \(match.awayGoals)")
                        .font(.system(size: 36))
                        .fontWeight(.bold)
                        .fontDesign(.rounded)
                    
                    Text("FT")
                }
                
                Spacer()
                
                VStack {
                    ZStack {
                        Circle()
                            .fill(match.awayTeamName == preferredTeam ? Color.clear : Color.gray)
                            .overlay(
                                Circle().strokeBorder(match.awayTeamName == preferredTeam ? Color.accentColor : Color.clear, lineWidth: 3)
                            )
                            .frame(width: 120, height: 120)
                        
                        AsyncImage(url: URL(string: match.awayTeamLogo)) { image in
                            image
                                .resizable()
                                .frame(width: 90, height: 90)
                        } placeholder: {
                            ProgressView()
                        }
                    }
                    .padding(.vertical)
                    
                    Text(match.awayTeamName)
                        .frame(height: 50)
                }
            }
            .padding(.bottom)
            
            Divider()
                .padding(.bottom)
            
            HStack {
                Image(systemName: "calendar")
                    .frame(width: 20)
                
                Text("경기일자 : \(match.matchDate)")
                
                Spacer()
            }
            .padding(.bottom)
            
            HStack {
                Image(systemName: "sportscourt")
                    .frame(width: 20)
                
                Text("경기장 : \(match.stadium)")
                
                Spacer()
            }
            .padding(.bottom)
            
            HStack {
                Image(systemName: "eyes")
                    .frame(width: 20)
                
                Text("관람방식 : \(match.wayToWatch == true ? "직관" : "중계")")

                Spacer()
            }
            .padding(.bottom)
            
            HStack {
                Image(systemName: "quote.bubble")
                    .frame(width: 20)
                
                Text("경기 한줄평")
                
                Spacer()
            }
            
            TextField("경기 한줄평", text: $matchLog)
                .submitLabel(.done)
                .border(isEditable ? Color.green : Color.clear, width: 2)
                .scrollContentBackground(.hidden)
                .textFieldStyle(.roundedBorder)
                .disabled(!isEditable)
                .onAppear {
                    matchLog = match.matchLog
                }
                .onTapGesture {
                    if isEditable == false {
                        isEditable = true
                    }
                }
            
            Spacer()
        }
        .padding()
        .bold()
        .onChange(of: updated) {
            preferredTeam = UserData.shared.getPreferredTeamName()
        }
    }
}
