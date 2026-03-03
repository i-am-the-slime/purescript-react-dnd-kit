import { DOMRectangle } from "@dnd-kit/dom/utilities";
import { Rectangle } from "@dnd-kit/geometry";

export var setDragShape = function (manager) { return function (el) { return function () {
  manager.dragOperation.shape = new DOMRectangle(el);
}; }; };
export var updateDragShape = function (manager) { return function (left) { return function (top) { return function (width) { return function (height) { return function () {
  manager.dragOperation.shape = new Rectangle(left, top, width, height);
}; }; }; }; }; };
export var setGrabOffset = function (manager) { return function (x) { return function (y) { return function () {
  manager.__grabOffset = { x: x, y: y };
}; }; }; };
export var getGrabOffset = function (manager) { return function () {
  return manager.__grabOffset || null;
}; };
export var clearGrabOffset = function (manager) { return function () {
  manager.__grabOffset = null;
}; };
export var getDragPosition = function (manager) { return function () {
  var pos = manager.dragOperation.position.current;
  return pos ? { x: pos.x, y: pos.y } : null;
}; };
