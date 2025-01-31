import ProjectDescription

let workspace = Workspace(
    name: "ModuleBFramework",
    projects: [
        "**",
    ],
    additionalFiles: [
        .glob(pattern: "AllTests.xctestplan"),
    ],
    generationOptions: .options(
        enableAutomaticXcodeSchemes: false,
        autogeneratedWorkspaceSchemes: .disabled
    )
)
