pluginManagement {
    repositories {
        google {
            content {
                includeGroupByRegex("com\\.android.*")
                includeGroupByRegex("com\\.google.*")
                includeGroupByRegex("androidx.*")
            }
        }
        mavenCentral()
        gradlePluginPortal()
    }
}

dependencyResolutionManagement {
    repositoriesMode.set(RepositoriesMode.PREFER_SETTINGS)
    repositories {
        google()
        mavenCentral()

        val storageUrl = System.getenv("FLUTTER_STORAGE_BASE_URL") ?: "https://storage.googleapis.com"
        maven {
            url = uri("C:\\extra_projects\\KotlinApp\\flutter_module\\build\\host\\outputs\\repo")
        }
        maven {
            url = uri("$storageUrl/download.flutter.io")
        }
    }
}

rootProject.name = "KotlinApp"
include(":app")

val flutterProjectRoot = rootDir.resolve("flutter_module")
val includeFlutter = File(flutterProjectRoot, ".android/include_flutter.groovy")

if (includeFlutter.exists()) {
    apply(from = includeFlutter)
}