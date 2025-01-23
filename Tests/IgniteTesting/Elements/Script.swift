//
// Script.swift
// Ignite
// https://www.github.com/twostraws/Ignite
// See LICENSE for license information.
//

import Testing

@testable import Ignite

// swiftlint:disable force_try
/// Tests for the `Script` element.
@Suite("Script Tests")
@MainActor struct ScriptTests {
    static let sites: [any Site] = [TestSite(), TestSubsite()]

    @Test("Code Test", arguments: await[any Site](Self.sites))
    func code(for site: any Site) async throws {
        try! PublishingContext.initialize(for: site, from: #filePath)

        let element = Script(code: "javascript code")
        let output = element.render()

        #expect(output == "<script>javascript code</script>")
    }

    @Test("File Test", arguments: ["/code.js"], await[any Site](Self.sites))
    func file(scriptFile: String, site: any Site) async throws {
        try! PublishingContext.initialize(for: site, from: #filePath)

        let element = Script(file: scriptFile)
        let output = element.render()

        let expectedPath = site.url.pathComponents.count <= 1 ? scriptFile : "\(site.url.path)\(scriptFile)"
        #expect(output == "<script src=\"\(expectedPath)\"></script>")
    }

    @Test("Attributes Test", arguments: ["/code.js"], await[any Site](Self.sites))
    func attributes(scriptFile: String, site: any Site) async throws {
        try! PublishingContext.initialize(for: site, from: #filePath)

        let element = Script(file: scriptFile)
            .data("key", "value")
            .customAttribute(name: "custom", value: "part")
        let output = element.render()
        let normalizedOutput = ElementTest.normalizeHTML(output)

        let expectedPath = site.url.pathComponents.count <= 1 ? scriptFile : "\(site.url.path)\(scriptFile)"
        #expect(normalizedOutput == "<script custom=\"part\" key=\"value\" src=\"\(expectedPath)\"></script>")
    }
}
// swiftlint:enable force_try
