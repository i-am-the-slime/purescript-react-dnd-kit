module Test.React.DndKit.Stories.Kanban where

import Prelude hiding (div)

import Data.Array (filter, findIndex, insertAt, length, mapWithIndex, snoc, (!!))
import Data.Foldable (any)
import Data.Maybe (Maybe(..), fromMaybe)
import Data.Newtype (un)
import Data.Tuple.Nested ((/\))
import Effect (Effect)
import React.Basic (JSX)
import React.Basic.Hooks as React
import React.DndKit (dragDropProvider)
import React.DndKit.Helpers (arrayMove)
import React.DndKit.Sortable (SortableId(..), useSortable)
import React.DndKit.Hooks (useDroppable)
import React.DndKit.Types (DragDropManager, DragEndEvent, DragOverEvent, DraggableId(..), DroppableId(..), Source, Target, callbackRef, move)
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
  let
    applyDrag :: Maybe Source -> Maybe Target -> Columns -> Columns
    applyDrag src tgt cols = handleDrag cols src tgt

    onDragOver :: DragOverEvent -> DragDropManager -> Effect Unit
    onDragOver event _ = setColumns (applyDrag event.operation.source event.operation.target)

    onDragEnd :: DragEndEvent -> DragDropManager -> Effect Unit
    onDragEnd event _ = setColumns (applyDrag event.operation.source event.operation.target)

  pure $ div { style: Styles.boardStyle } do
    dragDropProvider { onDragOver, onDragEnd }
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

handleDrag :: Columns -> Maybe Source -> Maybe Target -> Columns
handleDrag cols (Just src) (Just tgt) = do
  let sourceId = un DraggableId src.id
  let targetId = un DroppableId tgt.id
  case findColumn sourceId cols /\ findColumn targetId cols of
    Just fromCol /\ Just toCol
      | fromCol == toCol -> reorderInColumn cols fromCol sourceId targetId
      | otherwise -> moveBetweenColumns cols fromCol toCol sourceId targetId
    Just fromCol /\ Nothing
      | isColumnId targetId -> moveBetweenColumns cols fromCol targetId sourceId targetId
    _ -> cols
handleDrag cols _ _ = cols

isColumnId :: String -> Boolean
isColumnId "todo" = true
isColumnId "doing" = true
isColumnId "done" = true
isColumnId _ = false

findColumn :: String -> Columns -> Maybe String
findColumn id cols
  | any (\t -> t.id == id) cols.todo = Just "todo"
  | any (\t -> t.id == id) cols.doing = Just "doing"
  | any (\t -> t.id == id) cols.done = Just "done"
  | otherwise = Nothing

getColumn :: String -> Columns -> Array Task
getColumn "todo" cols = cols.todo
getColumn "doing" cols = cols.doing
getColumn "done" cols = cols.done
getColumn _ _ = []

setColumn :: String -> Array Task -> Columns -> Columns
setColumn "todo" tasks cols = cols { todo = tasks }
setColumn "doing" tasks cols = cols { doing = tasks }
setColumn "done" tasks cols = cols { done = tasks }
setColumn _ _ cols = cols

reorderInColumn :: Columns -> String -> String -> String -> Columns
reorderInColumn cols col sourceId targetId = do
  let tasks = getColumn col cols
  case findIndex (\t -> t.id == sourceId) tasks /\ findIndex (\t -> t.id == targetId) tasks of
    Just from /\ Just to -> setColumn col (arrayMove tasks from to) cols
    _ -> cols

moveBetweenColumns :: Columns -> String -> String -> String -> String -> Columns
moveBetweenColumns cols fromCol toCol sourceId targetId = do
  let fromTasks = getColumn fromCol cols
  let toTasks = getColumn toCol cols
  case findIndex (\t -> t.id == sourceId) fromTasks of
    Nothing -> cols
    Just srcIdx -> do
      let task = fromMaybe { id: "", title: "" } (fromTasks !! srcIdx)
      let newFrom = filter (\t -> t.id /= sourceId) fromTasks
      let tgtIdx = findIndex (\t -> t.id == targetId) toTasks
      let
        newTo = case tgtIdx of
          Just i -> fromMaybe (snoc toTasks task) (insertAt i task toTasks)
          Nothing -> snoc toTasks task
      cols # setColumn fromCol newFrom # setColumn toCol newTo

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
