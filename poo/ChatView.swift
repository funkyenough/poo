//
//  ChatView.swift
//  poo
//
//  Created by YaoNing on 2024/09/21.
//

import SwiftUI



struct Message: Identifiable {
    let id = UUID()
    let content: String
    let isUser: Bool
    let timestamp: Date
}

struct ChatView: View {
    @State private var messages: [Message] = []
    @State private var newMessageText = ""
    @State private var showingEmojPicker = false

    var body: some View {
        VStack {
            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack(spacing: 10) {
                        ForEach(messages) { message in
                            MessageBubble(message: message)
                        }
                    }
                    .padding()
                }
                .onChange(of: messages.count) { _ in
                    withAnimation {
                        proxy.scrollTo(messages.last?.id, anchor: .bottom)
                    }
                }
            }

            HStack {
                Button(action: { showingEmojPicker.toggle() }) {
                    Image(systemName: "face.smiling")
                        .foregroundColor(.gray)
                }

                TextField("Type a message", text: $newMessageText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(height: 40)

                Button(action: sendMessage) {
                    Image(systemName: "paperplane.fill")
                        .foregroundColor(.white)
                        .padding(10)
                        .background(Color.blue)
                        .clipShape(Circle())
                }
                .disabled(newMessageText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            }
            .padding()
        }
        .navigationTitle("Chat")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showingEmojPicker) {
            EmojiPickerView(onEmojiSelected: { emoji in
                newMessageText += emoji
            })
        }
    }

    func sendMessage() {
        let trimmedMessage = newMessageText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedMessage.isEmpty else { return }

        let newMessage = Message(content: trimmedMessage, isUser: true, timestamp: Date())
        messages.append(newMessage)
        newMessageText = ""

        // Simulate a reply
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            let reply = Message(content: "Thanks for your message!", isUser: false, timestamp: Date())
            messages.append(reply)
        }
    }
}

struct MessageBubble: View {
    let message: Message

    var body: some View {
        HStack {
            if message.isUser { Spacer() }
            Text(message.content)
                .padding()
                .background(message.isUser ? Color.blue : Color.gray.opacity(0.2))
                .foregroundColor(message.isUser ? .white : .primary)
                .cornerRadius(20)
            if !message.isUser { Spacer() }
        }
    }
}

struct EmojiPickerView: View {
    let onEmojiSelected: (String) -> Void
    let emojis = ["😀", "😃", "😄", "😁", "😆", "😅", "😂", "🤣", "😊", "😇"]

    var body: some View {
        ScrollView {
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 40))], spacing: 20) {
                ForEach(emojis, id: \.self) { emoji in
                    Button(action: { onEmojiSelected(emoji) }) {
                        Text(emoji)
                            .font(.largeTitle)
                    }
                }
            }
            .padding()
        }
    }
}

#Preview {
    ChatView()
}
