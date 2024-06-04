import Foundation

// MARK: - JWTToken

struct JWTToken {
    // MARK: Lifecycle

    init?(string: String) {
        let encodedPatrs = string.components(separatedBy: ".")
        let parts = encodedPatrs.compactMap { Self.base64Decode($0) }

        guard parts.count >= 3 else { return nil }

        guard let header = try? JSONSerialization.jsonObject(with: parts[0], options: []) as? [String: Any] else { return nil }
        guard let payload = try? JSONSerialization.jsonObject(with: parts[1], options: []) as? [String: Any] else { return nil }
        guard let expirationDate = ((payload["exp"] as? TimeInterval).map { Date(timeIntervalSince1970: $0) }) else { return nil }

        self.header = header
        self.payload = payload
        self.signature = parts[2]

        self.expirationDate = expirationDate
    }

    // MARK: Internal

    let header: [String: Any]
    let payload: [String: Any]
    let signature: Data
    let expirationDate: Date

    static func base64Decode(_ value: String) -> Data? {
        var base64 = value
            .replacingOccurrences(of: "-", with: "+")
            .replacingOccurrences(of: "_", with: "/")

        let length = Double(base64.lengthOfBytes(using: String.Encoding.utf8))
        let requiredLength = 4 * ceil(length / 4.0)
        let paddingLength = requiredLength - length
        if paddingLength > 0 {
            let padding = "".padding(toLength: Int(paddingLength), withPad: "=", startingAt: 0)
            base64 += padding
        }
        return Data(base64Encoded: base64, options: .ignoreUnknownCharacters)
    }
}
