import ProjectDescription

extension TargetScript {
    static let swiftLint = TargetScript.post(
        script: swiftLintDescription,
        name: "SwiftLint",
        basedOnDependencyAnalysis: false
    )
}
