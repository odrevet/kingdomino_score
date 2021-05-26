'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';
const RESOURCES = {
  "index.html": "2147414c01f0b65c0f94cdef048df47d",
"/": "2147414c01f0b65c0f94cdef048df47d",
"main.dart.js": "bca4e1b3236f78d35bf29fcd2ba02d9c",
"assets/android/app/src/main/res/mipmap-mdpi/ic_launcher.png": "988c8873d28b4df062b5dfbc290fa6ff",
"assets/AssetManifest.json": "77f4b96fa6ff0df1eb91e56cc3587276",
"assets/assets/lacour/banker.png": "6fd0f06585f9f729ede78b1f1c894f21",
"assets/assets/lacour/captain.png": "62b8d79f1c8c99aa52b5a499c98244e1",
"assets/assets/lacour/queen.png": "8c537ad1e71d8adceff3780ea26e0a50",
"assets/assets/lacour/heavy_archery.png": "7eed659c3d45df1589cda0ba5c0550c8",
"assets/assets/lacour/axe_warrior.png": "6b2aec5805b8607d5298f847b5e6534b",
"assets/assets/lacour/fisherman.png": "ffa5cf85384748b752b4ec3797a9a081",
"assets/assets/lacour/farmer.png": "7fb230794a33706e13c7d81067c1e925",
"assets/assets/lacour/lumberjack.png": "cb1ffd135afb03957d825d7c9d9d6d67",
"assets/assets/lacour/shepherdess.png": "54a813508b9131d6319dd08bbb9585e2",
"assets/assets/lacour/light_archery.png": "4a003a0f8e47700fb22280f7c88f2acf",
"assets/assets/lacour/sword_warrior.png": "260b1ab9e06b4eb81f6b586e8649e3ff",
"assets/assets/lacour/resource.png": "1f53c71573bf22419772a4ecc25f916a",
"assets/assets/lacour/king.png": "dca74aea7980aee489b37d64af41c5cf",
"assets/assets/king_pawn.png": "6b06194c12d42a5e426dcc6410b3346b",
"assets/assets/quests/fourCornersMine.svg": "adea4f012d4c5024871206ca3057f091",
"assets/assets/quests/middleKingdom.svg": "6754c79fb69b696e8a2a99de6b5d20fa",
"assets/assets/quests/localBusinessGrassLand.svg": "48f40021d31ae2addcf7fc104cb160be",
"assets/assets/quests/localBusinessMine.svg": "fe89093346336d957e5edb57cf39c844",
"assets/assets/quests/fourCornersWheat.svg": "ed6e8a460766ea1ef26b3150a00178e2",
"assets/assets/quests/folieDesGrandeurs.svg": "b8cc6e1d925d641c91860d9fc35e103f",
"assets/assets/quests/fourCornersGrassLand.svg": "5e260800fc8edb0a66c72edd78081f91",
"assets/assets/quests/localBusinessForest.svg": "988ac6e998fcf8eaa1aaf0e20e5b25a9",
"assets/assets/quests/lostCorner.svg": "e4e23983168ef75996c03eaf1312818b",
"assets/assets/quests/fourCornersLake.svg": "db3fbedb0edbd368079c75be99e2621d",
"assets/assets/quests/localBusinessLake.svg": "de5cee52cddf1b6e34a0e04938e8a73c",
"assets/assets/quests/harmony.svg": "771c0c3c0a16a9fb33138121d7acc9b6",
"assets/assets/quests/fourCornersForest.svg": "a0b0b0a1bd8f4f41b2ca69eed0c0d025",
"assets/assets/quests/localBusinessSwamp.svg": "5fe3a37c0d9fd122353969bb238882f0",
"assets/assets/quests/localBusinessWheat.svg": "f7aae73a69685e2102df15bdc855563e",
"assets/assets/quests/bleakKing.svg": "fe88dd2ef329d182381ae3c9f7b433b1",
"assets/assets/quests/fourCornersSwamp.svg": "7787bcb99605caeb4c491c50a7f43a4f",
"assets/FontManifest.json": "c3f7796b7097ccae3f8ab881706c780e",
"assets/fonts/HammersmithOne-Regular.ttf": "0e7c18c4a81ec6d5487f4026380a9f62",
"assets/fonts/MaterialIcons-Regular.otf": "4e6447691c9509f7acdbf8a931a85ca1",
"assets/NOTICES": "284de8135352d45cf5272c1af621e0a8",
"version.json": "1313d3c65e6f6005619c3f3cfe546046"
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
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
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
