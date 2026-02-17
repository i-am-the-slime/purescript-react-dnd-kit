module Test.React.DndKit.Stories.DragToTrash.Stories where

import React.Basic (JSX)
import Test.React.DndKit.Stories.DragToTrash (dragToTrash)
import YogaStories.Controls (select)
import YogaStories.Story (story)

default :: JSX
default = story "default" dragToTrash
  { cardColor: select "#4f46e5" [ "#4f46e5", "#059669", "#d97706", "#7c3aed" ]
  , trashColor: select "#dc2626" [ "#dc2626", "#ef4444", "#b91c1c" ]
  , itemCount: 6
  }
