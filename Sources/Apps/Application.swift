import Cocoa

public struct Application: Identifiable, Codable, Hashable {
  public struct Metadata: Hashable {
    public var isAgent: Bool = false
    public var isElectron: Bool = false
  }

  public let id: String
  public let bundleIdentifier: String
  public let bundleName: String
  public let path: String
  public var metadata: Metadata = Metadata()
  public private(set) var displayName: String = ""

  public init(id: String = UUID().uuidString,
              bundleIdentifier: String,
              bundleName: String,
              displayName: String? = nil,
              path: String) {
    self.id = id
    self.bundleIdentifier = bundleIdentifier
    self.bundleName = bundleName
    self.path = path
    self.displayName = displayName ?? FileManager().displayName(atPath: path)
  }

  enum CodingKeys: String, CodingKey {
    case id
    case bundleIdentifier
    case bundleName
    case path
  }

  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)

    self.id = try container.decodeIfPresent(String.self, forKey: .id) ?? UUID().uuidString
    self.bundleIdentifier = try container.decode(String.self, forKey: .bundleIdentifier)
    self.bundleName = try container.decode(String.self, forKey: .bundleName)
    self.path = try container.decode(String.self, forKey: .path)
    self.displayName = FileManager().displayName(atPath: path)
  }
}
