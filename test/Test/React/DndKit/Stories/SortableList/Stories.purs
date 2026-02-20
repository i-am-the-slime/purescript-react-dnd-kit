module Test.React.DndKit.Stories.SortableList.Stories where

import React.Basic (JSX)
import Test.React.DndKit.Stories.SortableList (sortableList)
import YogaStories.Controls (color)
import YogaStories.Story (story)

default :: JSX
default = story "default" sortableList
  { itemColor: color "#4f46e5"
  , dragColor: color "#6366f1"
  , itemCount: 5
  }
