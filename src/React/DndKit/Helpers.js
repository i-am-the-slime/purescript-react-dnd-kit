import * as Helpers from "@dnd-kit/helpers";

export const move = (items) => (event) => Helpers.move(items, event);
export const swap = (items) => (event) => Helpers.swap(items, event);
export const arrayMove = (array) => (from) => (to) => Helpers.arrayMove(array, from, to);
export const arraySwap = (array) => (from) => (to) => Helpers.arraySwap(array, from, to);
