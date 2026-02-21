module Test.React.DndKit.Stories.DragOverlayDemo.Styles where

import Yoga.React.DOM.Internal (CSS, css)

containerStyle :: CSS
containerStyle = css { maxWidth: "400px", margin: "0 auto" }

listStyle :: CSS
listStyle = css { display: "flex", flexDirection: "column", gap: "8px" }

itemStyle :: String -> String -> String -> CSS
itemStyle bg opacity cursor = css
  { padding: "12px 16px"
  , backgroundColor: bg
  , borderRadius: "8px"
  , color: "white"
  , fontSize: "14px"
  , fontWeight: "500"
  , cursor
  , opacity
  , userSelect: "none"
  , display: "flex"
  , alignItems: "center"
  , gap: "10px"
  , transition: "opacity 200ms"
  }

handleStyle :: CSS
handleStyle = css { opacity: "0.6", fontSize: "12px" }

overlayStyle :: String -> CSS
overlayStyle bg = css
  { padding: "12px 16px"
  , backgroundColor: bg
  , borderRadius: "8px"
  , color: "white"
  , fontSize: "14px"
  , fontWeight: "600"
  , display: "flex"
  , alignItems: "center"
  , gap: "10px"
  , boxShadow: "0 8px 24px rgba(0,0,0,0.4)"
  , transform: "rotate(3deg) scale(1.05)"
  }

overlayHandleStyle :: CSS
overlayHandleStyle = css { opacity: "0.8", fontSize: "12px" }
