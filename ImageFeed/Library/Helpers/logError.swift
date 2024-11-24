import Foundation

func logError(source: String?, type: String, error: String) {
    print(getMainMessage(source, type, error))
}

func logError(source: String?, type: String, error: String, data: Data) {
    let message = getMainMessage(source, type, error)
    let dataMessage = ".\nData: \(String(data: data, encoding: .utf8) ?? "")"
    print(message + dataMessage)
}

private func getMainMessage(_ source: String?, _ type: String, _ error: String) -> String {
    return "[\(source ?? "Error")]: \(type) - \(error)"
}
