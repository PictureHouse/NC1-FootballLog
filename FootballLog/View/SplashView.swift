//
//  SplashView.swift
//  FootballLog
//
//  Created by Yune Cho on 4/18/24.
//

import SwiftUI

struct SplashView: View {
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack {
            Spacer()
            
            Image("splash_image")
                .resizable()
                .scaledToFit()
                .frame(width: 300)
            
            Image(colorScheme == .light ? "logo_light" : "logo_dark")
                .resizable()
                .scaledToFit()
                .frame(width: 250)
            
            Spacer()
            
            Text("[Version 1.0] 2024 Yune Cho")
        }
    }
}
