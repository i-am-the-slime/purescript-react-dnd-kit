module Test.React.DndKit.Stories.FileManager where

import Prelude hiding (div)

import Data.Array (filter, sortWith)
import Data.Maybe (Maybe(..))
import Data.Newtype (un)
import Data.Set as Set
import Data.Tuple.Nested ((/\))
import Effect (Effect)
import React.Basic (JSX)
import React.Basic.Events (handler_)
import React.Basic.Hooks as React
import React.DndKit (dragDropProvider)
import React.DndKit.Hooks (useDraggable, useDroppable)
import React.DndKit.Types (DragDropManager, DragEndEvent, DragType(..), DraggableId(..), DroppableId(..), callbackRef)
import Test.React.DndKit.Stories.FileManager.Styles as Styles
import Yoga.React (component)
import Yoga.React.DOM.HTML (div, span)
import Yoga.React.DOM.Internal (text)

type Props =
  { folderColor :: String
  , fileColor :: String
  , dropHighlight :: String
  }

type FileNode =
  { id :: String
  , name :: String
  , isFolder :: Boolean
  , parentId :: Maybe String
  }

fileManager :: Props -> JSX
fileManager = component "FileManager" \props -> React.do
  nodes /\ setNodes <- React.useState initialNodes
  expanded /\ setExpanded <- React.useState (Set.fromFoldable [ "root", "src", "docs" ])
  let
    onDragEnd :: DragEndEvent -> DragDropManager -> Effect Unit
    onDragEnd event _ = case event.operation.source /\ event.operation.target of
      Just s /\ Just t -> do
        let nodeId = un DraggableId s.id
        let targetId = un DroppableId t.id
        setNodes \ns -> ns <#> \n ->
          if n.id == nodeId then n { parentId = Just targetId } else n
      _ -> pure unit
    toggle folderId = setExpanded \ex ->
      if Set.member folderId ex then Set.delete folderId ex else Set.insert folderId ex
    visibleNodes = getVisibleNodes nodes expanded
  pure $ div { style: Styles.containerStyle } do
    dragDropProvider { onDragEnd } do
      visibleNodes <#> \{ node, depth } ->
        treeNode
          { node
          , depth
          , isExpanded: Set.member node.id expanded
          , onToggle: toggle node.id
          , folderColor: props.folderColor
          , fileColor: props.fileColor
          , dropHighlight: props.dropHighlight
          }

type VisibleNode = { node :: FileNode, depth :: Int }

getVisibleNodes :: Array FileNode -> Set.Set String -> Array VisibleNode
getVisibleNodes nodes expanded = go Nothing 0
  where
  go parentId depth = do
    let children = nodes # filter (\n -> n.parentId == parentId) # sortWith (\n -> if n.isFolder then 0 else (1 :: Int))
    children >>= \node ->
      [ { node, depth } ] <>
        if node.isFolder && Set.member node.id expanded
        then go (Just node.id) (depth + 1)
        else []

type TreeNodeProps =
  { node :: FileNode
  , depth :: Int
  , isExpanded :: Boolean
  , onToggle :: Effect Unit
  , folderColor :: String
  , fileColor :: String
  , dropHighlight :: String
  }

treeNode :: TreeNodeProps -> JSX
treeNode props =
  if props.node.isFolder
  then folderNode props
  else fileNode props

folderNode :: TreeNodeProps -> JSX
folderNode = component "FolderNode" \props -> React.do
  draggable <- useDraggable { id: DraggableId props.node.id, type: DragType "node" }
  droppable <- useDroppable { id: DroppableId props.node.id, accept: DragType "node" }
  let icon = if props.isExpanded then "📂" else "📁"
  let bg = if droppable.isDropTarget then props.dropHighlight else props.folderColor
  let opacity = if draggable.isDragging then "0.4" else "1"
  let indent = show (props.depth * 24) <> "px"
  pure $
    div { ref: callbackRef droppable.ref, style: Styles.nodeStyle bg opacity indent }
      [ div { ref: callbackRef draggable.ref, style: Styles.nodeContentStyle, onClick: handler_ props.onToggle }
          [ span { style: Styles.iconStyle } (text icon)
          , span { style: Styles.nameStyle } (text props.node.name)
          ]
      ]

fileNode :: TreeNodeProps -> JSX
fileNode = component "FileNode" \props -> React.do
  draggable <- useDraggable { id: DraggableId props.node.id, type: DragType "node" }
  let opacity = if draggable.isDragging then "0.4" else "1"
  let indent = show (props.depth * 24) <> "px"
  pure $
    div { ref: callbackRef draggable.ref, style: Styles.nodeStyle props.fileColor opacity indent }
      [ div { style: Styles.nodeContentStyle }
          [ span { style: Styles.iconStyle } (text "📄")
          , span { style: Styles.nameStyle } (text props.node.name)
          ]
      ]

initialNodes :: Array FileNode
initialNodes =
  [ { id: "root", name: "project", isFolder: true, parentId: Nothing }
  , { id: "src", name: "src", isFolder: true, parentId: Just "root" }
  , { id: "docs", name: "docs", isFolder: true, parentId: Just "root" }
  , { id: "readme", name: "README.md", isFolder: false, parentId: Just "root" }
  , { id: "gitignore", name: ".gitignore", isFolder: false, parentId: Just "root" }
  , { id: "main", name: "Main.purs", isFolder: false, parentId: Just "src" }
  , { id: "utils", name: "Utils.purs", isFolder: false, parentId: Just "src" }
  , { id: "types", name: "Types.purs", isFolder: false, parentId: Just "src" }
  , { id: "components", name: "components", isFolder: true, parentId: Just "src" }
  , { id: "button", name: "Button.purs", isFolder: false, parentId: Just "components" }
  , { id: "input", name: "Input.purs", isFolder: false, parentId: Just "components" }
  , { id: "guide", name: "guide.md", isFolder: false, parentId: Just "docs" }
  , { id: "api", name: "api.md", isFolder: false, parentId: Just "docs" }
  ]
