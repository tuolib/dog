package com.u4ursafety.dog;

import io.flutter.app.FlutterApplication;
import io.flutter.plugin.common.PluginRegistry;
import io.flutter.plugin.common.PluginRegistry.PluginRegistrantCallback;
import io.flutter.plugins.firebasemessaging.FirebaseMessagingPlugin;
import io.flutter.plugins.firebasemessaging.FlutterFirebaseMessagingService;
import com.github.cloudwebrtc.flutter_callkeep.FlutterCallkeepPlugin;
import io.flutter.plugins.sharedpreferences.SharedPreferencesPlugin;
//import co.doneservices.callkeep.CallKeepPlugin;
import io.flutter.plugins.pathprovider.PathProviderPlugin;

import com.tekartik.sqflite.Constant;
import com.tekartik.sqflite.SqflitePlugin;


public class Application extends FlutterApplication implements PluginRegistrantCallback {
    @Override
    public void onCreate() {
        super.onCreate();
        FlutterFirebaseMessagingService.setPluginRegistrant(this);
    }

    @Override
    public void registerWith(PluginRegistry registry) {
//        GeneratedPluginRegistrant.registerWith(registry);
        FirebaseMessagingPlugin.registerWith(registry.registrarFor("io.flutter.plugins.firebasemessaging.FirebaseMessagingPlugin"));
        FlutterCallkeepPlugin.registerWith(registry.registrarFor("com.github.cloudwebrtc.flutter_callkeep.FlutterCallKeepPlugin"));
        SharedPreferencesPlugin.registerWith(registry.registrarFor("io.flutter.plugins.sharedpreferences.SharedPreferencesPlugin"));
//        CallKeepPlugin.registerWith(registry.registrarFor("co.doneservices.callkeep.CallKeepPlugin"));
        PathProviderPlugin.registerWith(registry.registrarFor("io.flutter.plugins.pathprovider.PathProviderPlugin"));
        SqflitePlugin.registerWith(registry.registrarFor(Constant.PLUGIN_KEY));
//        E2EPlugin.registerWith(registry.registrarFor("dev.flutter.plugins.e2e.E2EPlugin"));
    }
}