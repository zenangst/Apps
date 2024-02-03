import Cocoa
import Combine

public class ApplicationController {
  static public func commonPaths() -> [URL] {
    var urls = [URL]()
    if let userDirectory = try? FileManager.default.url(for: .applicationDirectory,
                                                        in: .userDomainMask,
                                                        appropriateFor: nil,
                                                        create: false) {
      urls.append(userDirectory)
    }
    if let applicationDirectory = try? FileManager.default.url(for: .allApplicationsDirectory,
                                                               in: .localDomainMask,
                                                               appropriateFor: nil,
                                                               create: false) {
      urls.append(applicationDirectory)
    }

    if let coreServices = try? FileManager.default.url(for: .coreServiceDirectory,
                                                       in: .systemDomainMask,
                                                       appropriateFor: nil,
                                                       create: false) {
      urls.append(coreServices)
    }

    let applicationDirectoryD = URL(fileURLWithPath: "/Developer/Applications")
    let applicationDirectoryN = URL(fileURLWithPath: "/Network/Applications")
    let applicationDirectoryND = URL(fileURLWithPath: "/Network/Developer/Applications")
    let applicationDirectoryS = URL(fileURLWithPath: "/Users/Shared/Applications")
    let systemApplicationsDirectory = URL(fileURLWithPath: "/System/Applications")
    let preboot = URL(fileURLWithPath: "/System/Volumes/Preboot/Cryptexes/App/System/Applications")

    urls.append(contentsOf: [applicationDirectoryD, applicationDirectoryN,
                             applicationDirectoryND, applicationDirectoryS,
                             systemApplicationsDirectory, preboot])

    return urls
  }

  static public func load(_ additionalPaths: [URL] = []) async -> [Application] {
    FileIndexController(urls: commonPaths() + additionalPaths)
      .index(match: match(_:),
             handler: ApplicationParser().process(_:),
             postHandler: postHandler(_:))
  }

  static public func asyncLoadApplications(_ additionalPaths: [URL] = []) -> AnyPublisher<[Application], Never> {
    FileIndexController(urls: commonPaths() + additionalPaths)
      .asyncIndex(match: match(_:),
                  handler: ApplicationParser().process(_:),
                  postHandler: postHandler(_:))

  }

  static public func loadApplications(_ additionalPaths: [URL] = []) -> [Application] {
    FileIndexController(urls: commonPaths() + additionalPaths)
      .index(match: match(_:),
             handler: ApplicationParser().process(_:),
             postHandler: postHandler(_:))
  }

  private static func match(_ url: URL) -> Bool {
    url.absoluteString.hasSuffix(".app/")
  }

  private static func postHandler(_ applications: [Application]) -> [Application] {
    applications.sorted(by: { $0.bundleName.lowercased() < $1.bundleName.lowercased() })
  }
}
