import Foundation
import Combine
import CoreGraphics
import OSLog

protocol FileIndexControlling: AnyObject {
  func asyncIndex<T>(match: @escaping (URL) -> Bool,
                     handler: @escaping (URL) -> T?,
                     postHandler: @escaping ([T]) -> [T]) -> AnyPublisher<[T], Never>
  func index<T>(match: (URL) -> Bool, handler: (URL) -> T?,
                postHandler: ([T]) -> [T]) -> [T]
}

/// A file index controller iterates of the file-system to produce
/// object that can represent the contents found on disk.
///
/// - Note: All matching is done by calling `.contains` using `String`'s.
///         Patterns do currently not support any form of regular expressions.
///         Adding more patterns increases the overall speed of the algorithm
///         as by default, everything is included.
///
/// The class supports both synchronous and asynchronous indexing.
/// Asynchronousity is achieved using Combine.
///
public final class FileIndexController: FileIndexControlling {
  let urls: [URL]

  public init(urls: [URL]) {
    self.urls = urls
  }

  public func asyncIndex<T>(match: @escaping (URL) -> Bool,
                            handler: @escaping (URL) -> T?,
                            postHandler: @escaping ([T]) -> [T]) -> AnyPublisher<[T], Never> {
    Just(index(match: match, handler: { handler($0) }, postHandler: postHandler)).eraseToAnyPublisher()
  }

  public func index<T>(match: (URL) -> Bool, handler: (URL) -> T?,
                       postHandler: ([T]) -> [T]) -> [T] {
    var items = [T]()

    for url in urls {
      let fileManager = FileManager()
      let enumerator = fileManager.enumerator(at: url,
                                              includingPropertiesForKeys: nil,
                                              options: [.skipsHiddenFiles, .producesRelativePathURLs])!
      while let fileURL = enumerator.nextObject() as? URL {
        let depth = fileURL.relativeString.contains("Xcode") ? 5 : 2
        guard (fileURL.relativeString.components(separatedBy: "/").count - 1) <= depth else {
          enumerator.skipDescendents()
          continue
        }

        if match(fileURL), let object = handler(fileURL.absoluteURL) {
          items.append(object)
        }
      }
    }

    return postHandler(items)
  }
}
