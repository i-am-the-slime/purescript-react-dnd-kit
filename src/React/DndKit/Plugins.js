import {
  Accessibility,
  AutoScroller,
  Cursor,
  Feedback,
  PreventSelection,
} from "@dnd-kit/dom";

export const accessibility = Accessibility;
export const autoScroller = AutoScroller;
export const cursor = Cursor;
export const feedback = Feedback;
export const preventSelection = PreventSelection;

export const noDropAnimation = null;
export const configureFeedbackImpl = (config) => Feedback.configure(config);
