import Foundation

struct NetworkConfiguration {
    static let urlSession: URLSession = UITesting() ? SeededURLSession() : URLSession.shared
}

private func UITesting() -> Bool {
    return ProcessInfo.processInfo.arguments.contains("UI-TESTING")
}
