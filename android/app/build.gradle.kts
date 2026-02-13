plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.uide_campus_cleaner"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    // 🔧 FIX para crash de Google Maps (org.apache.http.ProtocolVersion)
    useLibrary("org.apache.http.legacy")

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        applicationId = "com.example.uide_campus_cleaner"
        minSdk = 26
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}

/*
 * 🔧 FIX para conflicto AndroidX vs Support Library
 * (lo mete ar_flutter_plugin internamente)
 */
configurations.all {
    exclude(group = "com.android.support", module = "support-compat")
}

