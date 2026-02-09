import { RestrictToWindow, RestrictToElement } from "@dnd-kit/dom/modifiers";
import { RestrictToVerticalAxis, RestrictToHorizontalAxis, SnapModifier } from "@dnd-kit/abstract/modifiers";

export const restrictToVerticalAxis = RestrictToVerticalAxis;
export const restrictToHorizontalAxis = RestrictToHorizontalAxis;
export const restrictToWindow = RestrictToWindow;

export const restrictToElementImpl = (element) =>
  RestrictToElement.configure({ element });

export const snapImpl = (size) =>
  SnapModifier.configure({ size });
