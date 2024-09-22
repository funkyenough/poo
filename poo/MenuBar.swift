//
//  FriendList.swift
//  poo
//
//  Created by YaoNing on 2024/09/21.
//

import SwiftUI


struct MenuBar: View {
    @Environment(\.presentationMode) var presentationMode
    init(){

           UITabBar.appearance().backgroundColor = UIColor.white
       }

    var body: some View {

        
        TabView {
            CalendarView()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }
                .tag(0)

            AIView()
                .tabItem {
                    Image(systemName: "brain.head.profile")
                    Text("AI")
                }
                .tag(1)

            PooView(selectedDate: Date(), isSheet: false){_ in

            }
                .tabItem {
                    ScaledImage(name: "poo-chan", size: CGSize(width: 24, height: 24))
                    Text("Poo")
                }
                .tag(2)

            MapView()
                .tabItem {
                    Image(systemName: "message.fill")
                    Text("Chat")
                }
                .tag(3)

            UserProfileView()
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("Profile")
                }
                .tag(4)
        }
//        .overlay(
//            VStack {
//                Spacer()
//                LogoutButton(action: {
//                    // Perform logout action
//                    presentationMode.wrappedValue.dismiss()
//                })
//                .padding()
//            }
//        )

    }
}



#Preview {
    MenuBar()
        .environmentObject(PooViewModel())
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
