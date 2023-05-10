document.addEventListener("DOMContentLoaded", function(event) {
  const link = (txt, link, target) => `<a href="${link}" ${target && `target="${target}"`} style="color:#07f">${txt}</a>`;
  const ok = (txt, domain) => `<span style="color:#0b0">${txt}</span><br>${link("Desactiva",`/system/caprover/disable?domain=${domain}`)}</a>`;
  const caprover = (txt, domain) => `<span style="color:#b00">${txt}</span><br>${link("Activa",`/system/caprover/enable?domain=${domain}`)}</a>`;
  const plausible = (txt, domain) => `<span style="color:#b00">${txt}</span><br>${link("Activa",`/system/plausible/enable?domain=${domain}`)}</a>`;

  // fetch domains from caprover api
  fetch("/system/caprover").then(response => {
    return response.json();
  }).then(json => {
    // console.log(json);
    [...document.getElementsByClassName("caprover")].forEach(element => {
      found = json.find((item) => item.publicDomain === element.dataset.host);
      element.innerHTML = found ? found.hasSsl ? ok("Si, amb SSL", element.dataset.host) : caprover("Si, sense SSL", element.dataset.host) : caprover("Inactiu", element.dataset.host);
    });
    [...document.getElementsByClassName("plausible")].forEach(element => {
      found = json.find((item) => item.publicDomain === element.dataset.host && item.plausible);
      console.log(json, element.dataset.host, found)
      element.innerHTML = found ? link("Stats", found.plausible, found.publicDomain) : plausible("No", element.dataset.host);
    });
  });

  // fetch domains from plausible api
  fetch("/system/plausible").then(response => {
    return response.json();
  }).then(json => {
    console.log(json)
  });
});
