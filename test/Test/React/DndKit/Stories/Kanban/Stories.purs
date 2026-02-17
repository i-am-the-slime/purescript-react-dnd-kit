module Test.React.DndKit.Stories.Kanban.Stories where

import React.Basic (JSX)
import Test.React.DndKit.Stories.Kanban (kanban)
import YogaStories.Controls (select)
import YogaStories.Story (story)

default :: JSX
default = story "default" kanban
  { columnColor: select "#1e293b" [ "#1e293b", "#1a1a2e", "#0f172a", "#172554" ]
  , cardColor: select "#334155" [ "#334155", "#3730a3", "#065f46", "#7c2d12" ]
  }
