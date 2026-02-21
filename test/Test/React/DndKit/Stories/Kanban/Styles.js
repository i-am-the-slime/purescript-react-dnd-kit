export const brighten = (color) => {
  // Add a white overlay effect by mixing with white
  // Works with hex colors like "#1e1e2e"
  if (color.startsWith("#")) {
    const r = parseInt(color.slice(1, 3), 16);
    const g = parseInt(color.slice(3, 5), 16);
    const b = parseInt(color.slice(5, 7), 16);
    const mix = 0.15;
    const br = Math.min(255, Math.round(r + (255 - r) * mix));
    const bg = Math.min(255, Math.round(g + (255 - g) * mix));
    const bb = Math.min(255, Math.round(b + (255 - b) * mix));
    return `#${br.toString(16).padStart(2, "0")}${bg.toString(16).padStart(2, "0")}${bb.toString(16).padStart(2, "0")}`;
  }
  return color;
};
