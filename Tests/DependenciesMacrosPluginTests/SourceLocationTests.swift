import DependenciesMacrosPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacroExpansion
import SwiftSyntaxMacros
import XCTest

final class SourceLocationTests: XCTestCase {
  func testDependencyClient_FilePathWithBackslashes() {
    let expansion = self.expand(
      """
      @DependencyClient
      struct Client {
        var endpoint: () -> Void
      }
      """,
      macros: ["DependencyClient": DependencyClientMacro.self]
    )
    XCTAssertTrue(
      expansion.contains(#"#sourceLocation(file: "C:/Sources/Client.swift", line: 1)"#),
      expansion
    )
  }

  func testDependencyEntry_FilePathWithBackslashes() {
    let expansion = self.expand(
      """
      extension DependencyValues {
        @DependencyEntry
        var client = Client()
      }
      """,
      macros: ["DependencyEntry": DependencyEntryMacro.self]
    )
    XCTAssertTrue(
      expansion.contains(#"#sourceLocation(file: "C:/Sources/Client.swift", line: 2)"#),
      expansion
    )
    XCTAssertFalse(expansion.contains(##"#sourceLocation(file: #""##), expansion)
  }

  private func expand(_ source: SourceFileSyntax, macros: [String: Macro.Type]) -> String {
    let context = BasicMacroExpansionContext(
      sourceFiles: [
        source: .init(moduleName: "TestModule", fullFilePath: #"C:\Sources\Client.swift"#)
      ]
    )
    return source.expand(
      macros: macros,
      contextGenerator: { syntax in
        BasicMacroExpansionContext(
          sharingWith: context,
          lexicalContext: syntax.allMacroLexicalContexts()
        )
      }
    )
    .description
  }
}
