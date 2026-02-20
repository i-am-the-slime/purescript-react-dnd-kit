module Test.React.DndKit.Stories.DragToTrash.Stories where

import React.Basic (JSX)
import Test.React.DndKit.Stories.DragToTrash (dragToTrash)
import YogaStories.Controls (color)
import YogaStories.Story (story)

default :: JSX
default = story "default" dragToTrash
  { cardColor: color "#4f46e5"
  , trashColor: color "#dc2626"
  , itemCount: 6
  }
