function convertEntity(toMaybe, entity) {
  if (entity == null) return toMaybe(null);
  return toMaybe({ id: entity.id, element: toMaybe(entity.element ?? null) });
}

var zeroCoords = { x: 0, y: 0 };

function convertOperation(toMaybe, op) {
  var pos = op.position ?? { current: zeroCoords, initial: zeroCoords };
  return {
    activatorEvent: toMaybe(op.activatorEvent ?? null),
    canceled: op.canceled ?? false,
    position: {
      current: pos.current ?? zeroCoords,
      initial: pos.initial ?? zeroCoords,
    },
    transform: op.transform ?? zeroCoords,
    source: convertEntity(toMaybe, op.source),
    target: convertEntity(toMaybe, op.target),
    __rawOp: op,
  };
}

function convertDragStartEvent(toMaybe, event) {
  return { operation: convertOperation(toMaybe, event.operation) };
}

function convertDragMoveEvent(toMaybe, event) {
  return {
    operation: convertOperation(toMaybe, event.operation),
    to: toMaybe(event.to),
    by: toMaybe(event.by),
  };
}

function convertDragOverEvent(toMaybe, event) {
  return { operation: convertOperation(toMaybe, event.operation) };
}

function convertDragEndEvent(toMaybe, event) {
  return {
    operation: convertOperation(toMaybe, event.operation),
    canceled: event.canceled,
  };
}

const converters = {
  onBeforeDragStart: convertDragStartEvent,
  onDragStart: convertDragStartEvent,
  onDragMove: convertDragMoveEvent,
  onDragOver: convertDragOverEvent,
  onCollision: (_toMaybe, event) => event,
  onDragEnd: convertDragEndEvent,
};

export function wrapHandlers(toMaybe, props) {
  const result = {};
  for (const key in props) {
    const converter = converters[key];
    if (props[key] && props[key].__rawHandler) {
      result[key] = props[key].__rawHandler;
    } else if (converter && typeof props[key] === "function") {
      const original = props[key];
      result[key] = (event, manager) =>
        original(converter(toMaybe, event))(manager)();
    } else {
      result[key] = props[key];
    }
  }
  return result;
}

export function convertOperationSnapshot(toMaybe, op) {
  return convertOperation(toMaybe, op);
}
