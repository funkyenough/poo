//
//  AIView.swift
//  poo
//
//  Created by YaoNing on 2024/09/21.
//

import SwiftUI

struct AIView: View {
    
    @State private var response = "none"
    @State private var userInput = ""
    @State private var aiResponses: [String] = []
    @State private var isThinking = false
    @State private var showQuickQuestions = true

    struct ChatGPTKey {
        static let apiKey = "" // Replace with your actual API key
        static let orgId = "" // Replace with your actual Organization ID
    }

    let quickQuestions: [(buttonText: String, fullQuery: String)] = [
        ("便秘が続いています", "数日間便秘が続いています。食事の改善、水分摂取、睡眠スケジュール、ストレス管理の方法についてアドバイスをお願いします。"),
        ("下痢が続いています", "数日間下痢が続いています。その原因と家庭でできる対処法を教えてください。"),
        ("腹痛がひどいです", "最近腹痛がひどくなっています。考えられる原因と対処方法について教えてください。"),
        ("おならが多いです", "最近おならが多くなっています。おならを減らし、消化を改善する方法を提案してください。")
]

    struct ChatCompletionResponse: Codable {
        let id: String
        let object: String
        let created: Int
        let model: String
        let usage: Usage
        let choices: [Choice]

        // Nested Usage struct
        struct Usage: Codable {
            let promptTokens: Int
            let completionTokens: Int
            let totalTokens: Int

            enum CodingKeys: String, CodingKey {
                case promptTokens = "prompt_tokens"
                case completionTokens = "completion_tokens"
                case totalTokens = "total_tokens"
            }
        }

        // Nested Choice struct
        struct Choice: Codable {
            let message: Message
            let finishReason: String
            let index: Int

            enum CodingKeys: String, CodingKey {
                case message
                case finishReason = "finish_reason"
                case index
            }

            // Nested Message struct
            struct Message: Codable {
                let role: String
                let content: String
            }
        }
    }

    var body: some View {
        VStack {
            if showQuickQuestions {
                quickQuestionsView
            }

            ScrollView {
                VStack(alignment: .leading, spacing: 15) {
                    ForEach(aiResponses, id: \.self) { response in
                        AIResponseBubble(message: response)
                    }
                    if isThinking {
                        ThinkingIndicator()
                    }
                }
            }
            .padding(.vertical)

            Divider()

            HStack {
                TextField("Ask AI something...", text: $userInput)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .disabled(isThinking)

                Button(action: {
                    Task {
                        await sendMessage()
                    }
                }) {
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

    var quickQuestionsView: some View {
        VStack(spacing: 10) {
            ForEach(0..<2) { row in
                HStack(spacing: 10) {
                    ForEach(0..<2) { col in
                        let index = row * 2 + col
                        Button(action: {
                            userInput = quickQuestions[index].fullQuery
                            Task {
                                await sendMessage()
                            }
                            showQuickQuestions = false
                        }) {
                            Text(quickQuestions[index].buttonText)
                                .font(.body)
                                .foregroundColor(.primary)
                                .padding(8)
                                .frame(maxWidth: .infinity, minHeight: 60, alignment: .center)
                                .background(Color.gray.opacity(0.1))
                                .cornerRadius(10)
                                .multilineTextAlignment(.center)
                        }
                    }
                }
            }
        }
        .padding()
    }

    func sendMessage() async {
        let trimmedInput = userInput.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedInput.isEmpty else { return }

        isThinking = true
        aiResponses.append("You: \(trimmedInput)")
        userInput = ""
        showQuickQuestions = false

        // Simulate AI thinking delay
        try? await Task.sleep(nanoseconds: 1_500_000_000) // 1.5 seconds

        // Fetch AI response
        let aiResponse = await generateAIResponse(for: trimmedInput)
        aiResponses.append("AI: \(aiResponse)")
        isThinking = false
    }

    private func generateAIResponse(for input: String) async -> String {
        guard let url = URL(string: "https://api.openai.com/v1/chat/completions") else {
            return "URL error"
        }
        
        // Create URLRequest
        var req = URLRequest(url: url)
        req.httpMethod = "POST"
        req.allHTTPHeaderFields = [
            "Authorization": "\(ChatGPTKey.apiKey)", // Replace with your actual API key
            "OpenAI-Organization": "\(ChatGPTKey.orgId)",   // Replace with your actual Organization ID
            "Content-Type": "application/json"
        ]
        
        // Construct the request body
        let requestBody: [String: Any] = [
            "model": "gpt-3.5-turbo",
            "messages": [
                [
                    "role": "user",
                    "content": input
                ]
            ]
        ]
        
        // Serialize the request body to JSON
        do {
            req.httpBody = try JSONSerialization.data(withJSONObject: requestBody, options: [])
        } catch {
            return "Failed to encode request body: \(error.localizedDescription)"
        }
        
        // Perform the network request
        do {
            let (data, urlResponse) = try await URLSession.shared.data(for: req)
            
            // Check for HTTP response and status code
            guard let httpStatus = urlResponse as? HTTPURLResponse else {
                return "Invalid response from server."
            }
            
            guard (200...299).contains(httpStatus.statusCode) else {
                // Attempt to decode error message from API
                if let apiError = try? JSONDecoder().decode(APIErrorResponse.self, from: data) {
                    return "Error \(httpStatus.statusCode): \(apiError.error.message)"
                } else {
                    return "HTTP Error: \(httpStatus.statusCode)"
                }
            }
            
            // Decode the successful response
            let decoder = JSONDecoder()
            let response = try decoder.decode(ChatCompletionResponse.self, from: data)
            
            // Extract the content from the first choice
            if let content = response.choices.first?.message.content {
                return content.trimmingCharacters(in: .whitespacesAndNewlines)
            } else {
                return "No content received from AI."
            }
            
        } catch {
            return "Request failed: \(error.localizedDescription)"
        }
    }
    
    // Struct to handle API error responses
    struct APIErrorResponse: Codable {
        struct APIError: Codable {
            let message: String
            let type: String
            let param: String?
            let code: String?
        }
        let error: APIError
    }
}

struct AIResponseBubble: View {
    let message: String
    
    var body: some View {
        HStack(spacing: 0) {
            if !message.starts(with: "You") {
                Spacer(minLength: 16)
            }
            Text(message)
                .foregroundColor(textColor)
                .padding()
                .background(backgroundColor)
                .cornerRadius(15)
                .frame(maxWidth: 280, alignment: message.starts(with: "You") ? .leading : .trailing)
            if message.starts(with: "You") {
                Spacer(minLength: 16)
            }
        }
        .padding(.horizontal, 16)
    }
        
    private var backgroundColor: Color {
        message.starts(with: "You") ? .blue : Color.gray.opacity(0.1)
    }
    
    private var textColor: Color {
        message.starts(with: "You") ? .white : .primary
    }
}

struct ThinkingIndicator: View {
    @State private var animationAmount = 0.0

    var body: some View {
        HStack {
            Spacer()
            ForEach(0..<3) { _ in
                Circle()
                    .fill(Color.gray)
                    .frame(width: 10, height: 10)
                    .scaleEffect(animationAmount)
                    .animation(Animation.easeInOut(duration: 0.5).repeatForever().delay(Double.random(in: 0...0.2)), value: animationAmount)
            }
        }
        .padding(.trailing, 32)
        .onAppear {
            animationAmount = 1
        }
    }
}

#Preview {
    AIView()
}
