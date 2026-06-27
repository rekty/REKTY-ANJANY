{{flutter_js}}
{{flutter_build_config}}

// Service Worker configuration for better caching
_flutter.loader.load({
  serviceWorkerSettings: {
    serviceWorkerVersion: {{flutter_service_worker_version}},
  },
  onEntrypointLoaded: async function(engineInitializer) {
    const appRunner = await engineInitializer.initializeEngine({
      // Performance optimizations
      canvasKitBaseUrl: "https://unpkg.com/canvaskit-wasm@latest/bin/",
      renderer: "canvaskit",
      // Enable multi-threading for better performance
      useWasm: true,
    });
    
    // Run the app
    await appRunner.runApp();
    
    // Notify that Flutter is ready
    window.dispatchEvent(new Event('flutter-first-frame'));
  }
});
