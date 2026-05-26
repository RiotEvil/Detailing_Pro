# ProGuard rules for Detailing Pro
# Preserve Firebase rules
-keepattributes Signature
-keepattributes *Annotation*

# Firebase
-keep class com.google.firebase.** { *; }
-keep class com.google.android.gms.** { *; }
-dontwarn com.google.firebase.**
-dontwarn com.google.android.gms.**

# Hive
-keep class com.detailing.business.app.** { *; }
-keep class * extends com.google.protobuf.GeneratedMessageLite { *; }

# Google Sign-In
-keep class com.google.android.gms.auth.api.signin.** { *; }
-keep interface com.google.android.gms.auth.api.signin.** { *; }

# Keep model classes (for Hive/serialization)
-keep class com.detailing.business.app.models.** { *; }

# Keep enums (important for Dart enums used in Hive)
-keepclassmembers enum * {
  public static **[] values();
  public static ** valueOf(java.lang.String);
}

# Keep Enum values() method for Dart interop
-keepclassmembers class * {
  static *** values();
}

# Preserve line numbers for crash reporting
-keepattributes SourceFile,LineNumberTable
-renamesourcefileattribute SourceFile
