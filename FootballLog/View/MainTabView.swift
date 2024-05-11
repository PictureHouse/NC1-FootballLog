//
//  MainTabView.swift
//  FootballLog
//
//  Created by Yune Cho on 4/11/24.
//

import SwiftUI
import SwiftData

struct MainTabView: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.modelContext) var modelContext
    
    @Query var matchData: [MatchData]
    
    @Binding var updated: Bool
    
    @State private var userName = UserData.shared.getUserName()
    @State private var date = Date.now
    @State private var isEditable = false
    @State private var matchLog = ""
    @State private var showDeleteAlert = false
    @State private var updated2 = false
    
    var body: some View {
        NavigationView {
            VStack {
                Image(colorScheme == .light ? "logo_light" : "logo_dark")
                    .resizable()
                    .frame(width: 170, height: 45)
                
                HStack {
                    Text(userName == "" ? "기록한 경기 목록" : "\(userName)님이 기록한 경기 목록")
                        .font(.title2)
                        .foregroundStyle(Color.accentColor)
                        .padding(.top)
                        .onChange(of: updated) {
                            userName = UserData.shared.getUserName()
                        }
                    Spacer()
                }
                
                Spacer()
                
                if matchData.isEmpty {
                    Text("기록된 경기가 없습니다.")
                        .foregroundStyle(Color.gray)
                } else {
                    List {
                        ForEach(groupedMatches, id: \.key) { (date, matches) in
                            Section(header: Text(date)) {
                                ForEach(matches) { match in
                                    NavigationLink {
                                        MainTabDetailView(match: match, isEditable: $isEditable, matchLog: $matchLog, updated: $updated2)
                                            .navigationTitle("경기 상세 기록")
                                            .toolbar {
                                                if isEditable {
                                                    ToolbarItem(placement: .topBarTrailing) {
                                                        Button(action: {
                                                            showDeleteAlert = true
                                                        }, label: {
                                                            Image(systemName: "trash.circle")
                                                                .foregroundStyle(Color.red)
                                                        })
                                                        .alert("삭제 확인", isPresented: $showDeleteAlert) {
                                                            Button(role: .destructive) {
                                                                modelContext.delete(match)
                                                            } label: {
                                                                Text("삭제")
                                                            }
                                                        } message: {
                                                            Text("기록을 삭제하시겠습니까?")
                                                        }
                                                    }
                                                    
                                                    ToolbarItem(placement: .topBarTrailing) {
                                                        Button(action: {
                                                            match.matchLog = matchLog
                                                            isEditable = false
                                                        }, label: {
                                                            Image(systemName: "checkmark.circle")
                                                        })
                                                    }
                                                } else {
                                                    ToolbarItem(placement: .topBarTrailing) {
                                                        Button(action: {
                                                            showDeleteAlert = true
                                                        }, label: {
                                                            Image(systemName: "trash.circle")
                                                                .foregroundStyle(Color.red)
                                                        })
                                                        .alert("삭제 확인", isPresented: $showDeleteAlert) {
                                                            Button(role: .destructive) {
                                                                modelContext.delete(match)
                                                            } label: {
                                                                Text("삭제")
                                                            }
                                                        } message: {
                                                            Text("기록을 삭제하시겠습니까?")
                                                        }
                                                    }
                                                    
                                                    ToolbarItem(placement: .topBarTrailing) {
                                                        Button(action: {
                                                            isEditable = true
                                                        }, label: {
                                                            Image(systemName: "square.and.pencil.circle")
                                                        })
                                                    }
                                                }
                                            }
                                            .onDisappear {
                                                isEditable = false
                                            }
                                    } label: {
                                        VStack(alignment: .leading) {
                                            Text("\(match.homeTeamName) - \(match.awayTeamName)")
                                            
                                            HStack {
                                                AsyncImage(url: URL(string: match.leagueLogo)) { image in
                                                    image
                                                        .resizable()
                                                        .scaledToFit()
                                                        .frame(width: 30, height: 30)
                                                } placeholder: {
                                                    ProgressView()
                                                }
                                                
                                                Text("\(match.leagueName)")
                                                    .foregroundStyle(Color(.gray))
                                            }
                                        }
                                        .tag(match.id)
                                    }
                                }
                            }
                        }
                    }
                }
                Spacer()
            }
            .padding()
            .bold()
            .onChange(of: updated) {
                updated2.toggle()
            }
        }
    }
    
    var groupedMatches: [(key: String, value: [MatchData])] {
        let grouped = Dictionary(grouping: matchData) { match in
            match.matchDate
        }
        return grouped.sorted { $0.key > $1.key }
    }
    
    func deleteMatchLog(match: MatchData) {
        modelContext.delete(match)
    }
}
