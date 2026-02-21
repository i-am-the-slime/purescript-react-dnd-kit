module Test.React.DndKit.Stories.PhotoGallery.Styles where

import Yoga.React.DOM.Internal (CSS, css)

containerStyle :: CSS
containerStyle = css { maxWidth: "700px", margin: "0 auto", overflowX: "auto" }

galleryStyle :: CSS
galleryStyle = css
  { display: "flex"
  , gap: "12px"
  , padding: "16px"
  }

cardStyle :: String -> String -> CSS
cardStyle opacity cursor = css
  { display: "flex"
  , flexDirection: "column"
  , gap: "8px"
  , cursor
  , opacity
  , userSelect: "none"
  , transition: "opacity 200ms"
  , flexShrink: "0"
  }

thumbStyle :: String -> CSS
thumbStyle bg = css
  { width: "100px"
  , height: "80px"
  , backgroundColor: bg
  , borderRadius: "8px"
  , boxShadow: "0 2px 6px rgba(0,0,0,0.3)"
  }

labelStyle :: String -> CSS
labelStyle col = css
  { fontSize: "12px"
  , fontWeight: "500"
  , color: col
  , textAlign: "center"
  }
