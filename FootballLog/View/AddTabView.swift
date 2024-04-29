//
//  AddTabView.swift
//  FootballLog
//
//  Created by Yune Cho on 4/11/24.
//

import SwiftUI
import SwiftData

struct AddTabView: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.modelContext) var modelContext
    
    @Query var matches: [MatchData]
    
    @StateObject private var fixtureViewModel = FixtureViewModel()
    
    @Binding var currentTab: Int
    @State private var showSavedAlert = false
    
    @State private var selectedDate = Date.now
    @State private var selectedLeague = UserData.shared.getPreferredLeague()
    @State private var selectedFixtureId = 0
    @State private var fixtureCache: [Fixture] = []
    @State private var wayToWatch = UserData.shared.getPreferredWayToWatch()
    @State private var matchLog = ""
    
    var body: some View {
        NavigationView {
            VStack {
                Image(colorScheme == .light ? "logo_light" : "logo_dark")
                    .resizable()
                    .frame(width: 170, height: 45)
                    .onTapGesture {
                        self.hideKeyboard()
                    }
                
                HStack {
                    Text("축구 기록 추가")
                        .font(.title2)
                        .foregroundStyle(Color.accentColor)
                        .padding(.vertical)
                    Spacer()
                }
                .onTapGesture {
                    self.hideKeyboard()
                }
                
                VStack {
                    HStack {
                        Label("언제 보셨나요?", systemImage: "calendar")
                            .foregroundStyle(Color.accentColor)
                            .onTapGesture {
                                self.hideKeyboard()
                            }
                        Spacer()
                        
                        DatePicker("경기 날짜 선택", selection: $selectedDate, in: ...Date.now, displayedComponents: .date)
                            .datePickerStyle(.compact)
                            .labelsHidden()
                            .onChange(of: selectedDate) { _, _ in
                                fixtureViewModel.fetchFixtures(matchDate: selectedDate, leagueCode: selectedLeague)
                            }
                    }
                    .padding(.bottom)

                    HStack {
                        Label("어느 경기를 보셨나요?", systemImage: "soccerball.inverse")
                            .foregroundStyle(Color.accentColor)
                        Spacer()
                    }
                    .padding(.bottom)
                    .onTapGesture {
                        self.hideKeyboard()
                    }
                    
                    Picker("리그 선택", selection: $selectedLeague) {
                        Text("잉글랜드 프리미어 리그").tag(39)
                        Text("독일 분데스리가").tag(78)
                        Text("이탈리아 세리에A").tag(135)
                        Text("스페인 라리가").tag(140)
                        Text("프랑스 리그앙").tag(61)
                        Text("대한민국 K리그").tag(292)
                    }
                    .pickerStyle(.navigationLink)
                    .foregroundStyle(colorScheme == .light ? Color(.black) : Color(.white))
                    .onChange(of: selectedLeague) { _, _ in
                        fixtureViewModel.fetchFixtures(matchDate: selectedDate, leagueCode: selectedLeague)
                    }
                    
                    Picker("경기 선택", selection: $selectedFixtureId) {
                        Text("선택된 경기 없음").tag(0)
                        ForEach(fixtureViewModel.fixtures, id: \.fixture.id) { fixture in
                            Text("\(fixture.teams.home.name) - \(fixture.teams.away.name)")
                                .onAppear(perform: {
                                    fixtureCache.append(fixture)
                                })
                                .tag(fixture.fixture.id)
                        }
                    }
                    .pickerStyle(.navigationLink)
                    .foregroundStyle(colorScheme == .light ? Color(.black) : Color(.white))
                    .padding(.vertical)
                    
                    HStack {
                        Label("어디서 보셨나요?", systemImage: "sportscourt")
                            .foregroundStyle(Color.accentColor)
                            .onTapGesture {
                                self.hideKeyboard()
                            }
                        Spacer()
                        
                        Picker(selection: $wayToWatch) {
                            Text("직관").tag(true)
                            
                            Text("중계").tag(false)
                        } label: {
                            Text("관람 방식")
                        }
                        .pickerStyle(.segmented)
                        .frame(width: 140)
                    }
                    .padding(.vertical)
                    
                    HStack {
                        Label("경기 한줄평을 기록해보세요.", systemImage: "pencil.and.scribble")
                            .foregroundStyle(Color.accentColor)
                        Spacer()
                    }
                    .padding(.top)
                    .onTapGesture {
                        self.hideKeyboard()
                    }
                    
                    TextField("경기 한줄평", text: $matchLog)
                        .submitLabel(.done)
                        .autocorrectionDisabled(true)
                        .textFieldStyle(.roundedBorder)
                        .background(
                            Color(.clear)
                                .onTapGesture {
                                    self.hideKeyboard()
                                }
                        )
                    
                    Button(action: {
                        for fixture in fixtureCache {
                            if fixture.fixture.id == selectedFixtureId {
                                addMatchLog(
                                    date: selectedDate,
                                    fixture: fixture,
                                    wayToWatch: wayToWatch,
                                    matchLog: matchLog
                                )
                                showSavedAlert = true
                                break
                            }
                        }
                    }, label: {
                        Text("저장하기")
                    })
                    .buttonStyle(.borderedProminent)
                    .padding()
                    .disabled(selectedFixtureId == 0)
                    .alert("저장 완료", isPresented: $showSavedAlert) {
                        Button(action: {
                            selectedDate = Date.now
                            selectedLeague = UserData.shared.getPreferredLeague()
                            selectedFixtureId = 0
                            wayToWatch = UserData.shared.getPreferredWayToWatch()
                            matchLog = ""
                            
                            currentTab = 0
                        }, label: {
                            Text("확인")
                        })
                        .foregroundStyle(Color(.accent))
                    } message: {
                        Text("경기 기록 저장을 완료했습니다.")
                    }
                    
                    Spacer()
                }
                .tabViewStyle(.page(indexDisplayMode: .always))
                .indexViewStyle(.page(backgroundDisplayMode: .always))
            }
            .padding()
            .bold()
        }
    }
    
    func addMatchLog(date: Date, fixture: Fixture, wayToWatch: Bool, matchLog: String) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let matchDate = formatter.string(from: date)
        
        let newMatchLog = MatchData(
            id: fixture.fixture.id,
            matchDate: matchDate,
            stadium: fixture.fixture.venue.name,
            leagueName: fixture.league.name,
            leagueLogo: fixture.league.logo,
            season: fixture.league.season,
            round: fixture.league.round,
            homeTeamName: fixture.teams.home.name,
            homeTeamLogo: fixture.teams.home.logo,
            homeGoals: fixture.goals.home ?? 0,
            awayTeamName: fixture.teams.away.name,
            awayTeamLogo: fixture.teams.away.logo,
            awayGoals: fixture.goals.away ?? 0,
            wayToWatch: wayToWatch,
            matchLog: matchLog
        )
        
        modelContext.insert(newMatchLog)
    }
    
    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
