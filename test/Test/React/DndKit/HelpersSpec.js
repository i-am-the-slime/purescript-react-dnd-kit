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

// Test: does move work with a CONVERTED event (what moveItems receives)?
import { convertOperationSnapshot } from "../../src/React/DndKit/Internal.js";
import { toMaybe as psToMaybe } from "../../output/Data.Nullable/index.js";
import { move as dndMove } from "@dnd-kit/helpers";

export const testMoveWithConvertedEvent = () => {
  const rawOperation = {
    source: { id: "a", index: 0, element: null, manager: { dragOperation: { shape: null, position: { current: { x: 0, y: 0 } } } } },
    target: { id: "c", index: 2, element: null },
    canceled: false,
    activatorEvent: null,
    position: { current: { x: 0, y: 0 }, initial: { x: 0, y: 0 } },
    transform: { x: 0, y: 0 },
  };

  // This is exactly what convertDragEndEvent does
  const convertedOperation = convertOperationSnapshot(psToMaybe, rawOperation);

  const convertedEvent = {
    operation: convertedOperation,
    canceled: false,
  };

  const items = [{ id: "a" }, { id: "b" }, { id: "c" }];

  // moveItems does: dndMove(items, convertedEvent)
  const result = dndMove(items, convertedEvent);
  const sameRef = result === items;
  const ids = result.map(x => x.id).join(",");
  return JSON.stringify({
    sameRef,
    ids,
    sourceType: typeof convertedOperation.source,
    sourceConstructor: convertedOperation.source?.constructor?.name,
    sourceHasId: "id" in (convertedOperation.source || {}),
    sourceId: convertedOperation.source?.id,
    sourceValue0Id: convertedOperation.source?.value0?.id,
  });
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
