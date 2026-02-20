module Test.React.DndKit.Stories.Kanban where

import Prelude hiding (div)

import Data.Array (length, mapWithIndex)
import Data.Tuple.Nested ((/\))
import React.Basic (JSX)
import React.Basic.Hooks as React
import React.DndKit (dragDropProvider)
import React.DndKit.Helpers (moveOnDrag)
import React.DndKit.Sortable (SortableId(..), useSortable)
import React.DndKit.Hooks (useDroppable)
import React.DndKit.Types (DroppableId(..), callbackRef, move)
import Test.React.DndKit.Stories.Kanban.Styles as Styles
import Yoga.React (component)
import Yoga.React.DOM.HTML (div, h3, span)
import Yoga.React.DOM.Internal (text)

type Props =
  { columnColor :: String
  , cardColor :: String
  , headerColor :: String
  }

type Task = { id :: String, title :: String }

type Columns =
  { todo :: Array Task
  , doing :: Array Task
  , done :: Array Task
  }

kanban :: Props -> JSX
kanban = component "Kanban" \props -> React.do
  columns /\ setColumns <- React.useState initialColumns
  pure $ div { style: Styles.boardStyle } do
    dragDropProvider
      { onDragOver: moveOnDrag setColumns
      , onDragEnd: moveOnDrag setColumns
      }
      [ column { name: "To Do", group: "todo", tasks: columns.todo, columnColor: props.columnColor, cardColor: props.cardColor, headerColor: props.headerColor }
      , column { name: "In Progress", group: "doing", tasks: columns.doing, columnColor: props.columnColor, cardColor: props.cardColor, headerColor: props.headerColor }
      , column { name: "Done", group: "done", tasks: columns.done, columnColor: props.columnColor, cardColor: props.cardColor, headerColor: props.headerColor }
      ]
  where
  initialColumns =
    { todo:
        [ { id: "task-1", title: "Design mockups" }
        , { id: "task-2", title: "Write specs" }
        , { id: "task-3", title: "Set up CI" }
        ]
    , doing:
        [ { id: "task-4", title: "Build API" }
        , { id: "task-5", title: "Write tests" }
        ]
    , done:
        [ { id: "task-6", title: "Project setup" }
        ]
    }

type ColumnProps =
  { name :: String
  , group :: String
  , tasks :: Array Task
  , columnColor :: String
  , cardColor :: String
  , headerColor :: String
  }

column :: ColumnProps -> JSX
column = component "Column" \props -> React.do
  droppable <- useDroppable { id: DroppableId props.group, collisionPriority: 0.0 }
  pure $
    div { style: Styles.columnStyle props.columnColor }
      [ div { style: Styles.headerStyle }
          [ h3 { style: Styles.titleStyle props.headerColor } (text props.name)
          , span { style: Styles.countStyle } (text (show (length props.tasks)))
          ]
      , div { ref: callbackRef droppable.ref, style: Styles.listStyle }
          ( props.tasks # mapWithIndex \index task ->
              card { id: task.id, title: task.title, index, group: props.group, cardColor: props.cardColor }
          )
      ]

type CardProps =
  { id :: String
  , title :: String
  , index :: Int
  , group :: String
  , cardColor :: String
  }

card :: CardProps -> JSX
card = component "Card" \props -> React.do
  result <- useSortable { id: SortableId props.id, index: props.index, group: props.group, feedback: move }
  let opacity = if result.isDragging then "0.5" else "1"
  let cursor = if result.isDragging then "grabbing" else "grab"
  pure $
    div { ref: callbackRef result.ref, style: Styles.cardStyle props.cardColor opacity cursor }
      (text props.title)
