export const resetHashProps = () => {
  const hash = window.location.hash;
  const idx = hash.indexOf("?");
  if (idx >= 0) {
    window.location.hash = hash.slice(0, idx);
  }
};
