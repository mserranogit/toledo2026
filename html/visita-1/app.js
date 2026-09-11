/**
 * GUÍA TURÍSTICA TOLEDO 2026 - LÓGICA INTERACTIVA & RESPONSIVA
 */

document.addEventListener('DOMContentLoaded', () => {
  // Elementos del DOM
  const sidebar = document.getElementById('sidebar');
  const openSidebarBtn = document.getElementById('openSidebarBtn');
  const closeSidebarBtn = document.getElementById('closeSidebarBtn');
  const sidebarOverlay = document.getElementById('sidebarOverlay');
  const navItems = document.querySelectorAll('.nav-item');
  const sections = document.querySelectorAll('.guide-section');

  // Abrir sidebar en móvil
  const openSidebar = () => {
    sidebar.classList.add('open');
    sidebarOverlay.classList.add('active');
    document.body.style.overflow = 'hidden'; // Bloquear scroll de fondo
  };

  // Cerrar sidebar en móvil
  const closeSidebar = () => {
    sidebar.classList.remove('open');
    sidebarOverlay.classList.remove('active');
    document.body.style.overflow = '';
  };

  if (openSidebarBtn) {
    openSidebarBtn.addEventListener('click', openSidebar);
  }

  if (closeSidebarBtn) {
    closeSidebarBtn.addEventListener('click', closeSidebar);
  }

  if (sidebarOverlay) {
    sidebarOverlay.addEventListener('click', closeSidebar);
  }

  // Cerrar con tecla Escape
  document.addEventListener('keydown', (e) => {
    if (e.key === 'Escape' && sidebar.classList.contains('open')) {
      closeSidebar();
    }
  });

  // Al hacer clic en un item de navegación:
  navItems.forEach(item => {
    item.addEventListener('click', (e) => {
      // Remover clase active previa
      navItems.forEach(i => i.classList.remove('active'));
      item.classList.add('active');

      // Si está en móvil, cerrar sidebar automáticamente tras seleccionar
      if (window.innerWidth <= 860) {
        closeSidebar();
      }
    });
  });

  // Observer para resaltar la sección actual en el menú durante el scroll
  const observerOptions = {
    root: null,
    rootMargin: '-20% 0px -70% 0px',
    threshold: 0
  };

  const sectionObserver = new IntersectionObserver((entries) => {
    entries.forEach(entry => {
      if (entry.isIntersecting) {
        const id = entry.target.getAttribute('id');
        navItems.forEach(link => {
          if (link.getAttribute('href') === `#${id}`) {
            link.classList.add('active');
          } else {
            link.classList.remove('active');
          }
        });
      }
    });
  }, observerOptions);

  sections.forEach(section => {
    sectionObserver.observe(section);
  });
});
