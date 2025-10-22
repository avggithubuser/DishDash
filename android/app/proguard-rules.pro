# Flutter
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }
-keep class io.flutter.embedding.** { *; }
-keep class io.flutter.plugin.** { *; }

# Firebase
-keep class com.google.firebase.** { *; }
-dontwarn com.google.firebase.**
-keep class com.google.android.gms.** { *; }
-dontwarn com.google.android.gms.**

# Kotlin and coroutines
-keepclassmembers class kotlin.Metadata { *; }
-keep class kotlinx.coroutines.** { *; }
-dontwarn kotlinx.coroutines.**

# Keep annotations and signatures
-keepattributes *Annotation*
-keepattributes Signature

# Glide (if using Glide)
-keep class com.bumptech.glide.GeneratedAppGlideModuleImpl { *; }
-keep public class * implements com.bumptech.glide.module.AppGlideModule

# Keep your app classes
-keep class com.eat.dishdash.** { *; }

# (Optional) Play Core Splitcompat and Splitinstall
-dontwarn com.google.android.play.core.splitcompat.SplitCompatApplication
-dontwarn com.google.android.play.core.splitinstall.**
-keep class com.google.android.play.core.splitinstall.** { *; }
-keep interface com.google.android.play.core.splitinstall.** { *; }
-keep class com.google.android.play.core.splitcompat.** { *; }
-keep class com.google.android.play.core.tasks.** { *; }
