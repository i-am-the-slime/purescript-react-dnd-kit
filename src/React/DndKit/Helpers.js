import * as Helpers from "@dnd-kit/helpers";

function withRawOp(event) {
  var raw = event && event.operation && event.operation.__rawOp;
  return raw ? { operation: raw, canceled: event.canceled } : event;
}
export const move = (items) => (event) => Helpers.move(items, withRawOp(event));
export const swap = (items) => (event) => Helpers.swap(items, withRawOp(event));
export const arrayMove = (array) => (from) => (to) =>
  Helpers.arrayMove(array, from, to);
export const arraySwap = (array) => (from) => (to) =>
  Helpers.arraySwap(array, from, to);
