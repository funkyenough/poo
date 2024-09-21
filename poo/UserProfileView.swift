import SwiftUI

@Observable
class UserProfileViewModel {
    
    var userName :String
//    var userEmail :String
//    var userBio :String?
    var userBirthday :String?
    var userLocation :String?
    var favoriteItem :String?
    var bowelStreak :Int?
    var bowelLevel :String?
    var showEdit :Bool
    init(userName: String, userBirthday: String? = nil, userLocation: String? = nil, favoriteItem: String? = nil, bowelStreak: Int? = nil, bowelLevel: String? = nil, showEdit: Bool = false) {
        self.userName = userName
        self.userBirthday = userBirthday
        self.userLocation = userLocation
        self.favoriteItem = favoriteItem
        self.bowelStreak = bowelStreak
        self.bowelLevel = bowelLevel
        self.showEdit = showEdit
    }

}



struct UserProfileView: View {
    
    @State var viewModel: UserProfileViewModel = UserProfileViewModel(userName: "unchi", userLocation:"東京",favoriteItem:"きのこ",bowelStreak: 2, bowelLevel: "normal")
//    @State private var userName = "John Doe"
//    //@State private var userEmail = "john.doe@example.com"
//    //@State private var userBio = "iOS Developer & SwiftUI Enthusiast"
//    @State private var userBirthday = "2022.09.11"  // 誕生日
//    @State private var userLocation = "Tokyo, Japan"  // 地域
//    @State private var favoriteItem = "Kombucha"      // 好きな腸活アイテム
//    @State private var bowelStreak = 7                // うんち状況
//    @State private var bowelLevel = "Normal"          // 排便レベル
//    @State private var showEdit = false
//    
    var body: some View {
//        NavigationView {
        ScrollView {
                VStack(spacing: 15) {
                    
                    Text("プロフィール")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding()
                    Image("poo-chan")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 200, height: 150)
                        .foregroundColor(.blue)

                    Text(viewModel.userName)
                        .font(.title)
                        .fontWeight(.bold)


                    Divider()

                    // 誕生日と地域と好きな腸活アイテムの情報
                    VStack(alignment: .leading, spacing: 20) {
                        InfoRow(title: "住んでいる地域", value: viewModel.userLocation ?? "")
                        InfoRow(title: "好きな腸活アイテム", value: viewModel.favoriteItem ?? "")
                    }
                    .padding()

                    // うんち状況と排便レベルを並べて表示
                    HStack(spacing: 30) {
                        StatBox(title: "うんち状況", days: viewModel.bowelStreak, value: "")
                        StatBox(title: "排便レベル", value: viewModel.bowelLevel)
                        
//                        StatBox(title: <#T##String#>, days: <#T##Int?#>, value: <#T##String?#>)
                    }
                    .padding()
                    .frame(maxHeight: 120) // 最大の高さを制限

                    // 編集ボタン
                    Button(action: {
                        viewModel.showEdit = true
                    }) {
                        Text("プロフィールを編集する")
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .padding(.horizontal)
                }
                .padding(20)
            }
            // ナビゲーションバーのカスタマイズ
//            .toolbar {
//                ToolbarItem(placement: .principal) {
//                    VStack {
//                        Text("プロフィール")
//                            .font(.largeTile)
//                            .frame(maxWidth: .infinity)
//                    }
//                }
//            }.navigationBarTitleDisplayMode(.large)
            
//        }
        .sheet(isPresented: $viewModel.showEdit) {
            
            EditProfileView(viewModel: viewModel)
        }
        
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

struct StatBox: View {
    let title: String
    var days: Int? = nil
    let value: String?

    var body: some View {
        VStack {
            Text(title)
                .font(.subheadline)
                .fontWeight(.semibold)
                .multilineTextAlignment(.center)
                .padding(.bottom, 5)

            // 数字部分と「日連続」のテキストサイズを別々に調整
            if let days = days {
                HStack(alignment: .firstTextBaseline, spacing: 2) {
                    Text("\(days)")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    Text("日連続")
                        .font(.body) // ここで少し小さめのフォントに設定
                }
            } else if let value = value {
                Text(value)
                    .font(.title)
                    .fontWeight(.bold)
            }
        }
        .frame(maxWidth: .infinity, minHeight: 70) // 最小高さを70に設定
        .padding()
        .background(Color(.systemGray6)) // 背景色を設定
        .cornerRadius(10)                // 四角の角を丸める
        .shadow(radius: 3)               // 影を追加して立体感を演出
    }
}

struct UserProfileView_Previews: PreviewProvider {
    static var previews: some View {
        UserProfileView()
    }
}
