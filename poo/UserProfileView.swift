import SwiftUI

struct UserProfileView: View {
    @State private var userName = "John Doe"
    @State private var userEmail = "john.doe@example.com"
    @State private var userBio = "iOS Developer & SwiftUI Enthusiast"

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 120, height: 120)
                    .foregroundColor(.blue)

                Text(userName)
                    .font(.title)
                    .fontWeight(.bold)

                Text(userEmail)
                    .font(.subheadline)
                    .foregroundColor(.secondary)

                Text(userBio)
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)

                Divider()

                VStack(alignment: .leading, spacing: 10) {
                    InfoRow(title: "Posts", value: "42")
                    InfoRow(title: "Followers", value: "1,337")
                    InfoRow(title: "Following", value: "420")
                }
                .padding()

                Button(action: {
                    // Action for edit profile
                    print("Edit profile tapped")
                }) {
                    Text("Edit Profile")
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.horizontal)
            }
            .padding()
        }
        .navigationTitle("Profile")
    }
}

struct InfoRow: View {
    let title: String
    let value: String

    var body: some View {
        HStack {
            Text(title)
                .fontWeight(.semibold)
            Spacer()
            Text(value)
        }
    }
}

struct UserProfileView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            UserProfileView()
        }
    }
}
