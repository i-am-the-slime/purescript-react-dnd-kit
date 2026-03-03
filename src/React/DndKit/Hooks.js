import {
  useDraggable,
  useDroppable,
  useDragDropMonitor,
  useDragOperation,
  useDragDropManager,
} from "@dnd-kit/react";
import { useRef, useCallback } from "react";

export const useDraggableImpl = useDraggable;
export const useDroppableImpl = useDroppable;
export const useDragDropMonitorImpl = useDragDropMonitor;
export const useDragOperationImpl = useDragOperation;
export const useDragDropManagerImpl = useDragDropManager;
export const useStableCallbackRefImpl = function (dndRef, elRef) {
  var dndRefRef = useRef(dndRef);
  dndRefRef.current = dndRef;
  return useCallback(function (el) {
    elRef.current = el || null;
    dndRefRef.current(el);
  }, []);
};
