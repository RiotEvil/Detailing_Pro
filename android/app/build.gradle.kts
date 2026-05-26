import java.util.Properties
import org.gradle.api.GradleException

plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
    id("com.google.gms.google-services")
}

val keyPropertiesFile = rootProject.file("key.properties")
val keyProperties = Properties()
if (keyPropertiesFile.exists()) {
    keyProperties.load(keyPropertiesFile.inputStream())
}

fun readSigningProperty(name: String): String? {
    val envName = "ANDROID_SIGNING_${name.uppercase()}"
    val fromEnv = System.getenv(envName)?.trim()
    if (!fromEnv.isNullOrEmpty()) {
        return fromEnv
    }
    val fromFile = keyProperties.getProperty(name)?.trim()
    return if (fromFile.isNullOrEmpty()) null else fromFile
}

val releaseKeyAlias = readSigningProperty("keyAlias")
val releaseKeyPassword = readSigningProperty("keyPassword")
val releaseStoreFile = readSigningProperty("storeFile")
val releaseStorePassword = readSigningProperty("storePassword")
val hasReleaseSigning =
    !releaseKeyAlias.isNullOrEmpty() &&
    !releaseKeyPassword.isNullOrEmpty() &&
    !releaseStoreFile.isNullOrEmpty() &&
    !releaseStorePassword.isNullOrEmpty()

android {
    namespace = "com.detailing.business.app"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
        isCoreLibraryDesugaringEnabled = true
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.detailing.business.app"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    signingConfigs {
        create("release") {
            if (hasReleaseSigning) {
                keyAlias = releaseKeyAlias
                keyPassword = releaseKeyPassword
                storeFile = file(releaseStoreFile!!)
                storePassword = releaseStorePassword
            }
        }
    }

    buildTypes {
        release {
            if (hasReleaseSigning) {
                signingConfig = signingConfigs.getByName("release")
            } else {
                val isReleaseTask = gradle.startParameter.taskNames.any {
                    it.contains("Release", ignoreCase = true)
                }
                if (isReleaseTask) {
                    throw GradleException(
                        "Release signing is not configured. " +
                            "Set ANDROID_SIGNING_KEYALIAS, ANDROID_SIGNING_KEYPASSWORD, " +
                            "ANDROID_SIGNING_STOREFILE, ANDROID_SIGNING_STOREPASSWORD " +
                            "or provide android/key.properties."
                    )
                }
                logger.warn("Release signing is not configured; non-release tasks can continue.")
            }
            // Enable minification (ProGuard/R8) for production builds
            isMinifyEnabled = true
            // Shrink unused resources to reduce APK/AAB size
            isShrinkResources = true
            
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.5")
}
