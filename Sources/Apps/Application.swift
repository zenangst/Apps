import Cocoa

public struct Application: Identifiable, Codable, Hashable, Sendable {
  public struct Metadata: Hashable, Sendable {
    public var isAgent: Bool = false
    public var isElectron: Bool = false
  }

  public var id: String { bundleIdentifier }
  public let bundleIdentifier: String
  public let bundleName: String
  public let path: String
  public var metadata: Metadata = Metadata()
  public private(set) var displayName: String = ""

  public init(bundleIdentifier: String,
              bundleName: String,
              displayName: String? = nil,
              path: String) {
    self.bundleIdentifier = bundleIdentifier
    self.bundleName = bundleName
    self.path = path
    self.displayName = displayName ?? FileManager().displayName(atPath: path)
  }

  enum CodingKeys: String, CodingKey {
    case bundleIdentifier
    case bundleName
    case path
  }

  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)

    self.bundleIdentifier = try container.decode(String.self, forKey: .bundleIdentifier)
    self.bundleName = try container.decode(String.self, forKey: .bundleName)
    self.path = try container.decode(String.self, forKey: .path)
    self.displayName = FileManager().displayName(atPath: path)
  }

  public static func ==(lhs: Application, rhs: Application) -> Bool {
    lhs.bundleIdentifier == rhs.bundleIdentifier &&
    lhs.bundleName == rhs.bundleName &&
    lhs.path == rhs.path
  }
}
