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

# Play Core (app update, asset packs, split install)
-dontwarn com.google.android.play.core.**
-keep class com.google.android.play.core.** { *; }
-keep interface com.google.android.play.core.** { *; }
-keep class com.google.android.play.core.common.** { *; }
-keep class com.google.android.play.core.listener.** { *; }
-keep class com.google.android.play.core.tasks.** { *; }
-keep class com.google.android.play.core.appupdate.** { *; }
-keep class com.google.android.play.core.assetpacks.** { *; }
-keep class com.google.android.play.core.install.** { *; }

