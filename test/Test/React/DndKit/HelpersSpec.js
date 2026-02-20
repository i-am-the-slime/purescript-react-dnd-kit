import { convertOperationSnapshot } from "../../src/React/DndKit/Internal.js";
import { move as psMove } from "../../src/React/DndKit/Helpers.js";
import { toMaybe as psToMaybe } from "../../output/Data.Nullable/index.js";
import { move as dndMove } from "@dnd-kit/helpers";

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

// @dnd-kit/helpers move() fails with Maybe-wrapped source/target
export const testDndMoveFailsWithConvertedEvent = () => {
  const rawOp = makeRawOp("a", "c");
  const converted = convertOperationSnapshot(psToMaybe, rawOp);
  const event = { operation: converted, canceled: false };
  const items = [{ id: "a" }, { id: "b" }, { id: "c" }];
  const result = dndMove(items, event);
  return result === items;
};

// Our FFI move() works because convertOperation preserves __rawOp
export const testPsMoveWorksWithConvertedFlatArray = () => {
  const rawOp = makeRawOp("a", "c");
  const converted = convertOperationSnapshot(psToMaybe, rawOp);
  const event = { operation: converted, canceled: false };
  const items = [{ id: "a" }, { id: "b" }, { id: "c" }];
  const result = psMove(items)(event);
  return result.map(x => x.id).join(",");
};

// Grouped record (kanban): cross-column transfers work via __rawOp
export const testPsMoveWorksWithConvertedGrouped = () => {
  const rawOp = makeRawOp("a1", "b1");
  const converted = convertOperationSnapshot(psToMaybe, rawOp);
  const event = { operation: converted, canceled: false };
  const items = { left: [{ id: "a1" }, { id: "a2" }], right: [{ id: "b1" }] };
  const result = psMove(items)(event);
  return result.left.map(x => x.id).join(",") + "|" + result.right.map(x => x.id).join(",");
};
