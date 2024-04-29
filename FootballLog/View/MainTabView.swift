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
    
    @State private var date = Date.now
    @State private var isEditable = false
    @State private var matchLog = ""
    @State private var showDeleteAlert = false
    
    var body: some View {
        NavigationView {
            VStack {
                Image(colorScheme == .light ? "logo_light" : "logo_dark")
                    .resizable()
                    .frame(width: 170, height: 45)
                
                HStack {
                    Text("기록한 경기 목록")
                        .font(.title2)
                        .foregroundStyle(Color.accentColor)
                        .padding(.vertical)
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
                                        MainTabDetailView(match: match, isEditable: $isEditable, matchLog: $matchLog)
                                            .navigationTitle("경기 상세 기록")
                                            .toolbar {
                                                if isEditable {
                                                    ToolbarItem(placement: .topBarTrailing) {
                                                        Button(action: {
                                                            match.matchLog = matchLog
                                                            isEditable = false
                                                        }, label: {
                                                            Text("저장")
                                                        })
                                                    }
                                                } else {
                                                    ToolbarItem(placement: .topBarTrailing) {
                                                        Button(action: {
                                                            isEditable = true
                                                        }, label: {
                                                            Text("수정")
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
                                }
                            }
                        }
                        //.onDelete(perform: deleteMatchLog)
                    }
                }
                Spacer()
            }
            .padding()
            .bold()
        }
    }
    
    /*
    func deleteMatchLog(_ indexSet: IndexSet) {
        for index in indexSet {
            let match = matchData[index]
            modelContext.delete(match)
        }
    }
    */
    
    var groupedMatches: [(key: String, value: [MatchData])] {
        let grouped = Dictionary(grouping: matchData) { match in
            match.matchDate
        }
        return grouped.sorted { $0.key > $1.key }
    }
}

#Preview {
    MainTabView()
        .modelContainer(for: MatchData.self)
}
