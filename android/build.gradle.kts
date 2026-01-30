buildscript {
    val kotlinVersion = "2.1.0"
    repositories {
        google()
        mavenCentral()
    }

    dependencies {
        classpath("com.android.tools.build:gradle:8.9.1")
        classpath("org.jetbrains.kotlin:kotlin-gradle-plugin:$kotlinVersion")
    }
}

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

// Простая настройка путей - как в оригинальном Groovy файле
val rootBuildDir = file("../build")
rootProject.extensions.extraProperties.set("buildDir", rootBuildDir)
rootProject.layout.buildDirectory.set(rootBuildDir)

subprojects {
    val subprojectBuildDir = File("${rootBuildDir.absolutePath}/${project.name}")
    project.layout.buildDirectory.set(subprojectBuildDir)
}

subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}