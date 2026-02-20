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
      const src = event.operation?.source;
      const tgt = event.operation?.target;
      const beforeIds = Array.isArray(items) ? items.map(x => x.id || x).join(",") : JSON.stringify(items);
      const afterIds = Array.isArray(result) ? result.map(x => x.id || x).join(",") : JSON.stringify(result);
      console.log(`[moveOnDrag] src=${src?.id}(idx=${src?.index}) tgt=${tgt?.id}(idx=${tgt?.index}) same=${items === result} before=[${beforeIds}] after=[${afterIds}]`);
      return result;
    })();
  }
});

export const swapOnDragImpl = (setState) => ({
  __rawHandler: (event, manager) => {
    setState((items) => Helpers.swap(items, event))();
  }
});
