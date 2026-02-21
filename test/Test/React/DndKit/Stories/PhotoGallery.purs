module Test.React.DndKit.Stories.PhotoGallery where

import Prelude hiding (div)

import Data.Array (mapWithIndex)
import Data.Tuple.Nested ((/\))
import Effect (Effect)
import React.Basic (JSX)
import React.Basic.Hooks as React
import React.DndKit (dragDropProvider)
import React.DndKit.Helpers (moveItems)
import React.DndKit.Modifiers (restrictToHorizontalAxis)
import React.DndKit.Sortable (SortableId(..), useSortable)
import React.DndKit.Types (DragEndEvent, DragDropManager, callbackRef)
import Test.React.DndKit.Stories.PhotoGallery.Styles as Styles
import Yoga.React (component)
import Yoga.React.DOM.HTML (div)
import Yoga.React.DOM.Internal (text)

type Props =
  { thumbColor :: String
  , labelColor :: String
  }

type Photo = { id :: String, label :: String }

photoGallery :: Props -> JSX
photoGallery = component "PhotoGallery" \props -> React.do
  photos /\ setPhotos <- React.useState initialPhotos
  let
    onDragEnd :: DragEndEvent -> DragDropManager -> Effect Unit
    onDragEnd event _ = setPhotos \current -> moveItems current event
  pure $ div { style: Styles.containerStyle } do
    dragDropProvider { onDragEnd, modifiers: [ restrictToHorizontalAxis ] }
      [ div { style: Styles.galleryStyle }
          ( photos # mapWithIndex \index photo ->
              photoCard { id: photo.id, label: photo.label, index, thumbColor: props.thumbColor, labelColor: props.labelColor }
          )
      ]
  where
  initialPhotos =
    [ { id: "photo-1", label: "Sunset" }
    , { id: "photo-2", label: "Mountain" }
    , { id: "photo-3", label: "Ocean" }
    , { id: "photo-4", label: "Forest" }
    , { id: "photo-5", label: "Desert" }
    , { id: "photo-6", label: "City" }
    ]

type PhotoCardProps =
  { id :: String
  , label :: String
  , index :: Int
  , thumbColor :: String
  , labelColor :: String
  }

photoCard :: PhotoCardProps -> JSX
photoCard = component "PhotoCard" \props -> React.do
  result <- useSortable { id: SortableId props.id, index: props.index }
  let opacity = if result.isDragging then "0.4" else "1"
  let cursor = if result.isDragging then "grabbing" else "grab"
  pure $
    div { ref: callbackRef result.ref, style: Styles.cardStyle opacity cursor }
      [ div { style: Styles.thumbStyle props.thumbColor } ""
      , div { style: Styles.labelStyle props.labelColor } (text props.label)
      ]
