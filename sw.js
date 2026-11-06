const C='myshelf-v1',SHELL=['./','index.html','manifest.webmanifest','icon-180.png','icon-192.png','icon-512.png'];
self.addEventListener('install',e=>{e.waitUntil(caches.open(C).then(c=>c.addAll(SHELL)).then(()=>self.skipWaiting()))});
self.addEventListener('activate',e=>{e.waitUntil(caches.keys().then(k=>Promise.all(k.filter(x=>x!==C).map(x=>caches.delete(x)))).then(()=>self.clients.claim()))});
self.addEventListener('fetch',e=>{
  const u=new URL(e.request.url);
  if(e.request.method!=='GET')return;
  if(u.origin===location.origin||u.hostname==='covers.openlibrary.org'){
    e.respondWith(caches.match(e.request).then(hit=>{
      const net=fetch(e.request).then(r=>{if(r&&(r.ok||r.type==='opaque'))caches.open(C).then(c=>c.put(e.request,r.clone()));return r}).catch(()=>hit);
      return hit||net}))}
});
