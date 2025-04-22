# Razorpay rules
-keep class com.razorpay.** { *; }
-dontwarn com.razorpay.**
-keep class proguard.annotation.** { *; }
-keepattributes *Annotation*
-dontwarn proguard.annotation.Keep
-dontwarn proguard.annotation.KeepClassMembers