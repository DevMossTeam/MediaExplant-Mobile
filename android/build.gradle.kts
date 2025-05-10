buildscript {
    repositories {
        google()  // This repository is needed for Firebase services
        mavenCentral()  // Ensure you have this repository too
    }
    dependencies {
        // Google Services classpath for Firebase
        classpath("com.google.gms:google-services:4.4.2")  // Make sure the version is up to date
    }
}

allprojects {
    repositories {
        google()
        mavenCentral()
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

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
