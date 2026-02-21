module Test.React.DndKit.Stories.FileManager.Styles where

import Yoga.React.DOM.Internal (CSS, css)

containerStyle :: CSS
containerStyle = css
  { maxWidth: "400px"
  , margin: "0 auto"
  , backgroundColor: "#0f172a"
  , borderRadius: "12px"
  , padding: "12px"
  , fontFamily: "monospace"
  }

nodeStyle :: String -> String -> String -> CSS
nodeStyle bg opacity indent = css
  { backgroundColor: bg
  , borderRadius: "6px"
  , marginBottom: "2px"
  , marginLeft: indent
  , opacity
  , transition: "background-color 200ms, opacity 200ms"
  }

nodeContentStyle :: CSS
nodeContentStyle = css
  { display: "flex"
  , alignItems: "center"
  , gap: "8px"
  , padding: "8px 12px"
  , cursor: "grab"
  , userSelect: "none"
  }

iconStyle :: CSS
iconStyle = css { fontSize: "14px" }

nameStyle :: CSS
nameStyle = css { fontSize: "13px", color: "white" }
