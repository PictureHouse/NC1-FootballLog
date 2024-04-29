//
//  UserTabView.swift
//  FootballLog
//
//  Created by Yune Cho on 4/11/24.
//

import SwiftUI

struct UserTabView: View {
    @Environment(\.colorScheme) var colorScheme
    
    @StateObject private var teamViewModel = TeamViewModel()
    
    @State private var userName = UserData.shared.getUserName()
    @State private var preferredLeague = UserData.shared.getPreferredLeague()
    @State private var preferredTeamName = UserData.shared.getPreferredTeamName()
    @State private var preferredTeamLogo = UserData.shared.getPreferredTeamLogo()
    @State private var preferredWayToWatch = UserData.shared.getPreferredWayToWatch()
    
    @State private var isChanged = false
    @State private var showSavedAlert = false
    @Binding var currentTab: Int
    
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
                    Text("사용자 정보 및 설정")
                        .font(.title2)
                        .foregroundStyle(Color.accentColor)
                        .padding(.vertical)
                    Spacer()
                }
                .onTapGesture {
                    self.hideKeyboard()
                }
                
                HStack {
                    Label("사용자명", systemImage: "person.fill")
                        .foregroundStyle(Color.accentColor)
                    Spacer()
                }
                .onTapGesture {
                    self.hideKeyboard()
                }
                
                TextField(userName == "" ? "사용자명을 입력하세요." : "\(userName)", text: $userName)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled(true)
                    .textFieldStyle(.roundedBorder)
                    .submitLabel(.done)
                    .padding(.bottom)
                    .onChange(of: userName) {
                        isChanged = true
                    }
                    .background(
                        Color.clear
                            .onTapGesture {
                                self.hideKeyboard()
                            }
                    )
                
                HStack {
                    Label("응원하는 팀", systemImage: "soccerball.inverse")
                        .foregroundStyle(Color.accentColor)
                    Spacer()
                }
                .padding(.bottom)
                .onTapGesture {
                    self.hideKeyboard()
                }
                
                Picker("리그 선택", selection: $preferredLeague) {
                    Text("잉글랜드 프리미어 리그").tag(39)
                    Text("독일 분데스리가").tag(78)
                    Text("이탈리아 세리에A").tag(135)
                    Text("스페인 라리가").tag(140)
                    Text("프랑스 리그앙").tag(61)
                    Text("대한민국 K리그").tag(292)
                }
                .pickerStyle(.navigationLink)
                .foregroundStyle(colorScheme == .light ? Color(.black) : Color(.white))
                .padding(.bottom)
                .onChange(of: preferredLeague) {
                    isChanged = true
                }
                
                Picker("팀 선택", selection: $preferredTeamName) {
                    Text("선택된 팀 없음").tag("None")
                    ForEach(teamViewModel.teams) { team in
                        HStack {
                            AsyncImage(url: URL(string: team.logo)) { image in
                                image.resizable()
                            } placeholder: {
                                ProgressView()
                            }
                            .frame(width: 30, height: 30)
                            
                            Text(team.name)
                        }
                        .tag(team.name)
                    }
                }
                .pickerStyle(.navigationLink)
                .foregroundStyle(colorScheme == .light ? Color(.black) : Color(.white))
                .padding(.bottom)
                .onChange(of: preferredTeamName, { _, newValue  in
                    if let selectedTeam = teamViewModel.teams.first(where: { $0.name == newValue }) {
                        preferredTeamLogo = selectedTeam.logo
                    }
                    isChanged = true
                })
                .onAppear {
                    teamViewModel.fetchTeams(leagueCode: preferredLeague)
                }
                
                HStack {
                    Label("선호하는 관람 방식", systemImage: "sportscourt")
                        .foregroundStyle(Color.accentColor)
                        .onTapGesture {
                            self.hideKeyboard()
                        }
                    Spacer()
                    
                    Picker(selection: $preferredWayToWatch) {
                        Text("직관").tag(true)
                        
                        Text("중계").tag(false)
                    } label: {
                        Text("선호하는 관람 방식")
                    }
                    .pickerStyle(.segmented)
                    .frame(width: 140)
                    .onChange(of: preferredWayToWatch) {
                        isChanged = true
                    }
                }
                
                Button(action: {
                    UserData.shared.setUserName(name: userName)
                    UserData.shared.setPreferredLeague(leagueCode: preferredLeague)
                    UserData.shared.setPreferredTeamName(teamName: preferredTeamName)
                    UserData.shared.setPreferredTeamLogo(logo: preferredTeamLogo)
                    UserData.shared.setPreferredWayToWatch(wayToWatch: preferredWayToWatch)
                    showSavedAlert = true
                    isChanged = false
                }, label: {
                    Text("저장하기")
                })
                .buttonStyle(.borderedProminent)
                .padding()
                .disabled(!isChanged)
                .alert("저장 완료", isPresented: $showSavedAlert) {
                    Button(action: {
                        currentTab = 0
                    }, label: {
                        Text("확인")
                    })
                    .foregroundStyle(Color(.accent))
                } message: {
                    Text("사용자 정보 및 설정 저장을 완료했습니다.")
                }
                
                Spacer()
            }
            .padding()
            .bold()
            .background(
                Color.clear
                    .onTapGesture {
                        self.hideKeyboard()
                    }
            )
        }
    }
    
    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
