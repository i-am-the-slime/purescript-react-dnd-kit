import * as Helpers from "@dnd-kit/helpers";

export const move = (items) => (event) => Helpers.move(items, event);
export const swap = (items) => (event) => Helpers.swap(items, event);
export const arrayMove = (array) => (from) => (to) =>
  Helpers.arrayMove(array, from, to);
export const arraySwap = (array) => (from) => (to) =>
  Helpers.arraySwap(array, from, to);

export const moveOnDragImpl = (setState) => ({
  __rawHandler: (event, manager) => {
    setState((items) => {
      const result = Helpers.move(items, event);
      console.log("[moveOnDrag]", {
        sourceId: event.operation?.source?.id,
        targetId: event.operation?.target?.id,
        canceled: event.operation?.canceled,
        itemsBefore: Array.isArray(items) ? items.map(x => x.id || x) : Object.keys(items),
        itemsAfter: Array.isArray(result) ? result.map(x => x.id || x) : Object.keys(result),
        same: items === result,
      });
      return result;
    })();
  }
});

export const swapOnDragImpl = (setState) => ({
  __rawHandler: (event, manager) => {
    setState((items) => Helpers.swap(items, event))();
  }
});
