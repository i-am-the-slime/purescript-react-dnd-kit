module Test.React.DndKit.Stories.DragHandles.Styles where

import Yoga.React.DOM.Internal (CSS, css)

containerStyle :: CSS
containerStyle = css { maxWidth: "500px", margin: "0 auto" }

cardStyle :: String -> String -> CSS
cardStyle bg opacity = css
  { display: "flex"
  , alignItems: "center"
  , gap: "12px"
  , padding: "12px 16px"
  , marginBottom: "8px"
  , backgroundColor: bg
  , borderRadius: "8px"
  , color: "white"
  , opacity
  , transition: "background-color 200ms, opacity 200ms"
  }

gripStyle :: CSS
gripStyle = css
  { cursor: "grab"
  , opacity: "0.5"
  , fontSize: "18px"
  , lineHeight: "1"
  , userSelect: "none"
  , padding: "4px"
  }

contentStyle :: CSS
contentStyle = css { flex: "1", minWidth: "0" }

titleStyle :: CSS
titleStyle = css { fontSize: "14px", fontWeight: "600" }

descriptionStyle :: CSS
descriptionStyle = css { fontSize: "12px", opacity: "0.7", marginTop: "2px" }

buttonStyle :: CSS
buttonStyle = css
  { backgroundColor: "#6366f1"
  , border: "none"
  , borderRadius: "6px"
  , color: "white"
  , padding: "6px 12px"
  , fontSize: "12px"
  , fontWeight: "500"
  , cursor: "pointer"
  }

resetStyle :: CSS
resetStyle = css
  { backgroundColor: "transparent"
  , border: "1px solid #475569"
  , borderRadius: "6px"
  , color: "#94a3b8"
  , padding: "6px 16px"
  , fontSize: "12px"
  , cursor: "pointer"
  , marginTop: "12px"
  }
