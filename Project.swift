import ProjectDescription
import ProjectDescriptionHelpers

let proje = Project.project(
    with: "ModuleBFramework",
    bundleId: "com.my-company.moduleb",
    disableBundleAccessors: true,
    disableSynthesizedResourceAccessors: true
)
