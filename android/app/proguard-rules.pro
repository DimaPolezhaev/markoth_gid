# Flutter engine — оставить как есть
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }

# === ВАЖНО: Не используем Deferred Components → просто игнорируем отсутствующие классы ===
-dontwarn com.google.android.play.core.splitcompat.**
-dontwarn com.google.android.play.core.splitinstall.**
-dontwarn com.google.android.play.core.tasks.**

# TensorFlow Lite GPU — если не используете TFLite с GPU
-dontwarn org.tensorflow.lite.gpu.**

# Остальные правила (можно оставить)
-keep class androidx.lifecycle.DefaultLifecycleObserver

-keep class * extends java.util.ListResourceBundle {
    protected Object[][] getContents();
}

-keep public class * extends android.app.Activity
-keep public class * extends android.app.Application
-keep public class * extends android.app.Service
-keep public class * extends android.content.BroadcastReceiver
-keep public class * extends android.content.ContentProvider
-keep public class * extends android.app.backup.BackupAgentHelper
-keep public class * extends android.preference.Preference

-keepclasseswithmembernames class * {
    native <methods>;
}

-keep @androidx.annotation.Keep class *
-keepclassmembers class * {
    @androidx.annotation.Keep *;
}

-keepclasseswithmembers class * {
    public <init>(org.json.JSONObject);
}

-keepclassmembers class * {
    void set*(***);
    *** get*();
}

-keep class * implements com.google.android.gms.common.internal.ReflectedParcelable {
    *;
}