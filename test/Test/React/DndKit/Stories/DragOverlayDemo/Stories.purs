module Test.React.DndKit.Stories.DragOverlayDemo.Stories where

import React.Basic (JSX)
import Test.React.DndKit.Stories.DragOverlayDemo (dragOverlayDemo)
import YogaStories.Controls (color)
import YogaStories.Story (story)

default :: JSX
default = story "default" dragOverlayDemo
  { itemColor: color "#b45309"
  , overlayColor: color "#dc2626"
  }
