import Cocoa

public struct Application: Identifiable, Codable, Hashable, Sendable {
  public struct Metadata: Codable, Hashable, Sendable {
    public var isAgent: Bool = false
    public var isElectron: Bool = false
    public var isSafariWebApp: Bool = false
  }

  public var id: String { path }
  public let bundleIdentifier: String
  public let bundleName: String
  public let path: String
  public var metadata: Metadata = Metadata()
  public var displayName: String

  public init(bundleIdentifier: String,
              bundleName: String,
              displayName: String? = nil,
              path: String) {
    self.bundleIdentifier = bundleIdentifier
    self.bundleName = bundleName
    self.displayName = displayName ?? bundleName
    self.path = path
  }

  enum CodingKeys: String, CodingKey {
    case bundleIdentifier
    case bundleName
    case displayName
    case path
    case metadata
  }

  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)

    self.bundleIdentifier = try container.decode(String.self, forKey: .bundleIdentifier)
    self.bundleName = try container.decode(String.self, forKey: .bundleName)
    self.path = try container.decode(String.self, forKey: .path)
    self.metadata = (try? container.decodeIfPresent(Metadata.self, forKey: .metadata)) ?? Metadata()

    do {
      self.displayName = try container.decode(String.self, forKey: .displayName)
    } catch {
      self.displayName = FileManager.default.displayName(atPath: self.path)
    }
  }

  public func encode(to encoder: any Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(self.bundleIdentifier, forKey: .bundleIdentifier)
    try container.encode(self.bundleName, forKey: .bundleName)
    try container.encode(self.path, forKey: .path)
    try container.encode(self.displayName, forKey: .displayName)
  }

  public static func ==(lhs: Application, rhs: Application) -> Bool {
    lhs.bundleIdentifier == rhs.bundleIdentifier &&
    lhs.bundleName == rhs.bundleName &&
    lhs.path == rhs.path
  }
}
