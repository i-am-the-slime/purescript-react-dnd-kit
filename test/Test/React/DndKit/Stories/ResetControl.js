export const resetHashProps = () => {
  const hash = window.location.hash;
  const idx = hash.indexOf("?");
  window.location.hash = idx >= 0 ? hash.slice(0, idx) : hash;
  window.location.reload();
};
