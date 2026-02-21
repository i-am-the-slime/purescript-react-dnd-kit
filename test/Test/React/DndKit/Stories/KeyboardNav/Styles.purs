module Test.React.DndKit.Stories.KeyboardNav.Styles where

import Yoga.React.DOM.Internal (CSS, css)

containerStyle :: CSS
containerStyle = css { maxWidth: "400px", margin: "0 auto" }

instructionStyle :: CSS
instructionStyle = css
  { padding: "10px 16px"
  , marginBottom: "16px"
  , backgroundColor: "rgba(255,255,255,0.05)"
  , borderRadius: "8px"
  , color: "rgba(255,255,255,0.6)"
  , fontSize: "12px"
  , textAlign: "center"
  , lineHeight: "1.5"
  }

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
  , display: "flex"
  , alignItems: "center"
  , gap: "12px"
  , transition: "background-color 200ms, opacity 200ms"
  }

indexStyle :: CSS
indexStyle = css
  { width: "24px"
  , height: "24px"
  , borderRadius: "12px"
  , backgroundColor: "rgba(255,255,255,0.15)"
  , display: "flex"
  , alignItems: "center"
  , justifyContent: "center"
  , fontSize: "12px"
  , fontWeight: "600"
  , flexShrink: "0"
  }
