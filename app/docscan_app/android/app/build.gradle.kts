import java.util.Properties
import java.io.FileInputStream

plugins {
    id("com.android.application")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

// =============================================
// KEYSTORE CONFIG (für Play Store Release)
// =============================================
// Lädt Credentials aus android/key.properties (NICHT in Git!)
val keystoreProperties = Properties().apply {
    val f = rootProject.file("key.properties")
    if (f.exists()) {
        load(FileInputStream(f))
    }
}

android {
    namespace = "com.mualimx.docscan"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    defaultConfig {
        applicationId = "com.mualimx.docscan"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    // Sign-Configs nur definieren, wenn key.properties existiert
    signingConfigs {
        // Upload-Key für Play Store (aus key.properties)
        if (keystoreProperties["storeFile"] != null) {
            create("upload") {
                keyAlias = keystoreProperties["keyAlias"] as String
                keyPassword = keystoreProperties["keyPassword"] as String
                storeFile = file(keystoreProperties["storeFile"] as String)
                storePassword = keystoreProperties["storePassword"] as String
            }
        }
    }

    buildTypes {
        release {
            // Default: Debug-Key (für lokales Testen)
            // Nach key.properties-Setup: signingConfig = signingConfigs.getByName("upload")
            signingConfig = if (keystoreProperties["storeFile"] != null) {
                signingConfigs.getByName("upload")
            } else {
                signingConfigs.getByName("debug")
            }
            isMinifyEnabled = false
            isShrinkResources = false
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
        }
    }
}

kotlin {
    compilerOptions {
        jvmTarget = org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17
    }
}

