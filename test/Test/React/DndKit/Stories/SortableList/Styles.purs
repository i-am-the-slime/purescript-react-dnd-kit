module Test.React.DndKit.Stories.SortableList.Styles where

import Yoga.React.DOM.Internal (CSS, css)

containerStyle :: CSS
containerStyle = css { maxWidth: "400px", margin: "0 auto" }

itemStyle :: String -> String -> String -> CSS
itemStyle bg opacity cursor = css
  { padding: "12px 16px"
  , marginBottom: "8px"
  , backgroundColor: bg
  , borderRadius: "8px"
  , color: "white"
  , fontSize: "14px"
  , fontWeight: "500"
  , cursor
  , opacity
  , userSelect: "none"
  , transition: "background-color 200ms, opacity 200ms"
  , display: "flex"
  , alignItems: "center"
  , gap: "10px"
  }

handleStyle :: CSS
handleStyle = css { opacity: "0.6", fontSize: "12px" }
