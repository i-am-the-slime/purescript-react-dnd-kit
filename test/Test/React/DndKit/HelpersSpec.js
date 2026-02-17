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
