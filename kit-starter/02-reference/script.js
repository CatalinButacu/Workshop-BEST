// ============================================================
// Pattern universal: SELECT -> LISTEN -> CHANGE
// 80% din interactiunile pe un site static urmeaza acest pattern.
// ============================================================


// 1. HAMBURGER TOGGLE — deschide/inchide nav-ul pe mobil
const toggle = document.querySelector('.nav-toggle');
const nav    = document.querySelector('.nav');

toggle.addEventListener('click', () => {
  const isOpen = nav.classList.toggle('open');
  toggle.setAttribute('aria-expanded', isOpen);
});


// 2. SMOOTH SCROLL pentru link-urile cu ancora (#despre, #contact)
//    Inchide si meniul mobile dupa click pe un link.
document.querySelectorAll('a[href^="#"]').forEach((link) => {
  link.addEventListener('click', (e) => {
    const href = link.getAttribute('href');
    if (href === '#') return;

    const target = document.querySelector(href);
    if (!target) return;

    e.preventDefault();
    target.scrollIntoView({ behavior: 'smooth' });

    // Inchide nav-ul mobile dupa navigare
    nav.classList.remove('open');
    toggle.setAttribute('aria-expanded', 'false');
  });
});


// 3. SCROLL REVEAL — sectiunile fade-in cand intra in viewport
//    IntersectionObserver e mai performant decat un scroll listener:
//    callback-ul ruleaza doar cand starea de vizibilitate se schimba.
const revealObserver = new IntersectionObserver((entries) => {
  entries.forEach((entry) => {
    if (entry.isIntersecting) {
      entry.target.classList.add('visible');
      revealObserver.unobserve(entry.target); // o singura data per element
    }
  });
}, { threshold: 0.15 });

document.querySelectorAll('.reveal').forEach((el) => revealObserver.observe(el));


// 4. FORM SUBMIT — interceptez submit-ul, afisez confirmare
const form = document.querySelector('#contact-form');

form.addEventListener('submit', (e) => {
  e.preventDefault();

  const data = Object.fromEntries(new FormData(form));
  console.log('Mesaj primit:', data);

  form.reset();
  alert(`Multumesc, ${data.nume}! Mesajul a fost primit.\n\n(Demo only — intr-un site real ar merge la un server.)`);
});
