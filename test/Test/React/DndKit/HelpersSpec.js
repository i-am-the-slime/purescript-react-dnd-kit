import { wrapHandlers, convertOperationSnapshot } from "../../src/React/DndKit/Internal.js";
import { moveOnDragImpl, move as psMove } from "../../src/React/DndKit/Helpers.js";
import { toMaybe as psToMaybe } from "../../output/Data.Nullable/index.js";
import { move as dndMove } from "@dnd-kit/helpers";

// Simplified toMaybe for wrapHandlers tests (identity — no Maybe wrapping)
function toMaybe(x) { return x; }

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

// --- __rawHandler mechanism tests ---

export const testRawHandlerDetection = () => {
  const handler = { __rawHandler: (event, manager) => "raw-called" };
  const props = { onDragOver: handler };
  const result = wrapHandlers(toMaybe, props);
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

// --- moveItems bug: converted events have Maybe-wrapped source/target ---

function makeRawOp(sourceId, targetId) {
  return {
    source: { id: sourceId, index: 0, element: null, manager: { dragOperation: { shape: null, position: { current: { x: 0, y: 0 } } } } },
    target: { id: targetId, index: 2, element: null, shape: { center: { y: 50 } } },
    canceled: false,
    activatorEvent: null,
    position: { current: { x: 0, y: 0 }, initial: { x: 0, y: 0 } },
    transform: { x: 0, y: 0 },
  };
}

// Prove that @dnd-kit/helpers move() fails with converted events
export const testDndMoveFailsWithConvertedEvent = () => {
  const rawOp = makeRawOp("a", "c");
  const converted = convertOperationSnapshot(psToMaybe, rawOp);
  const event = { operation: converted, canceled: false };
  const items = [{ id: "a" }, { id: "b" }, { id: "c" }];
  const result = dndMove(items, event);
  // source is Maybe-wrapped → source.id is undefined → move returns items unchanged
  return result === items;
};

// Our PureScript FFI move() should work because convertOperation preserves __rawOp
export const testPsMoveWorksWithConvertedFlatArray = () => {
  const rawOp = makeRawOp("a", "c");
  const converted = convertOperationSnapshot(psToMaybe, rawOp);
  const event = { operation: converted, canceled: false };
  const items = [{ id: "a" }, { id: "b" }, { id: "c" }];
  const result = psMove(items)(event);
  return result.map(x => x.id).join(",");
};

// Grouped record (kanban): our move() should handle cross-column transfers
export const testPsMoveWorksWithConvertedGrouped = () => {
  const rawOp = makeRawOp("a1", "b1");
  const converted = convertOperationSnapshot(psToMaybe, rawOp);
  const event = { operation: converted, canceled: false };
  const items = { left: [{ id: "a1" }, { id: "a2" }], right: [{ id: "b1" }] };
  const result = psMove(items)(event);
  return result.left.map(x => x.id).join(",") + "|" + result.right.map(x => x.id).join(",");
};
