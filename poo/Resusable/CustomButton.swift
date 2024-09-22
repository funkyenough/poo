//
//  CustomButton.swift
//  poo
//
//  Created by YaoNing on 2024/09/22.
//

import SwiftUI

struct LogoutButton: View {
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: "rectangle.portrait.and.arrow.right")
                Text("Logout")
            }
            .frame(minWidth: 0, maxWidth: .infinity)
            .padding()
            .background(Color.secondaryColor)
            .foregroundColor(.white)
            .cornerRadius(10)
            .shadow(radius: 3)
        }
    }
}
#Preview {
    LogoutButton(){
        
    }
}
