//
//  EditProfileView.swift
//  poo
//
//  Created by 松崎紗良 on 2024/09/21.
//

import SwiftUI

struct EditProfileView: View {
    @Environment(\.presentationMode) var presentationMode
    @Bindable var viewModel: UserProfileViewModel
    
    var body: some View {
        
        Form {
            Section(header:
                        VStack {
                Spacer()
                Text("プロフィール編集")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding()
                    .foregroundColor(.black)
                Image("poo-chan")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width:200, height: 150)
                Spacer()
            }
                .frame(maxWidth: .infinity)
            ) {
                VStack {
                    Text("ユーザー名")
                    TextField("ユーザー名", text: $viewModel.userName)
                }
                VStack{
                        Text("住んでいる地域")
                        TextField("住んでいる地域", text:$viewModel.userLocation.toUnwrapped(defaultValue: ""))
                }
                VStack{
                    Text("好きな腸活アイテム")
                    TextField("好きな腸活アイテム", text: $viewModel.favoriteItem.toUnwrapped(defaultValue: ""))
                }
                VStack{
                    Text("おすすめの公衆トイレ")
                    TextField("おすすめの公衆トイレ", text: $viewModel.favoritePlace.toUnwrapped(defaultValue: ""))
                }
            }
        }
            // 編集ボタン
            Button(action: {
                viewModel.showEdit = true
            }) {
                Text("Submit")
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
                    .padding(.horizontal)
                }
                //.padding(20)
        
    }





        
        #Preview {
            EditProfileView(viewModel: .init(userName: ""))
        }
        
        extension Binding {
            func toUnwrapped<T>(defaultValue: T) -> Binding<T> where Value == Optional<T>  {
                Binding<T>(get: { self.wrappedValue ?? defaultValue }, set: { self.wrappedValue = $0 })
            }
        }
