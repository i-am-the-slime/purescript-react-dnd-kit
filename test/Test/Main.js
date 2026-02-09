import "global-jsdom/register";

export function setupJsdom() {
  globalThis.ResizeObserver = class ResizeObserver {
    observe() {}
    unobserve() {}
    disconnect() {}
  };

  // jsdom's addEventListener rejects Node's AbortSignal because it's
  // not an instance of jsdom's own AbortSignal. Patch both Node's and
  // jsdom's EventTarget to strip the signal option so dnd-kit hooks
  // work in tests.
  for (const ET of [globalThis.EventTarget, window.EventTarget]) {
    if (!ET || ET.__patched) continue;
    const orig = ET.prototype.addEventListener;
    ET.prototype.addEventListener = function (type, listener, options) {
      if (options && typeof options === "object" && "signal" in options) {
        const { signal, ...rest } = options;
        return orig.call(this, type, listener, rest);
      }
      return orig.call(this, type, listener, options);
    };
    ET.__patched = true;
  }
}
