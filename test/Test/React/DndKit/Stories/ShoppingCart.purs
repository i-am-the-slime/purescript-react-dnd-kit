module Test.React.DndKit.Stories.ShoppingCart where

import Prelude hiding (div)

import Data.Array (find, length)
import Data.Maybe (Maybe(..))
import Data.Newtype (un)
import Data.Tuple.Nested ((/\))
import Effect (Effect)
import React.Basic (JSX)
import React.Basic.Hooks as React
import React.DndKit (dragDropProvider)
import React.DndKit.Hooks (useDragOperation, useDraggable, useDroppable)
import React.DndKit.Types (DragDropManager, DragEndEvent, DragType(..), DraggableId(..), DroppableId(..), callbackRef, clone)
import Test.React.DndKit.Stories.ShoppingCart.Styles as Styles
import Yoga.React (component)
import Yoga.React.DOM.HTML (div, span)
import Yoga.React.DOM.Internal (text)

type Props =
  { productColor :: String
  , cartColor :: String
  }

type Product = { id :: String, name :: String, price :: String }

type CartItem = { id :: String, name :: String, price :: String }

shoppingCart :: Props -> JSX
shoppingCart = component "ShoppingCart" \props -> React.do
  cart /\ setCart <- React.useState ([] :: Array CartItem)
  let
    onDragEnd :: DragEndEvent -> DragDropManager -> Effect Unit
    onDragEnd event _ = case event.operation.target of
      Just t | un DroppableId t.id == "cart" ->
        case event.operation.source of
          Just s -> do
            let prodId = un DraggableId s.id
            case find (\p -> p.id == prodId) products of
              Just prod -> setCart \c -> c <> [ { id: prod.id <> "-" <> show (length c), name: prod.name, price: prod.price } ]
              Nothing -> pure unit
          Nothing -> pure unit
      _ -> pure unit
  pure $ div { style: Styles.layoutStyle } do
    dragDropProvider { onDragEnd }
      [ div { style: Styles.catalogStyle }
          ( products <#> \prod ->
              productCard { id: prod.id, name: prod.name, price: prod.price, productColor: props.productColor }
          )
      , cartZone { cart, cartColor: props.cartColor }
      ]

products :: Array Product
products =
  [ { id: "laptop", name: "Laptop", price: "$999" }
  , { id: "phone", name: "Phone", price: "$699" }
  , { id: "tablet", name: "Tablet", price: "$499" }
  , { id: "watch", name: "Watch", price: "$299" }
  , { id: "headphones", name: "Headphones", price: "$199" }
  , { id: "keyboard", name: "Keyboard", price: "$129" }
  ]

type ProductCardProps =
  { id :: String
  , name :: String
  , price :: String
  , productColor :: String
  }

productCard :: ProductCardProps -> JSX
productCard = component "ProductCard" \props -> React.do
  result <- useDraggable { id: DraggableId props.id, type: DragType "product", feedback: clone }
  let opacity = if result.isDragging then "0.5" else "1"
  let cursor = if result.isDragging then "grabbing" else "grab"
  pure $
    div { ref: callbackRef result.ref, style: Styles.productStyle props.productColor opacity cursor }
      [ div { style: Styles.productNameStyle } (text props.name)
      , div { style: Styles.productPriceStyle } (text props.price)
      ]

type CartZoneProps =
  { cart :: Array CartItem
  , cartColor :: String
  }

cartZone :: CartZoneProps -> JSX
cartZone = component "CartZone" \props -> React.do
  result <- useDroppable { id: DroppableId "cart", accept: DragType "product" }
  op <- useDragOperation
  let isActive = case op.source of
        Just _ -> true
        Nothing -> false
  let bg = if result.isDropTarget then props.cartColor else "#1e293b"
  let border = if isActive then "2px dashed " <> props.cartColor else "2px dashed #475569"
  pure $
    div { ref: callbackRef result.ref, style: Styles.cartStyle bg border }
      [ div { style: Styles.cartHeaderStyle } (text "Shopping Cart")
      , if length props.cart == 0 then
          div { style: Styles.emptyCartStyle }
            (text (if isActive then "Drop here to add" else "Drag products here"))
        else
          div { style: Styles.cartItemsStyle }
            ( props.cart <#> \item ->
                div { style: Styles.cartItemStyle }
                  [ span {} (text item.name)
                  , span { style: Styles.cartPriceStyle } (text item.price)
                  ]
            )
      ]
