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

# flutter_local_notifications - Gson TypeToken fix
# R8 removes generic type signatures needed by Gson's TypeToken
-keep class com.google.gson.** { *; }
-keep class com.google.gson.reflect.TypeToken { *; }
-keep class * extends com.google.gson.reflect.TypeToken { *; }
-keepattributes EnclosingMethod
-keepattributes InnerClasses

# Keep flutter_local_notifications scheduled notification model classes
-keep class com.dexterous.flutterlocalnotifications.** { *; }
-keepclassmembers class com.dexterous.flutterlocalnotifications.** { *; }
