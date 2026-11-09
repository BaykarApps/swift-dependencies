import Dependencies
import DependenciesMacros

@DependencyClient
struct NumberClient: Sendable {
  var next: @Sendable () -> Int = { 0 }
}

extension NumberClient: DependencyKey {
  static let liveValue = NumberClient(next: { 42 })
}

extension DependencyValues {
  var numberClient: NumberClient {
    get { self[NumberClient.self] }
    set { self[NumberClient.self] = newValue }
  }

  @DependencyEntry(liveValue: "live")
  var greeting = "test"
}

struct Reader {
  @Dependency(\.numberClient) var numberClient
  @Dependency(\.greeting) var greeting

  var summary: String {
    "\(self.numberClient.next()) \(self.greeting)"
  }
}
