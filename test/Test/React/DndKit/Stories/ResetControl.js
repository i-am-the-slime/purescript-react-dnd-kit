export const resetHashProps = () => {
  const hash = window.location.hash;
  const idx = hash.indexOf("?");
  const path = idx >= 0 ? hash.slice(0, idx) : hash;
  // Navigate away briefly to unmount the story, then back without props
  window.location.hash = "#/";
  requestAnimationFrame(() => {
    window.location.hash = path;
  });
};
