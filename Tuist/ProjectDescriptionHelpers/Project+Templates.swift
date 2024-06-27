import Foundation
import ProjectDescription

extension Project {

    public static func project(
        with name: String,
        organizationName: String = "MyOrganization",
        bundleId: String,
        deploymentTarget: DeploymentTargets = .iOS("14.0"),
        dependencies: [ProjectDescription.TargetDependency] = [],
        packages: [ProjectDescription.Package] = [],
        disableBundleAccessors: Bool = false,
        disableSynthesizedResourceAccessors: Bool = false
    ) -> Project {
        let testPlanFile = "AllTests.xctestplan"
        let module = Module(name: name, bundleIdPrefix: bundleId)

        // MARK: - Schemes definition
        let mainScheme: Scheme = .scheme(
            name: module.mainTarget.name,
            shared: true,
            buildAction: .buildAction(
                targets: [.target(module.mainTarget.name)]
            ),
            testAction: .testPlans([
                .relativeToManifest(testPlanFile)
            ])
        )

        let appDemoScheme: Scheme = .scheme(
            name: module.appDemoTarget.name,
            shared: true,
            buildAction: .buildAction(
                targets: [.target(module.appDemoTarget.name)]
            )
        )

        // MARK: - Targets definition
        var allTargets = [Target]()

        // MARK: - Main Target
        allTargets.append(
            .target(
                name: module.mainTarget.name,
                destinations: .iOS,
                product: .framework,
                bundleId: module.mainTarget.bundleId,
                deploymentTargets: deploymentTarget,
                infoPlist: module.mainTarget.infoPlist,
                sources: module.mainTarget.sources,
                scripts: [.swiftLint],
                dependencies: dependencies + [.target(name: module.interfaceTarget.name)],
                settings: .settings(
                    base: [
                        "CODE_SIGN_IDENTITY": "",
                        "CODE_SIGNING_REQUIRED": "NO",
                        "ENABLE_TESTABILITY": .string("YES")
                    ]
                )
            )
        )

        // MARK: - Interface Target
        allTargets.append(
            .target(
                name: module.interfaceTarget.name,
                destinations: .iOS,
                product: .framework,
                bundleId: module.interfaceTarget.bundleId,
                deploymentTargets: deploymentTarget,
                infoPlist: module.interfaceTarget.infoPlist,
                sources: module.interfaceTarget.sources,
                scripts: [.swiftLint],
                dependencies: dependencies,
                settings: .settings(
                    base: [
                        "CODE_SIGN_IDENTITY": "",
                        "CODE_SIGNING_REQUIRED": "NO",
                        "ENABLE_TESTABILITY": .string("YES")
                    ]
                )
            )
        )

        // MARK: - App Demo Target
        allTargets.append(
            .target(
                name: module.appDemoTarget.name,
                destinations: .iOS,
                product: .app,
                bundleId: module.appDemoTarget.bundleId,
                deploymentTargets: deploymentTarget,
                infoPlist: module.appDemoTarget.infoPlist,
                sources: module.appDemoTarget.sources,
                resources: module.appDemoTarget.resources,
                dependencies: [
                    .target(name: module.mainTarget.name)
                ],
                settings: .settings(
                    base: [
                        // Used to have CODE_SIGN_STYLE and DEVELOPMENT_TEAM, but removed in order to not have
                        // problems with my company's privacy policies.
                        "ENABLE_BITCODE": .string("NO"),
                        "VERSIONING_SYSTEM": "Apple Generic",
                        "PROVISIONING_PROFILE_SPECIFIER": "match AdHoc \(module.appDemoTarget.bundleId)",
                        "CODE_SIGN_IDENTITY": "Apple Distribution"
                    ]
                )
            )
        )

        // MARK: - Testing Target
        allTargets.append(
            .target(
                name: module.testingTarget.name,
                destinations: .iOS,
                product: .framework,
                bundleId: module.testingTarget.bundleId,
                deploymentTargets: deploymentTarget,
                infoPlist: module.testingTarget.infoPlist,
                sources: module.testingTarget.sources,
                resources: module.testingTarget.resources,
                dependencies: [
                    .target(name: module.interfaceTarget.name)
                ],
                settings: .settings(
                    base: [
                        "CODE_SIGN_IDENTITY": "",
                        "CODE_SIGNING_REQUIRED": "NO",
                        "ENABLE_TESTABILITY": .string("YES")
                    ]
                )
            )
        )

        // MARK: - Tests Target
        allTargets.append(
            .target(
                name: module.testsTarget.name,
                destinations: .iOS,
                product: .unitTests,
                bundleId: module.testsTarget.bundleId,
                deploymentTargets: deploymentTarget,
                infoPlist: module.testsTarget.infoPlist,
                sources: module.testsTarget.sources,
                dependencies: [
                    .target(name: module.mainTarget.name),
                    .target(name: module.testingTarget.name)
                ]
            )
        )

        return Project(
            name: name,
            organizationName: organizationName,
            options: .options(
                automaticSchemesOptions: .enabled(
                    targetSchemesGrouping: .notGrouped,
                    codeCoverageEnabled: false,
                    testingOptions: [],
                    testScreenCaptureFormat: .screenshots
                ),
                disableBundleAccessors: true,
                disableSynthesizedResourceAccessors: true
            ),
            packages: packages,
            targets: allTargets,
            schemes: [mainScheme, appDemoScheme]
        )
    }
}
