import org.jetbrains.kotlin.gradle.dsl.JvmTarget

plugins {
    id("com.android.application")

    // START: FlutterFire Configuration
    id("com.google.gms.google-services")
    // END: FlutterFire Configuration

    id("kotlin-android")

    // Flutter plugin always last
    id("dev.flutter.flutter-gradle-plugin")
}


android {

    namespace = "com.example.cartkaro"

    compileSdk = flutter.compileSdkVersion

    ndkVersion = "28.2.13676358"


    compileOptions {

        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17

        // Required for flutter_local_notifications
        isCoreLibraryDesugaringEnabled = true
    }


    defaultConfig {

        applicationId = "com.example.cartkaro"

        minSdk = flutter.minSdkVersion

        targetSdk = flutter.targetSdkVersion

        versionCode = flutter.versionCode

        versionName = flutter.versionName
    }


    buildTypes {

        release {

            // Debug signing for testing
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}


// Kotlin 2.3+ compiler configuration

kotlin {

    compilerOptions {

        jvmTarget.set(JvmTarget.JVM_17)
    }
}



flutter {

    source = "../.."
}



dependencies {


    // Kotlin
    implementation(kotlin("stdlib-jdk8"))



    // Core library desugaring
    coreLibraryDesugaring(
        "com.android.tools:desugar_jdk_libs:2.1.5"
    )



    // Firebase BoM
    implementation(
        platform("com.google.firebase:firebase-bom:33.1.0")
    )



    // Firebase services
    implementation("com.google.firebase:firebase-analytics")

    implementation("com.google.firebase:firebase-auth")

    implementation("com.google.firebase:firebase-firestore")
}