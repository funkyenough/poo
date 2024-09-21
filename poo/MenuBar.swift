//
//  FriendList.swift
//  poo
//
//  Created by YaoNing on 2024/09/21.
//

import SwiftUI


struct MenuBar: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }

            AIView()
                .tabItem {
                    Image(systemName: "brain.head.profile")
                    Text("AI")
                }

            CalendarRecipeView()
                .tabItem {
                    Image(systemName: "hand.raised.fill")
                    Text("Poop")
                }

            ChatView()
                .tabItem {
                    Image(systemName: "message.fill")
                    Text("Chat")
                }

            UserProfileView()
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("Profile")
                }
        }
    }
}



#Preview {
    MenuBar()
}
