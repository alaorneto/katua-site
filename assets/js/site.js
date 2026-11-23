// Comportamentos do site: tema claro/escuro, menu no celular e o link da seção atual no cabeçalho.
(function () {
  var root = document.documentElement;

  // Tema: guarda a escolha; sem escolha, o site segue o sistema.
  var themeButton = document.querySelector("[data-theme-toggle]");
  if (themeButton) {
    var currentTheme = function () {
      var chosen = root.getAttribute("data-theme");
      if (chosen) return chosen;
      return window.matchMedia("(prefers-color-scheme: dark)").matches ? "dark" : "light";
    };
    var labelTheme = function () {
      var next = currentTheme() === "dark" ? "claro" : "escuro";
      themeButton.setAttribute("aria-label", "Usar tema " + next);
      themeButton.setAttribute("title", "Usar tema " + next);
    };
    themeButton.addEventListener("click", function () {
      var next = currentTheme() === "dark" ? "light" : "dark";
      root.setAttribute("data-theme", next);
      try { localStorage.setItem("katua-theme", next); } catch (e) { /* armazenamento indisponível */ }
      labelTheme();
    });
    labelTheme();
  }

  // Menu no celular: abre e fecha a lista de links.
  var header = document.querySelector("[data-header]");
  var navButton = document.querySelector("[data-nav-toggle]");
  var setMenu = function (open) {
    if (!header || !navButton) return;
    if (open) header.setAttribute("data-open", ""); else header.removeAttribute("data-open");
    navButton.setAttribute("aria-expanded", open ? "true" : "false");
    navButton.setAttribute("aria-label", open ? "Fechar menu" : "Abrir menu");
  };
  if (header && navButton) {
    navButton.addEventListener("click", function () { setMenu(!header.hasAttribute("data-open")); });
    header.addEventListener("click", function (event) {
      if (event.target.closest && event.target.closest("a")) setMenu(false);
    });
    document.addEventListener("keydown", function (event) {
      if (event.key === "Escape" && header.hasAttribute("data-open")) { setMenu(false); navButton.focus(); }
    });
  }

  // Seção atual: marca o link do cabeçalho da seção que cruza o meio da tela.
  var links = {};
  Array.prototype.forEach.call(document.querySelectorAll(".kt-nav-link"), function (link) {
    var id = (link.getAttribute("href") || "").slice(1);
    if (id) links[id] = link;
  });
  if ("IntersectionObserver" in window) {
    var observer = new IntersectionObserver(function (entries) {
      entries.forEach(function (entry) {
        var link = links[entry.target.id];
        if (!link) return;
        if (entry.isIntersecting) link.setAttribute("aria-current", "location");
        else link.removeAttribute("aria-current");
      });
    }, { rootMargin: "-45% 0px -55% 0px" });
    Object.keys(links).forEach(function (id) {
      var section = document.getElementById(id);
      if (section) observer.observe(section);
    });
  }
})();
