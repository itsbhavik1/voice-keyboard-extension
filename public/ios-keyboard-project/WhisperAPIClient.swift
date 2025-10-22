//
//  WhisperAPIClient.swift
//  VoiceKeyboardExtension
//
//  Handles API communication with Groq's Whisper API
//  Uploads audio files and receives transcriptions
//

import Foundation

// MARK: - WhisperAPIError
enum WhisperAPIError: LocalizedError {
    case invalidAPIKey
    case networkError(Error)
    case invalidResponse
    case serverError(Int, String)
    case decodingError
    case fileReadError
    case timeout
    
    var errorDescription: String? {
        switch self {
        case .invalidAPIKey:
            return "Invalid API key. Please check your settings."
        case .networkError(let error):
            return "Network error: \(error.localizedDescription)"
        case .invalidResponse:
            return "Invalid response from server"
        case .serverError(let code, let message):
            return "Server error (\(code)): \(message)"
        case .decodingError:
            return "Failed to decode response"
        case .fileReadError:
            return "Failed to read audio file"
        case .timeout:
            return "Request timed out. Please try again."
        }
    }
}

// MARK: - WhisperResponse
struct WhisperResponse: Codable {
    let text: String
}

// MARK: - WhisperAPIClient
class WhisperAPIClient {
    
    // MARK: - Properties
    private let baseURL = "https://api.groq.com/openai/v1/audio/transcriptions"
    private let model = "whisper-large-v3"
    private let timeout: TimeInterval = 30.0
    
    private var apiKey: String? {
        // Try to get API key from App Group shared UserDefaults
        if let sharedDefaults = UserDefaults(suiteName: "group.com.yourcompany.voicekeyboard") {
            return sharedDefaults.string(forKey: "groq_api_key")
        }
        
        // Fallback to standard UserDefaults
        return UserDefaults.standard.string(forKey: "groq_api_key")
    }
    
    // MARK: - Public Methods
    func transcribeAudio(fileURL: URL, completion: @escaping (Result<String, WhisperAPIError>) -> Void) {
        // Validate API key
        guard let apiKey = apiKey, !apiKey.isEmpty else {
            completion(.failure(.invalidAPIKey))
            return
        }
        
        // Read audio file data
        guard let audioData = try? Data(contentsOf: fileURL) else {
            completion(.failure(.fileReadError))
            return
        }
        
        // Create request
        guard let request = createMultipartRequest(apiKey: apiKey, audioData: audioData, fileName: fileURL.lastPathComponent) else {
            completion(.failure(.invalidResponse))
            return
        }
        
        // Configure session with timeout
        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.timeoutIntervalForRequest = timeout
        sessionConfig.timeoutIntervalForResource = timeout
        let session = URLSession(configuration: sessionConfig)
        
        // Execute request
        let task = session.dataTask(with: request) { data, response, error in
            // Handle network error
            if let error = error {
                if (error as NSError).code == NSURLErrorTimedOut {
                    completion(.failure(.timeout))
                } else {
                    completion(.failure(.networkError(error)))
                }
                return
            }
            
            // Validate response
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(.invalidResponse))
                return
            }
            
            // Check status code
            guard (200...299).contains(httpResponse.statusCode) else {
                let errorMessage = self.parseErrorMessage(from: data) ?? "Unknown error"
                completion(.failure(.serverError(httpResponse.statusCode, errorMessage)))
                return
            }
            
            // Parse response data
            guard let data = data else {
                completion(.failure(.invalidResponse))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode(WhisperResponse.self, from: data)
                completion(.success(response.text))
            } catch {
                completion(.failure(.decodingError))
            }
        }
        
        task.resume()
    }
    
    // MARK: - Private Methods
    private func createMultipartRequest(apiKey: String, audioData: Data, fileName: String) -> URLRequest? {
        guard let url = URL(string: baseURL) else {
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        // Boundary for multipart form data
        let boundary = "Boundary-\(UUID().uuidString)"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        
        // Build multipart body
        var body = Data()
        
        // Add model parameter
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"model\"\r\n\r\n".data(using: .utf8)!)
        body.append("\(model)\r\n".data(using: .utf8)!)
        
        // Add language parameter (optional but recommended)
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"language\"\r\n\r\n".data(using: .utf8)!)
        body.append("en\r\n".data(using: .utf8)!)
        
        // Add audio file
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"file\"; filename=\"\(fileName)\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: audio/wav\r\n\r\n".data(using: .utf8)!)
        body.append(audioData)
        body.append("\r\n".data(using: .utf8)!)
        
        // Close boundary
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        
        request.httpBody = body
        
        return request
    }
    
    private func parseErrorMessage(from data: Data?) -> String? {
        guard let data = data,
              let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
              let error = json["error"] as? [String: Any],
              let message = error["message"] as? String else {
            return nil
        }
        return message
    }
}
