// Alterna entre tema claro e escuro e guarda a escolha. Sem escolha, o site segue o sistema.
(function () {
  var root = document.documentElement;
  var button = document.querySelector("[data-theme-toggle]");
  if (!button) return;

  function current() {
    var chosen = root.getAttribute("data-theme");
    if (chosen) return chosen;
    return window.matchMedia("(prefers-color-scheme: dark)").matches ? "dark" : "light";
  }

  function label() {
    var next = current() === "dark" ? "claro" : "escuro";
    button.setAttribute("aria-label", "Usar tema " + next);
    button.setAttribute("title", "Usar tema " + next);
  }

  button.addEventListener("click", function () {
    var next = current() === "dark" ? "light" : "dark";
    root.setAttribute("data-theme", next);
    try { localStorage.setItem("katua-theme", next); } catch (e) { /* armazenamento indisponível */ }
    label();
  });

  label();
})();
