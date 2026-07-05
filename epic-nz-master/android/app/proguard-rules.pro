# Stripe specific rules
-keep class com.stripe.** { *; }
-dontwarn com.stripe.**


-keep class com.reactnativestripesdk.** { *; }
-dontwarn com.reactnativestripesdk.**

# Essential for R8/ProGuard
-keepattributes *Annotation*
-keepattributes Signature
-keepattributes InnerClasses
-keep class kotlin.Metadata { *; }

-dontwarn androidx.compose.runtime.**
-dontwarn com.google.android.gms.internal.**