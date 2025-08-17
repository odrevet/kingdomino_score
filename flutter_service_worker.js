'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"main.dart.js": "8b23c8f7808eb3bfc8482d8362810203",
"flutter_bootstrap.js": "986aa989d90adda7cdbf08efbcca7c0f",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"flutter.js": "888483df48293866f9f41d3d9274a779",
"index.html": "99104d9a8ab882c2c8f9f137ee9d9ca9",
"/": "99104d9a8ab882c2c8f9f137ee9d9ca9",
"version.json": "d14d30a37dc2b1bcfdd8ce7273f98c7e",
"manifest.json": "97f4f7d8d498c709061ce757b7503223",
"assets/AssetManifest.json": "77f4b96fa6ff0df1eb91e56cc3587276",
"assets/NOTICES": "f66b1768626aa1a0cb9f19ee8e8690a4",
"assets/android/app/src/main/res/mipmap-mdpi/ic_launcher.png": "988c8873d28b4df062b5dfbc290fa6ff",
"assets/AssetManifest.bin.json": "ab953eafdd90dad6f8e9aa0d7b04e303",
"assets/fonts/HammersmithOne-Regular.ttf": "0e7c18c4a81ec6d5487f4026380a9f62",
"assets/fonts/MaterialIcons-Regular.otf": "dd94f88e8ce0ed77af595d384555f54f",
"assets/AssetManifest.bin": "4e57817179e10539a22b7e5b45676221",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/assets/quests/fourCornersForest.svg": "a0b0b0a1bd8f4f41b2ca69eed0c0d025",
"assets/assets/quests/localBusinessSwamp.svg": "5fe3a37c0d9fd122353969bb238882f0",
"assets/assets/quests/middleKingdom.svg": "6754c79fb69b696e8a2a99de6b5d20fa",
"assets/assets/quests/fourCornersLake.svg": "db3fbedb0edbd368079c75be99e2621d",
"assets/assets/quests/localBusinessForest.svg": "988ac6e998fcf8eaa1aaf0e20e5b25a9",
"assets/assets/quests/lostCorner.svg": "e4e23983168ef75996c03eaf1312818b",
"assets/assets/quests/harmony.svg": "771c0c3c0a16a9fb33138121d7acc9b6",
"assets/assets/quests/folieDesGrandeurs.svg": "b8cc6e1d925d641c91860d9fc35e103f",
"assets/assets/quests/fourCornersSwamp.svg": "7787bcb99605caeb4c491c50a7f43a4f",
"assets/assets/quests/localBusinessLake.svg": "de5cee52cddf1b6e34a0e04938e8a73c",
"assets/assets/quests/fourCornersGrassLand.svg": "5e260800fc8edb0a66c72edd78081f91",
"assets/assets/quests/fourCornersWheat.svg": "ed6e8a460766ea1ef26b3150a00178e2",
"assets/assets/quests/localBusinessMine.svg": "fe89093346336d957e5edb57cf39c844",
"assets/assets/quests/localBusinessWheat.svg": "f7aae73a69685e2102df15bdc855563e",
"assets/assets/quests/bleakKing.svg": "fe88dd2ef329d182381ae3c9f7b433b1",
"assets/assets/quests/localBusinessGrassLand.svg": "48f40021d31ae2addcf7fc104cb160be",
"assets/assets/quests/fourCornersMine.svg": "adea4f012d4c5024871206ca3057f091",
"assets/assets/king_pawn.png": "6b06194c12d42a5e426dcc6410b3346b",
"assets/assets/lacour/fisherman.png": "ffa5cf85384748b752b4ec3797a9a081",
"assets/assets/lacour/resource.png": "1f53c71573bf22419772a4ecc25f916a",
"assets/assets/lacour/shepherdess.png": "54a813508b9131d6319dd08bbb9585e2",
"assets/assets/lacour/captain.png": "62b8d79f1c8c99aa52b5a499c98244e1",
"assets/assets/lacour/light_archery.png": "4a003a0f8e47700fb22280f7c88f2acf",
"assets/assets/lacour/sword_warrior.png": "260b1ab9e06b4eb81f6b586e8649e3ff",
"assets/assets/lacour/farmer.png": "7fb230794a33706e13c7d81067c1e925",
"assets/assets/lacour/king.png": "dca74aea7980aee489b37d64af41c5cf",
"assets/assets/lacour/heavy_archery.png": "7eed659c3d45df1589cda0ba5c0550c8",
"assets/assets/lacour/axe_warrior.png": "6b2aec5805b8607d5298f847b5e6534b",
"assets/assets/lacour/lumberjack.png": "cb1ffd135afb03957d825d7c9d9d6d67",
"assets/assets/lacour/banker.png": "6fd0f06585f9f729ede78b1f1c894f21",
"assets/assets/lacour/queen.png": "8c537ad1e71d8adceff3780ea26e0a50",
"assets/FontManifest.json": "c3f7796b7097ccae3f8ab881706c780e",
"canvaskit/skwasm.js": "1ef3ea3a0fec4569e5d531da25f34095",
"canvaskit/skwasm_heavy.wasm": "8034ad26ba2485dab2fd49bdd786837b",
"canvaskit/skwasm.wasm": "264db41426307cfc7fa44b95a7772109",
"canvaskit/skwasm_heavy.js.symbols": "3c01ec03b5de6d62c34e17014d1decd3",
"canvaskit/canvaskit.js.symbols": "58832fbed59e00d2190aa295c4d70360",
"canvaskit/skwasm.js.symbols": "0088242d10d7e7d6d2649d1fe1bda7c1",
"canvaskit/chromium/canvaskit.js.symbols": "193deaca1a1424049326d4a91ad1d88d",
"canvaskit/chromium/canvaskit.js": "5e27aae346eee469027c80af0751d53d",
"canvaskit/chromium/canvaskit.wasm": "24c77e750a7fa6d474198905249ff506",
"canvaskit/canvaskit.js": "140ccb7d34d0a55065fbd422b843add6",
"canvaskit/skwasm_heavy.js": "413f5b2b2d9345f37de148e2544f584f",
"canvaskit/canvaskit.wasm": "07b9f5853202304d3b0749d9306573cc"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"flutter_bootstrap.js",
"assets/AssetManifest.bin.json",
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
        // Claim client to enable caching on first launch
        self.clients.claim();
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
      // Claim client to enable caching on first launch
      self.clients.claim();
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
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
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
