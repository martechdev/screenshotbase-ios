import Foundation

public final class ScreenshotbaseClient {
    public struct Configuration {
        public let apiKey: String
        public let baseURL: URL

        public init(apiKey: String, baseURL: URL = URL(string: "https://api.screenshotbase.com")!) {
            self.apiKey = apiKey
            self.baseURL = baseURL
        }
    }

    private let configuration: Configuration
    private let urlSession: URLSession

    public init(configuration: Configuration, urlSession: URLSession = .shared) {
        self.configuration = configuration
        self.urlSession = urlSession
    }

    // MARK: - Public API

    /// Capture a website screenshot using arbitrary options supported by Screenshotbase.
    /// The options dictionary will be JSON-encoded and sent to POST /capture.
    /// The returned value is a JSON object represented as [String: Any].
    @available(iOS 15.0, macOS 12.0, *)
    public func capture(options: [String: Any]) async throws -> [String: Any] {
        let request = try makeCaptureRequest(options: options)
        let (data, response) = try await urlSession.data(for: request)
        try Self.validateHTTPResponse(response)
        return try Self.jsonObject(from: data)
    }

    /// Backwards compatible completion-handler variant for platforms without async/await.
    public func capture(options: [String: Any], completion: @escaping (Result<[String: Any], Error>) -> Void) {
        do {
            let request = try makeCaptureRequest(options: options)
            let task = urlSession.dataTask(with: request) { data, response, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                do {
                    guard let data = data, let response = response else {
                        throw NSError(domain: "Screenshotbase", code: -1, userInfo: [NSLocalizedDescriptionKey: "Empty response"]) }
                    try Self.validateHTTPResponse(response)
                    let json = try Self.jsonObject(from: data)
                    completion(.success(json))
                } catch {
                    completion(.failure(error))
                }
            }
            task.resume()
        } catch {
            completion(.failure(error))
        }
    }

    // MARK: - Internals

    private func makeCaptureRequest(options: [String: Any]) throws -> URLRequest {
        let url = configuration.baseURL.appendingPathComponent("capture")
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(configuration.apiKey, forHTTPHeaderField: "apikey")
        request.httpBody = try JSONSerialization.data(withJSONObject: options, options: [])
        return request
    }

    private static func validateHTTPResponse(_ response: URLResponse) throws {
        guard let http = response as? HTTPURLResponse else { return }
        guard 200..<300 ~= http.statusCode else {
            throw NSError(domain: "Screenshotbase", code: http.statusCode, userInfo: [NSLocalizedDescriptionKey: "HTTP \(http.statusCode)"]) }
    }

    private static func jsonObject(from data: Data) throws -> [String: Any] {
        let obj = try JSONSerialization.jsonObject(with: data, options: [])
        guard let json = obj as? [String: Any] else {
            throw NSError(domain: "Screenshotbase", code: -2, userInfo: [NSLocalizedDescriptionKey: "Unexpected JSON structure"]) }
        return json
    }
}


