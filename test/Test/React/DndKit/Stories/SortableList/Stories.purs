module Test.React.DndKit.Stories.SortableList.Stories where

import React.Basic (JSX)
import Test.React.DndKit.Stories.SortableList (sortableList)
import YogaStories.Controls (select)
import YogaStories.Story (story)

default :: JSX
default = story "default" sortableList
  { itemColor: select "#4f46e5" [ "#4f46e5", "#059669", "#d97706", "#dc2626", "#7c3aed" ]
  , dragColor: select "#6366f1" [ "#6366f1", "#10b981", "#f59e0b", "#ef4444", "#8b5cf6" ]
  , itemCount: 5
  }
