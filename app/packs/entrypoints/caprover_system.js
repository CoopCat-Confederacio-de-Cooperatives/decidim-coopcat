document.addEventListener("DOMContentLoaded", function(event) {
  const ok = (txt, domain) => `<span style="color:#0b0">${txt}</span><br><a href="/system/caprover/disable?domain=${domain}" style="color:#07f">Desactiva</a>`;
  const ko = (txt, domain) => `<span style="color:#b00">${txt}</span><br><a href="/system/caprover/enable?domain=${domain}" style="color:#07f">Activa</a>`;

  // fetch domains from caprover api
  fetch("/system/caprover").then(response => {
    return response.json();
  }).then(json => {
    // console.log(json);
    [...document.getElementsByClassName("caprover")].forEach(element => {
      found = json.find((item) => item.publicDomain === element.dataset.host);
      element.innerHTML = found ? found.hasSsl ? ok("Si, amb SSL", element.dataset.host) : ko("Si, sense SSL", element.dataset.host) : ko("Inactiu", element.dataset.host);
    });
  });
});
