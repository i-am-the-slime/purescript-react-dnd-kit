import React from "react";
import { DragDropProvider, DragOverlay } from "@dnd-kit/react";

export const createElementImpl = (component, props, children) => {
  if (Array.isArray(children))
    return React.createElement(component, props, ...children);
  return React.createElement(component, props, children);
};
export const dragDropProviderImpl = DragDropProvider;
export const dragOverlayImpl = DragOverlay;
