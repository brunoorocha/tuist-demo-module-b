import Foundation
import ProjectDescription

struct Module {
    let name: String
    let bundleIdPrefix: String
    private let sourcesRootPath = "Sources/"

    var mainTarget: Target {
        Target(
            name: name,
            sources: sourcesRootPath + "Framework/**",
            infoPlist: sourcesRootPath + "Framework/Configs/Info.plist",
            bundleId: bundleIdPrefix
        )
    }

    var interfaceTarget: Target {
        Target(
            name: name + "Interface",
            sources: sourcesRootPath + "Interface/**",
            infoPlist: sourcesRootPath + "Interface/Configs/Info.plist",
            bundleId: bundleIdPrefix + ".interface"
        )
    }

    var testsTarget: Target {
        Target(
            name: name + "Tests",
            sources: sourcesRootPath + "Tests/**",
            bundleId: bundleIdPrefix + ".tests"
        )
    }

    var testingTarget: Target {
        Target(
            name: name + "Testing",
            sources: sourcesRootPath + "Testing/**",
            bundleId: bundleIdPrefix + ".testing"
        )
    }

    var appDemoTarget: Target {
        Target(
            name: name + "AppDemo",
            sources: sourcesRootPath + "AppDemo/Sources/**",
            resources: sourcesRootPath + "AppDemo/Resources/**",
            infoPlist: sourcesRootPath + "AppDemo/Configs/Info.plist",
            bundleId: bundleIdPrefix + ".app.ios"
        )
    }

    struct Target {
        let name: String
        let sources: SourceFilesList
        let resources: ResourceFileElements?
        let infoPlist: InfoPlist
        let bundleId: String

        init(name: String, sources: String, resources: String? = nil, infoPlist: String? = nil, bundleId: String) {
            self.name = name
            self.sources = SourceFilesList(stringLiteral: sources)
            self.resources = resources == nil ? nil : ResourceFileElements(stringLiteral: resources!)
            self.infoPlist = infoPlist == nil ? .default : InfoPlist(stringLiteral: infoPlist!)
            self.bundleId = bundleId
        }
    }
}
