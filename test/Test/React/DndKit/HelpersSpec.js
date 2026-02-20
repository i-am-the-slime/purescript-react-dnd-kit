export const mockDragEvent = (sourceId) => (targetId) => ({
  operation: {
    source: {
      id: sourceId,
      manager: {
        dragOperation: {
          shape: null,
          position: { current: { x: 0, y: 0 } },
        },
      },
    },
    target: { id: targetId, shape: null },
    canceled: false,
  },
});

import { wrapHandlers } from "../../src/React/DndKit/Internal.js";
import { moveOnDragImpl } from "../../src/React/DndKit/Helpers.js";

// Nullable -> Maybe (same as PureScript's toMaybe)
function toMaybe(x) {
  // Simplified — just needs to exist for wrapHandlers signature
  return x;
}

export const testRawHandlerDetection = () => {
  const handler = { __rawHandler: (event, manager) => "raw-called" };
  const props = { onDragOver: handler };
  const result = wrapHandlers(toMaybe, props);
  // Should extract the raw handler, not wrap it
  return typeof result.onDragOver === "function" && result.onDragOver !== handler;
};

export const testRawHandlerCalled = () => {
  let calledWith = null;
  const handler = { __rawHandler: (event, manager) => { calledWith = { event, manager }; } };
  const props = { onDragOver: handler };
  const result = wrapHandlers(toMaybe, props);
  result.onDragOver("test-event", "test-manager");
  return calledWith !== null && calledWith.event === "test-event" && calledWith.manager === "test-manager";
};

export const testMoveOnDragImplShape = () => {
  const mockSetState = (fn) => () => {};
  const result = moveOnDragImpl(mockSetState);
  return result !== null
    && typeof result === "object"
    && typeof result.__rawHandler === "function";
};

export const testMoveOnDragEndToEnd = () => {
  let capturedItems = null;
  // Mock PureScript-style setState: (items -> items) -> Effect Unit
  const mockSetState = (updater) => () => {
    capturedItems = updater([ { id: "a" }, { id: "b" }, { id: "c" } ]);
  };

  const sentinel = moveOnDragImpl(mockSetState);
  const props = { onDragOver: sentinel };
  const wrapped = wrapHandlers(toMaybe, props);

  const event = {
    operation: {
      source: { id: "a", manager: { dragOperation: { shape: null, position: { current: { x: 0, y: 0 } } } } },
      target: { id: "c", shape: null },
      canceled: false,
    },
  };

  wrapped.onDragOver(event, {});
  if (!capturedItems) return "setState was not called";
  const ids = capturedItems.map((x) => x.id);
  if (ids.join(",") !== "b,c,a") return "Expected b,c,a but got " + ids.join(",");
  return true;
};
