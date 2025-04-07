buildscript {
    repositories {
        google()  // Ensure Google repositories are included
        mavenCentral()  // You can keep this for additional dependencies
    }
    dependencies {
        // Android Gradle plugin
        classpath("com.android.tools.build:gradle:8.2.1")  // Make sure to use the correct version

        // Google Services plugin (for Firebase)
        classpath("com.google.gms:google-services:4.4.0")  // This enables Firebase services

        // Kotlin Gradle Plugin (if you're using Kotlin in your project)
        classpath("org.jetbrains.kotlin:kotlin-gradle-plugin:1.9.22")  // Make sure the Kotlin plugin version matches the one you're using
    }
}

allprojects {
    repositories {
        google()  // Include the Google repository
        mavenCentral()  // Include Maven Central repository for additional dependencies
    }
}

val newBuildDir: Directory = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}

subprojects {
    project.evaluationDependsOn(":app")
}

// Clean task to clear build artifacts
tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
