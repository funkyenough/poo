//
//  AIView.swift
//  poo
//
//  Created by YaoNing on 2024/09/21.
//

import SwiftUI
struct AIView: View {
    @State private var userInput = ""
    @State private var aiResponses: [String] = []
    @State private var isThinking = false

    var body: some View {
        VStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 15) {
                    ForEach(aiResponses, id: \.self) { response in
                        AIResponseBubble(message: response)
                    }
                    if isThinking {
                        ThinkingIndicator()
                    }
                }
                .padding()
            }

            Divider()

            HStack {
                TextField("Ask AI something...", text: $userInput)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .disabled(isThinking)

                Button(action: sendMessage) {
                    Image(systemName: "paperplane.fill")
                        .foregroundColor(.white)
                        .padding(10)
                        .background(Color.blue)
                        .clipShape(Circle())
                }
                .disabled(userInput.isEmpty || isThinking)
            }
            .padding()
        }
        .navigationTitle("AI Assistant")
    }

    func sendMessage() {
        let trimmedInput = userInput.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedInput.isEmpty else { return }

        isThinking = true
        aiResponses.append("You: \(trimmedInput)")
        userInput = ""

        // Simulate AI thinking and response
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            let aiResponse = generateAIResponse(for: trimmedInput)
            aiResponses.append("AI: \(aiResponse)")
            isThinking = false
        }
    }

    func generateAIResponse(for input: String) -> String {
        // This is a placeholder. In a real app, you'd call your AI model or API here.
        let responses = [
            "That's an interesting question. Let me think about it.",
            "I'm not sure about that, but here's what I know...",
            "Based on my current knowledge, I'd say...",
            "That's a complex topic. Here's a simplified explanation:",
            "I don't have a definitive answer, but we could explore this further."
        ]
        return responses.randomElement() ?? "I'm sorry, I don't have an answer for that."
    }
}

struct AIResponseBubble: View {
    let message: String

    var body: some View {
        Text(message)
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(15)
    }
}

struct ThinkingIndicator: View {
    @State private var animationAmount = 0.0

    var body: some View {
        HStack {
            ForEach(0..<3) { _ in
                Circle()
                    .fill(Color.gray)
                    .frame(width: 10, height: 10)
                    .scaleEffect(animationAmount)
                    .animation(Animation.easeInOut(duration: 0.5).repeatForever().delay(Double.random(in: 0...0.2)), value: animationAmount)
            }
        }
        .onAppear {
            animationAmount = 1
        }
    }
}

 
#Preview {
    AIView()
}
