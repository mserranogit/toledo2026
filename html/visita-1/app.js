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

  // ==========================================================================
  // SINCRONIZACIÓN DE AUDIOGUÍAS INTERACTIVAS
  // ==========================================================================
  document.querySelectorAll('audio').forEach(audio => {
    const btn = document.querySelector(`[data-target="${audio.id}"]`);
    if (!btn) return;

    audio.addEventListener('play', () => {
      btn.classList.add('playing');
      const textSpan = btn.querySelector('.audio-state-text');
      if (textSpan) textSpan.textContent = 'Pausar';
      const iconSpan = btn.querySelector('.audio-icon');
      if (iconSpan) iconSpan.textContent = '⏸';
    });

    audio.addEventListener('pause', () => {
      btn.classList.remove('playing');
      const textSpan = btn.querySelector('.audio-state-text');
      if (textSpan) textSpan.textContent = 'Escuchar';
      const iconSpan = btn.querySelector('.audio-icon');
      if (iconSpan) iconSpan.textContent = '▶';
    });

    audio.addEventListener('ended', () => {
      btn.classList.remove('playing');
      const textSpan = btn.querySelector('.audio-state-text');
      if (textSpan) textSpan.textContent = 'Escuchar';
      const iconSpan = btn.querySelector('.audio-icon');
      if (iconSpan) iconSpan.textContent = '▶';
    });
  });
});

// Función global para alternar reproducción y pausar los otros audios
window.toggleAudio = function(btn, audioId) {
  const audio = document.getElementById(audioId);
  if (!audio) return;

  if (!audio.paused) {
    audio.pause();
  } else {
    // Pausar cualquier otro audio en reproducción
    document.querySelectorAll('audio').forEach(a => {
      if (a !== audio && !a.paused) {
        a.pause();
      }
    });

    audio.play().catch(err => {
      console.warn('Reproducción de audio bloqueada o no iniciada:', err);
    });
  }
};
