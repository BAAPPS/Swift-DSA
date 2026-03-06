//
//  TabBarView.swift
//  TheStackLab
//
//  Created by D F on 2/27/26.
//

import SwiftUI

struct TabBarView: View {
    @Binding var selectedTab: AppTab
    var body: some View {
        HStack {
            ForEach(AppTab.allCases) { tab in
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.2)) {
                           selectedTab = tab
                       }
                }) {
                    VStack(spacing: 4) {
                        Image(systemName: tab.systemIcon)
                            .font(.system(size: 18))
                            .foregroundColor(selectedTab == tab ? .white : .white.opacity(0.6))
                        Text(tab.title)
                            .font(.caption)
                            .foregroundColor(selectedTab == tab ? .white : .white.opacity(0.6))
                    }
                    .padding(.vertical , 8)
                    .frame(maxWidth:.infinity)
                }
            }
        }
        .background(Color.midnight950)
    }
}

#Preview {
    ZStack{
        Color.midnight100
            .ignoresSafeArea()
        TabBarView(selectedTab: .constant(.validate))
    }
}
