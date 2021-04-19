'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';
const RESOURCES = {
  "version.json": "2af1dbc3e14df2b2c1c4e936afebeee3",
"assets/NOTICES": "557bab2dbce830ab159a0d27873d6413",
"assets/FontManifest.json": "68c55034c276473d3afe44812d11adc9",
"assets/fonts/MaterialIcons-Regular.otf": "1288c9e28052e028aba623321f7826ac",
"assets/fonts/HammersmithOne-Regular.ttf": "0e7c18c4a81ec6d5487f4026380a9f62",
"assets/fonts/Augusta.ttf": "385b2e844755c43a7bf26dbc7de55fd2",
"assets/assets/middleKingdom.svg": "6754c79fb69b696e8a2a99de6b5d20fa",
"assets/assets/localBusinessForest.svg": "988ac6e998fcf8eaa1aaf0e20e5b25a9",
"assets/assets/localBusinessSwamp.svg": "5fe3a37c0d9fd122353969bb238882f0",
"assets/assets/localBusinessLake.svg": "de5cee52cddf1b6e34a0e04938e8a73c",
"assets/assets/localBusinessWheat.svg": "f7aae73a69685e2102df15bdc855563e",
"assets/assets/fourCornersLake.svg": "db3fbedb0edbd368079c75be99e2621d",
"assets/assets/folieDesGrandeurs.svg": "b8cc6e1d925d641c91860d9fc35e103f",
"assets/assets/fourCornersMine.svg": "adea4f012d4c5024871206ca3057f091",
"assets/assets/localBusinessMine.svg": "fe89093346336d957e5edb57cf39c844",
"assets/assets/harmony.svg": "771c0c3c0a16a9fb33138121d7acc9b6",
"assets/assets/fourCornersSwamp.svg": "7787bcb99605caeb4c491c50a7f43a4f",
"assets/assets/localBusinessGrassLand.svg": "48f40021d31ae2addcf7fc104cb160be",
"assets/assets/bleakKing.svg": "fe88dd2ef329d182381ae3c9f7b433b1",
"assets/assets/fourCornersGrassLand.svg": "5e260800fc8edb0a66c72edd78081f91",
"assets/assets/fourCornersForest.svg": "a0b0b0a1bd8f4f41b2ca69eed0c0d025",
"assets/assets/fourCornersWheat.svg": "ed6e8a460766ea1ef26b3150a00178e2",
"assets/assets/lostCorner.svg": "e4e23983168ef75996c03eaf1312818b",
"assets/android/app/src/main/res/mipmap-mdpi/ic_launcher.png": "988c8873d28b4df062b5dfbc290fa6ff",
"assets/AssetManifest.json": "94479de6dae3f68c12076af092d098f4",
"main.dart.js": "5e84727d0c4ea20cfbf7a0776e82bb85",
"index.html": "2147414c01f0b65c0f94cdef048df47d",
"/": "2147414c01f0b65c0f94cdef048df47d"
};

// The application shell files that are downloaded before a service worker can
// start.
const CORE = [
  "/",
"main.dart.js",
"index.html",
"assets/NOTICES",
"assets/AssetManifest.json",
"assets/FontManifest.json"];
// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value + '?revision=' + RESOURCES[value], {'cache': 'reload'})));
    })
  );
});

// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});

// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache.
        return response || fetch(event.request).then((response) => {
          cache.put(event.request, response.clone());
          return response;
        });
      })
    })
  );
});

self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});

// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}

// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
