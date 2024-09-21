//
//  FriendList.swift
//  poo
//
//  Created by YaoNing on 2024/09/21.
//

import SwiftUI


struct MenuBar: View {
    init(){

           UITabBar.appearance().backgroundColor = UIColor.white
       }

    var body: some View {

        
        TabView {
            CalendarView(friends: [])
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }

            AIView()
                .tabItem {
                    Image(systemName: "brain.head.profile")
                    Text("AI")
                }

            PooView(selectedDate: Date()){_,_ in

            }
                .tabItem {
                    ScaledImage(name: "poo-chan", size: CGSize(width: 24, height: 24))

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


struct ScaledImage: View {
    let name: String
    let size: CGSize

    var body: Image {
        let uiImage = resizedImage(named: self.name, for: self.size) ?? UIImage()

        return Image(uiImage: uiImage.withRenderingMode(.alwaysOriginal))
    }

    func resizedImage(named: String, for size: CGSize) -> UIImage? {
        guard let image = UIImage(named: named) else {
            return nil
        }

        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { (context) in
            image.draw(in: CGRect(origin: .zero, size: size))
        }
    }
}
