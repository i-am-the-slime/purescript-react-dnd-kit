module Test.React.DndKit.Stories.Kanban.Stories where

import React.Basic (JSX)
import Test.React.DndKit.Stories.Kanban (kanban)
import YogaStories.Controls (color)
import YogaStories.Story (story)

default :: JSX
default = story "default" kanban
  { columnColor: color "#1e293b"
  , cardColor: color "#334155"
  , headerColor: color "#ffffff"
  }
