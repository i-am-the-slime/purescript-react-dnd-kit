module Test.React.DndKit.Stories.Kanban where

import Prelude hiding (div)

import Data.Array (mapWithIndex)
import Data.Tuple.Nested ((/\))
import React.Basic (JSX)
import React.Basic.Hooks as React
import React.DndKit (dragDropProvider)
import React.DndKit.Helpers (moveOnDrag)
import React.DndKit.Sortable (SortableId(..), useSortable)
import React.DndKit.Types (callbackRef)
import Test.React.DndKit.Stories.Kanban.Styles as Styles
import Yoga.React (component)
import Yoga.React.DOM.HTML (div)
import Yoga.React.DOM.Internal (text)

type Props =
  { columnColor :: String
  , cardColor :: String
  , headerColor :: String
  }

type Task = { id :: String, title :: String }

kanban :: Props -> JSX
kanban = component "Kanban" \props -> React.do
  tasks /\ setTasks <- React.useState initialTasks
  pure $ div { style: Styles.boardStyle } do
    dragDropProvider
      { onDragOver: moveOnDrag setTasks
      , onDragEnd: moveOnDrag setTasks
      }
      ( tasks # mapWithIndex \index task ->
          card { id: task.id, title: task.title, index, cardColor: props.cardColor }
      )
  where
  initialTasks =
    [ { id: "task-1", title: "Design mockups" }
    , { id: "task-2", title: "Write specs" }
    , { id: "task-3", title: "Set up CI" }
    , { id: "task-4", title: "Build API" }
    , { id: "task-5", title: "Write tests" }
    ]

type CardProps =
  { id :: String
  , title :: String
  , index :: Int
  , cardColor :: String
  }

card :: CardProps -> JSX
card = component "Card" \props -> React.do
  result <- useSortable { id: SortableId props.id, index: props.index }
  let opacity = if result.isDragging then "0.5" else "1"
  let cursor = if result.isDragging then "grabbing" else "grab"
  pure $
    div { ref: callbackRef result.ref, style: Styles.cardStyle props.cardColor opacity cursor }
      (text props.title)
