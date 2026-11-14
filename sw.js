const C='myshelf-v9',A=['./','index.html','manifest.webmanifest','icon-180.png','icon-512.png'];
self.addEventListener('install',e=>{e.waitUntil(caches.open(C).then(c=>c.addAll(A)));self.skipWaiting()});
self.addEventListener('activate',e=>e.waitUntil(caches.keys().then(k=>Promise.all(k.filter(x=>x!==C).map(x=>caches.delete(x)))).then(()=>clients.claim())));
self.addEventListener('fetch',e=>{const u=new URL(e.request.url);if(u.pathname.endsWith('config.js'))return;if(e.request.method!=='GET'||(u.origin!==location.origin&&!/covers\.openlibrary|jsdelivr/.test(u.hostname)))return;e.respondWith(caches.match(e.request).then(r=>{const n=fetch(e.request).then(res=>{if(res.ok||res.type=='opaque')caches.open(C).then(c=>c.put(e.request,res.clone()));return res}).catch(()=>r);return r||n}))});
