{-# OPTIONS -Wall #-}
{-# LANGUAGE DeriveAnyClass #-}

module Raylib.Types where

import Control.Monad (forM_, unless)
import Foreign
  ( FunPtr,
    Ptr,
    Storable (alignment, peek, peekByteOff, poke, pokeByteOff, sizeOf),
    Word16,
    Word8,
    castPtr,
    fromBool,
    malloc,
    newArray,
    newForeignPtr,
    nullFunPtr,
    nullPtr,
    peekArray,
    toBool,
    withForeignPtr,
  )
import Foreign.C
  ( CBool,
    CChar,
    CFloat,
    CInt (..),
    CShort,
    CString,
    CUChar,
    CUInt,
    CUShort,
    castCharToCChar,
    newCString,
    peekCString,
  )
import Foreign.C.String (castCCharToChar)
import Raylib.Internal (c'rlGetShaderIdDefault, getPixelDataSize)
import Raylib.ForeignUtil (Freeable (rlFreeDependents), c'free, freeMaybePtr, newMaybeArray, p'free, peekMaybeArray, peekStaticArray, peekStaticArrayOff, pokeMaybeOff, pokeStaticArray, pokeStaticArrayOff, rightPad, rlFreeArray, rlFreeMaybeArray)

------------------------------------------------
-- Raylib enumerations -------------------------
------------------------------------------------

data ConfigFlag
  = VsyncHint
  | FullscreenMode
  | WindowResizable
  | WindowUndecorated
  | WindowHidden
  | WindowMinimized
  | WindowMaximized
  | WindowUnfocused
  | WindowTopmost
  | WindowAlwaysRun
  | WindowTransparent
  | WindowHighdpi
  | WindowMousePassthrough
  | Msaa4xHint
  | InterlacedHint
  deriving (Eq, Show, Freeable)

instance Enum ConfigFlag where
  fromEnum g = case g of
    VsyncHint -> 64
    FullscreenMode -> 2
    WindowResizable -> 4
    WindowUndecorated -> 8
    WindowHidden -> 128
    WindowMinimized -> 512
    WindowMaximized -> 1024
    WindowUnfocused -> 2048
    WindowTopmost -> 4096
    WindowAlwaysRun -> 256
    WindowTransparent -> 16
    WindowHighdpi -> 8192
    WindowMousePassthrough -> 16384
    Msaa4xHint -> 32
    InterlacedHint -> 65536
  toEnum x = case x of
    64 -> VsyncHint
    2 -> FullscreenMode
    4 -> WindowResizable
    8 -> WindowUndecorated
    128 -> WindowHidden
    512 -> WindowMinimized
    1024 -> WindowMaximized
    2048 -> WindowUnfocused
    4096 -> WindowTopmost
    256 -> WindowAlwaysRun
    16 -> WindowTransparent
    8192 -> WindowHighdpi
    16384 -> WindowMousePassthrough
    32 -> Msaa4xHint
    65536 -> InterlacedHint
    n -> error $ "(ConfigFlag.toEnum) Invalid value: " ++ show n

data TraceLogLevel = LogAll | LogTrace | LogDebug | LogInfo | LogWarning | LogError | LogFatal | LogNone
  deriving (Eq, Show, Enum)

data KeyboardKey
  = KeyNull
  | KeyApostrophe
  | KeyComma
  | KeyMinus
  | KeyPeriod
  | KeySlash
  | KeyZero
  | KeyOne
  | KeyTwo
  | KeyThree
  | KeyFour
  | KeyFive
  | KeySix
  | KeySeven
  | KeyEight
  | KeyNine
  | KeySemicolon
  | KeyEqual
  | KeyA
  | KeyB
  | KeyC
  | KeyD
  | KeyE
  | KeyF
  | KeyG
  | KeyH
  | KeyI
  | KeyJ
  | KeyK
  | KeyL
  | KeyM
  | KeyN
  | KeyO
  | KeyP
  | KeyQ
  | KeyR
  | KeyS
  | KeyT
  | KeyU
  | KeyV
  | KeyW
  | KeyX
  | KeyY
  | KeyZ
  | KeyLeftBracket
  | KeyBackslash
  | KeyRightBracket
  | KeyGrave
  | KeySpace
  | KeyEscape
  | KeyEnter
  | KeyTab
  | KeyBackspace
  | KeyInsert
  | KeyDelete
  | KeyRight
  | KeyLeft
  | KeyDown
  | KeyUp
  | KeyPageUp
  | KeyPageDown
  | KeyHome
  | KeyEnd
  | KeyCapsLock
  | KeyScrollLock
  | KeyNumLock
  | KeyPrintScreen
  | KeyPause
  | KeyF1
  | KeyF2
  | KeyF3
  | KeyF4
  | KeyF5
  | KeyF6
  | KeyF7
  | KeyF8
  | KeyF9
  | KeyF10
  | KeyF11
  | KeyF12
  | KeyLeftShift
  | KeyLeftControl
  | KeyLeftAlt
  | KeyLeftSuper
  | KeyRightShift
  | KeyRightControl
  | KeyRightAlt
  | KeyRightSuper
  | KeyKbMenu
  | KeyKp0
  | KeyKp1
  | KeyKp2
  | KeyKp3
  | KeyKp4
  | KeyKp5
  | KeyKp6
  | KeyKp7
  | KeyKp8
  | KeyKp9
  | KeyKpDecimal
  | KeyKpDivide
  | KeyKpMultiply
  | KeyKpSubtract
  | KeyKpAdd
  | KeyKpEnter
  | KeyKpEqual
  | KeyBack
  | KeyMenu
  | KeyVolumeUp
  | KeyVolumeDown
  deriving (Eq, Show)

instance Enum KeyboardKey where
  fromEnum k = case k of
    KeyNull -> 0
    KeyApostrophe -> 39
    KeyComma -> 44
    KeyMinus -> 45
    KeyPeriod -> 46
    KeySlash -> 47
    KeyZero -> 48
    KeyOne -> 49
    KeyTwo -> 50
    KeyThree -> 51
    KeyFour -> 52
    KeyFive -> 53
    KeySix -> 54
    KeySeven -> 55
    KeyEight -> 56
    KeyNine -> 57
    KeySemicolon -> 59
    KeyEqual -> 61
    KeyA -> 65
    KeyB -> 66
    KeyC -> 67
    KeyD -> 68
    KeyE -> 69
    KeyF -> 70
    KeyG -> 71
    KeyH -> 72
    KeyI -> 73
    KeyJ -> 74
    KeyK -> 75
    KeyL -> 76
    KeyM -> 77
    KeyN -> 78
    KeyO -> 79
    KeyP -> 80
    KeyQ -> 81
    KeyR -> 82
    KeyS -> 83
    KeyT -> 84
    KeyU -> 85
    KeyV -> 86
    KeyW -> 87
    KeyX -> 88
    KeyY -> 89
    KeyZ -> 90
    KeyLeftBracket -> 91
    KeyBackslash -> 92
    KeyRightBracket -> 93
    KeyGrave -> 96
    KeySpace -> 32
    KeyEscape -> 256
    KeyEnter -> 257
    KeyTab -> 258
    KeyBackspace -> 259
    KeyInsert -> 260
    KeyDelete -> 261
    KeyRight -> 262
    KeyLeft -> 263
    KeyDown -> 264
    KeyUp -> 265
    KeyPageUp -> 266
    KeyPageDown -> 267
    KeyHome -> 268
    KeyEnd -> 269
    KeyCapsLock -> 280
    KeyScrollLock -> 281
    KeyNumLock -> 282
    KeyPrintScreen -> 283
    KeyPause -> 284
    KeyF1 -> 290
    KeyF2 -> 291
    KeyF3 -> 292
    KeyF4 -> 293
    KeyF5 -> 294
    KeyF6 -> 295
    KeyF7 -> 296
    KeyF8 -> 297
    KeyF9 -> 298
    KeyF10 -> 299
    KeyF11 -> 300
    KeyF12 -> 301
    KeyLeftShift -> 340
    KeyLeftControl -> 341
    KeyLeftAlt -> 342
    KeyLeftSuper -> 343
    KeyRightShift -> 344
    KeyRightControl -> 345
    KeyRightAlt -> 346
    KeyRightSuper -> 347
    KeyKbMenu -> 348
    KeyKp0 -> 320
    KeyKp1 -> 321
    KeyKp2 -> 322
    KeyKp3 -> 323
    KeyKp4 -> 324
    KeyKp5 -> 325
    KeyKp6 -> 326
    KeyKp7 -> 327
    KeyKp8 -> 328
    KeyKp9 -> 329
    KeyKpDecimal -> 330
    KeyKpDivide -> 331
    KeyKpMultiply -> 332
    KeyKpSubtract -> 333
    KeyKpAdd -> 334
    KeyKpEnter -> 335
    KeyKpEqual -> 336
    -- Android buttons
    KeyBack -> 4
    KeyMenu -> 82
    KeyVolumeUp -> 24
    KeyVolumeDown -> 25

  toEnum n = case n of
    0 -> KeyNull
    39 -> KeyApostrophe
    44 -> KeyComma
    45 -> KeyMinus
    46 -> KeyPeriod
    47 -> KeySlash
    48 -> KeyZero
    49 -> KeyOne
    50 -> KeyTwo
    51 -> KeyThree
    52 -> KeyFour
    53 -> KeyFive
    54 -> KeySix
    55 -> KeySeven
    56 -> KeyEight
    57 -> KeyNine
    59 -> KeySemicolon
    61 -> KeyEqual
    65 -> KeyA
    66 -> KeyB
    67 -> KeyC
    68 -> KeyD
    69 -> KeyE
    70 -> KeyF
    71 -> KeyG
    72 -> KeyH
    73 -> KeyI
    74 -> KeyJ
    75 -> KeyK
    76 -> KeyL
    77 -> KeyM
    78 -> KeyN
    79 -> KeyO
    80 -> KeyP
    81 -> KeyQ
    82 -> KeyR
    83 -> KeyS
    84 -> KeyT
    85 -> KeyU
    86 -> KeyV
    87 -> KeyW
    88 -> KeyX
    89 -> KeyY
    90 -> KeyZ
    91 -> KeyLeftBracket
    92 -> KeyBackslash
    93 -> KeyRightBracket
    96 -> KeyGrave
    32 -> KeySpace
    256 -> KeyEscape
    257 -> KeyEnter
    258 -> KeyTab
    259 -> KeyBackspace
    260 -> KeyInsert
    261 -> KeyDelete
    262 -> KeyRight
    263 -> KeyLeft
    264 -> KeyDown
    265 -> KeyUp
    266 -> KeyPageUp
    267 -> KeyPageDown
    268 -> KeyHome
    269 -> KeyEnd
    280 -> KeyCapsLock
    281 -> KeyScrollLock
    282 -> KeyNumLock
    283 -> KeyPrintScreen
    284 -> KeyPause
    290 -> KeyF1
    291 -> KeyF2
    292 -> KeyF3
    293 -> KeyF4
    294 -> KeyF5
    295 -> KeyF6
    296 -> KeyF7
    297 -> KeyF8
    298 -> KeyF9
    299 -> KeyF10
    300 -> KeyF11
    301 -> KeyF12
    340 -> KeyLeftShift
    341 -> KeyLeftControl
    342 -> KeyLeftAlt
    343 -> KeyLeftSuper
    344 -> KeyRightShift
    345 -> KeyRightControl
    346 -> KeyRightAlt
    347 -> KeyRightSuper
    348 -> KeyKbMenu
    320 -> KeyKp0
    321 -> KeyKp1
    322 -> KeyKp2
    323 -> KeyKp3
    324 -> KeyKp4
    325 -> KeyKp5
    326 -> KeyKp6
    327 -> KeyKp7
    328 -> KeyKp8
    329 -> KeyKp9
    330 -> KeyKpDecimal
    331 -> KeyKpDivide
    332 -> KeyKpMultiply
    333 -> KeyKpSubtract
    334 -> KeyKpAdd
    335 -> KeyKpEnter
    336 -> KeyKpEqual
    -- Android buttons
    4 -> KeyBack
    --  82  -> KeyMenu
    24 -> KeyVolumeUp
    25 -> KeyVolumeDown
    x -> error $ "(KeyboardKey.toEnum) Invalid value: " ++ show x

data MouseButton
  = MouseButtonLeft
  | MouseButtonRight
  | MouseButtonMiddle
  | MouseButtonSide
  | MouseButtonExtra
  | MouseButtonForward
  | MouseButtonBack
  deriving (Eq, Show, Enum)

data MouseCursor
  = MouseCursorDefault
  | MouseCursorArrow
  | MouseCursorIbeam
  | MouseCursorCrosshair
  | MouseCursorPointingHand
  | MouseCursorResizeEW
  | MouseCursorResizeNS
  | MouseCursorResizeNWSE
  | MouseCursorResizeNESW
  | MouseCursorResizeAll
  | MouseCursorNotAllowed
  deriving (Eq, Show, Enum)

data GamepadButton
  = GamepadButtonUnknown
  | GamepadButtonUnknownLeftFaceUp
  | GamepadButtonLeftFaceRight
  | GamepadButtonLeftFaceDown
  | GamepadButtonLeftFaceLeft
  | GamepadButtonRightFaceUp
  | GamepadButtonRightFaceRight
  | GamepadButtonRightFaceDown
  | GamepadButtonRightFaceLeft
  | GamepadButtonLeftTrigger1
  | GamepadButtonLeftTrigger2
  | GamepadButtonRightTrigger1
  | GamepadButtonRightTrigger2
  | GamepadButtonMiddleLeft
  | GamepadButtonMiddle
  | GamepadButtonMiddleRight
  | GamepadButtonLeftThumb
  | GamepadButtonRightThumb
  deriving (Eq, Show, Enum)

data GamepadAxis
  = GamepadAxisLeftX
  | GamepadAxisLeftY
  | GamepadAxisRightX
  | GamepadAxisRightY
  | GamepadAxisLeftTrigger
  | GamepadAxisRightTrigger
  deriving (Eq, Show, Enum)

data MaterialMapIndex
  = MaterialMapAlbedo
  | MaterialMapMetalness
  | MaterialMapNormal
  | MaterialMapRoughness
  | MaterialMapOcclusion
  | MaterialMapEmission
  | MaterialMapHeight
  | MaterialMapCubemap
  | MaterialMapIrradiance
  | MaterialMapPrefilter
  | MaterialMapBrdf
  deriving (Eq, Show, Enum)

data ShaderLocationIndex
  = ShaderLocVertexPosition
  | ShaderLocVertexTexcoord01
  | ShaderLocVertexTexcoord02
  | ShaderLocVertexNormal
  | ShaderLocVertexTangent
  | ShaderLocVertexColor
  | ShaderLocMatrixMvp
  | ShaderLocMatrixView
  | ShaderLocMatrixProjection
  | ShaderLocMatrixModel
  | ShaderLocMatrixNormal
  | ShaderLocVectorView
  | ShaderLocColorDiffuse
  | ShaderLocColorSpecular
  | ShaderLocColorAmbient
  | ShaderLocMapAlbedo
  | ShaderLocMapMetalness
  | ShaderLocMapNormal
  | ShaderLocMapRoughness
  | ShaderLocMapOcclusion
  | ShaderLocMapEmission
  | ShaderLocMapHeight
  | ShaderLocMapCubemap
  | ShaderLocMapIrradiance
  | ShaderLocMapPrefilter
  | ShaderLocMapBrdf
  deriving (Eq, Show, Enum)

data ShaderUniformDataType
  = ShaderUniformFloatType
  | ShaderUniformVec2Type
  | ShaderUniformVec3Type
  | ShaderUniformVec4Type
  | ShaderUniformIntType
  | ShaderUniformIVec2Type
  | ShaderUniformIVec3Type
  | ShaderUniformIVec4Type
  | ShaderUniformSampler2DType
  deriving (Eq, Show, Enum)

data ShaderUniformData
  = ShaderUniformFloat Float
  | ShaderUniformVec2 Vector2
  | ShaderUniformVec3 Vector3
  | ShaderUniformVec4 Vector4
  | ShaderUniformInt Int
  | ShaderUniformIVec2 (Int, Int)
  | ShaderUniformIVec3 (Int, Int, Int)
  | ShaderUniformIVec4 (Int, Int, Int, Int)
  | ShaderUniformSampler2D Integer -- I believe this takes a texture ID as the argument
  deriving (Eq, Show)

data ShaderUniformDataV
  = ShaderUniformFloatV [Float]
  | ShaderUniformVec2V [Vector2]
  | ShaderUniformVec3V [Vector3]
  | ShaderUniformVec4V [Vector4]
  | ShaderUniformIntV [Int]
  | ShaderUniformIVec2V [(Int, Int)]
  | ShaderUniformIVec3V [(Int, Int, Int)]
  | ShaderUniformIVec4V [(Int, Int, Int, Int)]
  | ShaderUniformSampler2DV [Integer]
  deriving (Eq, Show)

-- I don't know if there's a cleaner way to do this
unpackShaderUniformData :: ShaderUniformData -> IO (ShaderUniformDataType, Ptr ())
unpackShaderUniformData x = do
  case x of
    (ShaderUniformFloat f) ->
      do
        ptr <- malloc
        poke ptr (realToFrac f :: CFloat)
        return (ShaderUniformFloatType, castPtr ptr)
    (ShaderUniformVec2 v) ->
      do
        ptr <- newArray (map realToFrac (asList v) :: [CFloat])
        return (ShaderUniformVec2Type, castPtr ptr)
    (ShaderUniformVec3 v) ->
      do
        ptr <- newArray (map realToFrac (asList v) :: [CFloat])
        return (ShaderUniformVec3Type, castPtr ptr)
    (ShaderUniformVec4 v) ->
      do
        ptr <- newArray (map realToFrac (asList v) :: [CFloat])
        return (ShaderUniformVec4Type, castPtr ptr)
    (ShaderUniformInt i) ->
      do
        ptr <- malloc
        poke ptr (fromIntegral i :: CInt)
        return (ShaderUniformIntType, castPtr ptr)
    (ShaderUniformIVec2 (i1, i2)) ->
      do
        ptr <- newArray (map fromIntegral [i1, i2] :: [CInt])
        return (ShaderUniformIVec2Type, castPtr ptr)
    (ShaderUniformIVec3 (i1, i2, i3)) ->
      do
        ptr <- newArray (map fromIntegral [i1, i2, i3] :: [CInt])
        return (ShaderUniformIVec3Type, castPtr ptr)
    (ShaderUniformIVec4 (i1, i2, i3, i4)) ->
      do
        ptr <- newArray (map fromIntegral [i1, i2, i3, i4] :: [CInt])
        return (ShaderUniformIVec4Type, castPtr ptr)
    (ShaderUniformSampler2D sId) ->
      do
        ptr <- malloc
        poke ptr (fromIntegral sId :: CInt)
        return (ShaderUniformSampler2DType, castPtr ptr)

unpackShaderUniformDataV :: ShaderUniformDataV -> IO (ShaderUniformDataType, Ptr (), Int)
unpackShaderUniformDataV xs = do
  case xs of
    (ShaderUniformFloatV fs) ->
      do
        ptr <- newArray (map realToFrac fs :: [CFloat])
        return (ShaderUniformFloatType, castPtr ptr, length fs)
    (ShaderUniformVec2V vs) ->
      do
        ptr <- newArray (map realToFrac $ concatMap asList vs :: [CFloat])
        return (ShaderUniformVec2Type, castPtr ptr, length vs)
    (ShaderUniformVec3V vs) ->
      do
        ptr <- newArray (map realToFrac $ concatMap asList vs :: [CFloat])
        return (ShaderUniformVec3Type, castPtr ptr, length vs)
    (ShaderUniformVec4V vs) ->
      do
        ptr <- newArray (map realToFrac $ concatMap asList vs :: [CFloat])
        return (ShaderUniformVec4Type, castPtr ptr, length vs)
    (ShaderUniformIntV is) ->
      do
        ptr <- newArray (map fromIntegral is :: [CInt])
        return (ShaderUniformIntType, castPtr ptr, length is)
    (ShaderUniformIVec2V is) ->
      do
        ptr <- newArray (map fromIntegral $ concatMap (\(x, y) -> [x, y]) is :: [CInt])
        return (ShaderUniformIVec2Type, castPtr ptr, length is)
    (ShaderUniformIVec3V is) ->
      do
        ptr <- newArray (map fromIntegral $ concatMap (\(x, y, z) -> [x, y, z]) is :: [CInt])
        return (ShaderUniformIVec3Type, castPtr ptr, length is)
    (ShaderUniformIVec4V is) ->
      do
        ptr <- newArray (map fromIntegral $ concatMap (\(x, y, z, w) -> [x, y, z, w]) is :: [CInt])
        return (ShaderUniformIVec4Type, castPtr ptr, length is)
    (ShaderUniformSampler2DV sIds) ->
      do
        ptr <- newArray (map fromIntegral sIds :: [CInt])
        return (ShaderUniformSampler2DType, castPtr ptr, length sIds)

-- I genuinely have no idea where this is used.
data ShaderAttributeDataType
  = ShaderAttribFloat
  | ShaderAttribVec2
  | ShaderAttribVec3
  | ShaderAttribVec4
  deriving (Eq, Show, Enum)

data PixelFormat
  = PixelFormatUnset
  | PixelFormatUncompressedGrayscale
  | PixelFormatUncompressedGrayAlpha
  | PixelFormatUncompressedR5G6B5
  | PixelFormatUncompressedR8G8B8
  | PixelFormatUncompressedR5G5B5A1
  | PixelFormatUncompressedR4G4B4A4
  | PixelFormatUncompressedR8G8B8A8
  | PixelFormatUncompressedR32
  | PixelFormatUncompressedR32G32B32
  | PixelFormatUncompressedR32G32B32A32
  | PixelFormatCompressedDxt1Rgb
  | PixelFormatCompressedDxt1Rgba
  | PixelFormatCompressedDxt3Rgba
  | PixelFormatCompressedDxt5Rgba
  | PixelFormatCompressedEtc1Rgb
  | PixelFormatCompressedEtc2Rgb
  | PixelFormatCompressedEtc2EacRgba
  | PixelFormatCompressedPvrtRgb
  | PixelFormatCompressedPvrtRgba
  | PixelFormatCompressedAstc4x4Rgba
  | PixelFormatCompressedAstc8x8Rgba
  deriving (Eq, Show)

instance Storable PixelFormat where
  sizeOf _ = 4
  alignment _ = 4
  peek ptr = do
    val <- peek (castPtr ptr :: Ptr CInt)
    return (toEnum $ fromIntegral val)
  poke ptr v = do
    poke (castPtr ptr) (fromIntegral (fromEnum v) :: CInt)

instance Enum PixelFormat where
  fromEnum n = case n of
    PixelFormatUnset -> 0
    PixelFormatUncompressedGrayscale -> 1
    PixelFormatUncompressedGrayAlpha -> 2
    PixelFormatUncompressedR5G6B5 -> 3
    PixelFormatUncompressedR8G8B8 -> 4
    PixelFormatUncompressedR5G5B5A1 -> 5
    PixelFormatUncompressedR4G4B4A4 -> 6
    PixelFormatUncompressedR8G8B8A8 -> 7
    PixelFormatUncompressedR32 -> 8
    PixelFormatUncompressedR32G32B32 -> 9
    PixelFormatUncompressedR32G32B32A32 -> 10
    PixelFormatCompressedDxt1Rgb -> 11
    PixelFormatCompressedDxt1Rgba -> 12
    PixelFormatCompressedDxt3Rgba -> 13
    PixelFormatCompressedDxt5Rgba -> 14
    PixelFormatCompressedEtc1Rgb -> 15
    PixelFormatCompressedEtc2Rgb -> 16
    PixelFormatCompressedEtc2EacRgba -> 17
    PixelFormatCompressedPvrtRgb -> 18
    PixelFormatCompressedPvrtRgba -> 19
    PixelFormatCompressedAstc4x4Rgba -> 20
    PixelFormatCompressedAstc8x8Rgba -> 21

  toEnum n = case n of
    0 -> PixelFormatUnset
    1 -> PixelFormatUncompressedGrayscale
    2 -> PixelFormatUncompressedGrayAlpha
    3 -> PixelFormatUncompressedR5G6B5
    4 -> PixelFormatUncompressedR8G8B8
    5 -> PixelFormatUncompressedR5G5B5A1
    6 -> PixelFormatUncompressedR4G4B4A4
    7 -> PixelFormatUncompressedR8G8B8A8
    8 -> PixelFormatUncompressedR32
    9 -> PixelFormatUncompressedR32G32B32
    10 -> PixelFormatUncompressedR32G32B32A32
    11 -> PixelFormatCompressedDxt1Rgb
    12 -> PixelFormatCompressedDxt1Rgba
    13 -> PixelFormatCompressedDxt3Rgba
    14 -> PixelFormatCompressedDxt5Rgba
    15 -> PixelFormatCompressedEtc1Rgb
    16 -> PixelFormatCompressedEtc2Rgb
    17 -> PixelFormatCompressedEtc2EacRgba
    18 -> PixelFormatCompressedPvrtRgb
    19 -> PixelFormatCompressedPvrtRgba
    20 -> PixelFormatCompressedAstc4x4Rgba
    21 -> PixelFormatCompressedAstc8x8Rgba
    _ -> error $ "(PixelFormat.toEnum) Invalid value: " ++ show n

data TextureFilter
  = TextureFilterPoint
  | TextureFilterBilinear
  | TextureFilterTrilinear
  | TextureFilterAnisotropic4x
  | TextureFilterAnisotropic8x
  | TextureFilterAnisotropic16x
  deriving (Enum)

data TextureWrap
  = TextureWrapRepeat
  | TextureWrapClamp
  | TextureWrapMirrorRepeat
  | TextureWrapMirrorClamp
  deriving (Enum)

data CubemapLayout
  = CubemapLayoutAutoDetect
  | CubemapLayoutLineVertical
  | CubemapLayoutLineHorizontal
  | CubemapLayoutCrossThreeByFour
  | CubemapLayoutCrossThreeByThree
  | CubemapLayoutPanorama
  deriving (Enum)

data FontType = FontDefault | FontBitmap | FontSDF deriving (Enum)

data BlendMode
  = BlendAlpha
  | BlendAdditive
  | BlendMultiplied
  | BlendAddColors
  | BlendSubtractColors
  | BlendAlphaPremultiply
  | BlendCustom
  | BlendCustomSeparate
  deriving (Enum)

data Gesture
  = GestureNone
  | GestureTap
  | GestureDoubleTap
  | GestureHold
  | GestureDrag
  | GestureSwipeRight
  | GestureSwipeLeft
  | GestureSwipeUp
  | GestureSwipeDown
  | GesturePinchIn
  | GesturePinchOut
  deriving (Show)

-- NOTE: This is not the ideal solution, I need to make this unjanky
instance Enum Gesture where
  fromEnum n = case n of
    GestureNone -> 0
    GestureTap -> 1
    GestureDoubleTap -> 2
    GestureHold -> 4
    GestureDrag -> 8
    GestureSwipeRight -> 16
    GestureSwipeLeft -> 32
    GestureSwipeUp -> 64
    GestureSwipeDown -> 128
    GesturePinchIn -> 256
    GesturePinchOut -> 512
  toEnum n = case n of
    0 -> GestureNone
    1 -> GestureTap
    2 -> GestureDoubleTap
    4 -> GestureHold
    8 -> GestureDrag
    16 -> GestureSwipeRight
    32 -> GestureSwipeLeft
    64 -> GestureSwipeUp
    128 -> GestureSwipeDown
    256 -> GesturePinchIn
    512 -> GesturePinchOut
    _ -> error $ "(Gesture.toEnum) Invalid value: " ++ show n

data CameraMode
  = CameraModeCustom
  | CameraModeFree
  | CameraModeOrbital
  | CameraModeFirstPerson
  | CameraModeThirdPerson
  deriving (Enum)

data CameraProjection = CameraPerspective | CameraOrthographic deriving (Eq, Show, Enum)

instance Storable CameraProjection where
  sizeOf _ = 4
  alignment _ = 4
  peek ptr = do
    val <- peek (castPtr ptr)
    return (toEnum $ fromEnum (val :: CInt))
  poke ptr v = poke (castPtr ptr) (fromIntegral (fromEnum v) :: CInt)

data NPatchLayout = NPatchNinePatch | NPatchThreePatchVertical | NPatchThreePatchHorizontal deriving (Eq, Show, Enum)

instance Storable NPatchLayout where
  sizeOf _ = 4
  alignment _ = 4
  peek ptr = do
    val <- peek (castPtr ptr)
    return $ toEnum $ fromEnum (val :: CInt)
  poke ptr v = poke (castPtr ptr) (fromIntegral (fromEnum v) :: CInt)

data MusicContextType
  = MusicAudioNone
  | MusicAudioWAV
  | MusicAudioOGG
  | MusicAudioFLAC
  | MusicAudioMP3
  | MusicAudioQOA
  | MusicModuleXM
  | MusicModuleMOD
  deriving (Eq, Show, Enum)

instance Storable MusicContextType where
  sizeOf _ = 4
  alignment _ = 4
  peek ptr = do
    val <- peek (castPtr ptr)
    return $ toEnum $ fromEnum (val :: CInt)
  poke ptr v = poke (castPtr ptr) (fromIntegral (fromEnum v) :: CInt)

------------------------------------------------
-- Raylib typeclasses --------------------------
------------------------------------------------

class Vector a where
  -- List representation of the vector
  asList :: a -> [Float]

  -- Vector-vector addition
  (|+|) :: a -> a -> a

  -- Vector-vector subtraction
  (|-|) :: a -> a -> a
  v1 |-| v2 = v1 |+| inverse v2

  -- Vector-scalar multiplication
  (|*|) :: a -> Float -> a

  -- Vector-scalar division
  (|/|) :: a -> Float -> a
  v |/| num = v |*| (1 / num)

  -- Vector-vector dot product
  (|.|) :: a -> a -> Float

  -- Zero vector
  zero :: a

  -- Vector additive inverse
  inverse :: a -> a

  -- Normalize vector (same direction, magnitude 1)
  normalize :: a -> a
  normalize v = v |/| magnitude v

  -- Vector magnitude
  magnitude :: a -> Float
  magnitude x = sqrt $ x |.| x

------------------------------------------------
-- Raylib structures ---------------------------
------------------------------------------------

data Vector2 = Vector2
  { vector2'x :: Float,
    vector2'y :: Float
  }
  deriving (Eq, Show, Freeable)

instance Storable Vector2 where
  sizeOf _ = 8
  alignment _ = 4
  peek _p = do
    x <- realToFrac <$> (peekByteOff _p 0 :: IO CFloat)
    y <- realToFrac <$> (peekByteOff _p 4 :: IO CFloat)
    return $ Vector2 x y
  poke _p (Vector2 x y) = do
    pokeByteOff _p 0 (realToFrac x :: CFloat)
    pokeByteOff _p 4 (realToFrac y :: CFloat)
    return ()

instance Vector Vector2 where
  asList (Vector2 x y) = [x, y]

  (Vector2 x1 y1) |+| (Vector2 x2 y2) = Vector2 (x1 + x2) (y1 + y2)
  (Vector2 x y) |*| num = Vector2 (x * num) (y * num)

  (Vector2 x1 y1) |.| (Vector2 x2 y2) = (x1 * x2) + (y1 * y2)

  zero = Vector2 0 0
  inverse (Vector2 x y) = Vector2 (- x) (- y)

data Vector3 = Vector3
  { vector3'x :: Float,
    vector3'y :: Float,
    vector3'z :: Float
  }
  deriving (Eq, Show, Freeable)

instance Storable Vector3 where
  sizeOf _ = 12
  alignment _ = 4
  peek _p = do
    x <- realToFrac <$> (peekByteOff _p 0 :: IO CFloat)
    y <- realToFrac <$> (peekByteOff _p 4 :: IO CFloat)
    z <- realToFrac <$> (peekByteOff _p 8 :: IO CFloat)
    return $ Vector3 x y z
  poke _p (Vector3 x y z) = do
    pokeByteOff _p 0 (realToFrac x :: CFloat)
    pokeByteOff _p 4 (realToFrac y :: CFloat)
    pokeByteOff _p 8 (realToFrac z :: CFloat)
    return ()

-- Vector cross-product
cross :: Vector3 -> Vector3 -> Vector3
(Vector3 x1 y1 z1) `cross` (Vector3 x2 y2 z2) = Vector3 (y1 * z2 - z1 * y2) (z1 * x2 - x1 * z2) (x1 * y2 - y1 * x2)

instance Vector Vector3 where
  asList (Vector3 x y z) = [x, y, z]

  (Vector3 x1 y1 z1) |+| (Vector3 x2 y2 z2) = Vector3 (x1 + x2) (y1 + y2) (z1 + z2)
  (Vector3 x y z) |*| num = Vector3 (x * num) (y * num) (z * num)

  (Vector3 x1 y1 z1) |.| (Vector3 x2 y2 z2) = (x1 * x2) + (y1 * y2) + (z1 * z2)

  zero = Vector3 0 0 0
  inverse (Vector3 x y z) = Vector3 (- x) (- y) (- z)

data Vector4 = Vector4
  { vector4'x :: Float,
    vector4'y :: Float,
    vector4'z :: Float,
    vector4'w :: Float
  }
  deriving (Eq, Show, Freeable)

instance Storable Vector4 where
  sizeOf _ = 16
  alignment _ = 4
  peek _p = do
    x <- realToFrac <$> (peekByteOff _p 0 :: IO CFloat)
    y <- realToFrac <$> (peekByteOff _p 4 :: IO CFloat)
    z <- realToFrac <$> (peekByteOff _p 8 :: IO CFloat)
    w <- realToFrac <$> (peekByteOff _p 12 :: IO CFloat)
    return $ Vector4 x y z w
  poke _p (Vector4 x y z w) = do
    pokeByteOff _p 0 (realToFrac x :: CFloat)
    pokeByteOff _p 4 (realToFrac y :: CFloat)
    pokeByteOff _p 8 (realToFrac z :: CFloat)
    pokeByteOff _p 12 (realToFrac w :: CFloat)
    return ()

instance Vector Vector4 where
  asList (Vector4 x y z w) = [x, y, z, w]

  (Vector4 x1 y1 z1 w1) |+| (Vector4 x2 y2 z2 w2) = Vector4 (x1 + x2) (y1 + y2) (z1 + z2) (w1 + w2)
  (Vector4 x y z w) |*| num = Vector4 (x * num) (y * num) (z * num) (w * num)

  (Vector4 x1 y1 z1 w1) |.| (Vector4 x2 y2 z2 w2) = (x1 * x2) + (y1 * y2) + (z1 * z2) + (w1 * w2)

  zero = Vector4 0 0 0 0
  inverse (Vector4 x y z w) = Vector4 (- x) (- y) (- z) (- w)

type Quaternion = Vector4

data Matrix = Matrix
  { matrix'm0 :: Float,
    matrix'm4 :: Float,
    matrix'm8 :: Float,
    matrix'm12 :: Float,
    matrix'm1 :: Float,
    matrix'm5 :: Float,
    matrix'm9 :: Float,
    matrix'm13 :: Float,
    matrix'm2 :: Float,
    matrix'm6 :: Float,
    matrix'm10 :: Float,
    matrix'm14 :: Float,
    matrix'm3 :: Float,
    matrix'm7 :: Float,
    matrix'm11 :: Float,
    matrix'm15 :: Float
  }
  deriving (Eq, Show, Freeable)

instance Storable Matrix where
  sizeOf _ = 64
  alignment _ = 4
  peek _p = do
    m0 <- realToFrac <$> (peekByteOff _p 0 :: IO CFloat)
    m4 <- realToFrac <$> (peekByteOff _p 4 :: IO CFloat)
    m8 <- realToFrac <$> (peekByteOff _p 8 :: IO CFloat)
    m12 <- realToFrac <$> (peekByteOff _p 12 :: IO CFloat)
    m1 <- realToFrac <$> (peekByteOff _p 16 :: IO CFloat)
    m5 <- realToFrac <$> (peekByteOff _p 20 :: IO CFloat)
    m9 <- realToFrac <$> (peekByteOff _p 24 :: IO CFloat)
    m13 <- realToFrac <$> (peekByteOff _p 28 :: IO CFloat)
    m2 <- realToFrac <$> (peekByteOff _p 32 :: IO CFloat)
    m6 <- realToFrac <$> (peekByteOff _p 36 :: IO CFloat)
    m10 <- realToFrac <$> (peekByteOff _p 40 :: IO CFloat)
    m14 <- realToFrac <$> (peekByteOff _p 44 :: IO CFloat)
    m3 <- realToFrac <$> (peekByteOff _p 48 :: IO CFloat)
    m7 <- realToFrac <$> (peekByteOff _p 52 :: IO CFloat)
    m11 <- realToFrac <$> (peekByteOff _p 56 :: IO CFloat)
    m15 <- realToFrac <$> (peekByteOff _p 60 :: IO CFloat)
    return $ Matrix m0 m4 m8 m12 m1 m5 m9 m13 m2 m6 m10 m14 m3 m7 m11 m15
  poke _p (Matrix m0 m4 m8 m12 m1 m5 m9 m13 m2 m6 m10 m14 m3 m7 m11 m15) = do
    pokeByteOff _p 0 (realToFrac m0 :: CFloat)
    pokeByteOff _p 4 (realToFrac m4 :: CFloat)
    pokeByteOff _p 8 (realToFrac m8 :: CFloat)
    pokeByteOff _p 12 (realToFrac m12 :: CFloat)
    pokeByteOff _p 16 (realToFrac m1 :: CFloat)
    pokeByteOff _p 20 (realToFrac m5 :: CFloat)
    pokeByteOff _p 24 (realToFrac m9 :: CFloat)
    pokeByteOff _p 28 (realToFrac m13 :: CFloat)
    pokeByteOff _p 32 (realToFrac m2 :: CFloat)
    pokeByteOff _p 36 (realToFrac m6 :: CFloat)
    pokeByteOff _p 40 (realToFrac m10 :: CFloat)
    pokeByteOff _p 44 (realToFrac m14 :: CFloat)
    pokeByteOff _p 48 (realToFrac m3 :: CFloat)
    pokeByteOff _p 52 (realToFrac m7 :: CFloat)
    pokeByteOff _p 56 (realToFrac m11 :: CFloat)
    pokeByteOff _p 60 (realToFrac m15 :: CFloat)
    return ()

vectorToColor :: Vector4 -> Color
vectorToColor (Vector4 x y z w) = Color (round $ x * 255) (round $ y * 255) (round $ z * 255) (round $ w * 255)

data Color = Color
  { color'r :: Word8,
    color'g :: Word8,
    color'b :: Word8,
    color'a :: Word8
  }
  deriving (Eq, Show, Freeable)

instance Storable Color where
  sizeOf _ = 4
  alignment _ = 1
  peek _p = do
    r <- fromIntegral <$> (peekByteOff _p 0 :: IO CUChar)
    g <- fromIntegral <$> (peekByteOff _p 1 :: IO CUChar)
    b <- fromIntegral <$> (peekByteOff _p 2 :: IO CUChar)
    a <- fromIntegral <$> (peekByteOff _p 3 :: IO CUChar)
    return $ Color r g b a
  poke _p (Color r g b a) = do
    pokeByteOff _p 0 (fromIntegral r :: CUChar)
    pokeByteOff _p 1 (fromIntegral g :: CUChar)
    pokeByteOff _p 2 (fromIntegral b :: CUChar)
    pokeByteOff _p 3 (fromIntegral a :: CUChar)
    return ()

data Rectangle = Rectangle
  { rectangle'x :: Float,
    rectangle'y :: Float,
    rectangle'width :: Float,
    rectangle'height :: Float
  }
  deriving (Eq, Show, Freeable)

instance Storable Rectangle where
  sizeOf _ = 16
  alignment _ = 4
  peek _p = do
    x <- realToFrac <$> (peekByteOff _p 0 :: IO CFloat)
    y <- realToFrac <$> (peekByteOff _p 4 :: IO CFloat)
    width <- realToFrac <$> (peekByteOff _p 8 :: IO CFloat)
    height <- realToFrac <$> (peekByteOff _p 12 :: IO CFloat)
    return $ Rectangle x y width height
  poke _p (Rectangle x y width height) = do
    pokeByteOff _p 0 (realToFrac x :: CFloat)
    pokeByteOff _p 4 (realToFrac y :: CFloat)
    pokeByteOff _p 8 (realToFrac width :: CFloat)
    pokeByteOff _p 12 (realToFrac height :: CFloat)
    return ()

data Image = Image
  { image'data :: [Word8],
    image'width :: Int,
    image'height :: Int,
    image'mipmaps :: Int,
    image'format :: PixelFormat
  }
  deriving (Eq, Show)

instance Storable Image where
  sizeOf _ = 24
  alignment _ = 4
  peek _p = do
    width <- fromIntegral <$> (peekByteOff _p 8 :: IO CInt)
    height <- fromIntegral <$> (peekByteOff _p 12 :: IO CInt)
    mipmaps <- fromIntegral <$> (peekByteOff _p 16 :: IO CInt)
    format <- peekByteOff _p 20
    ptr <- (peekByteOff _p 0 :: IO (Ptr CUChar))
    arr <- peekArray (getPixelDataSize width height (fromEnum format)) ptr
    return $ Image (map fromIntegral arr) width height mipmaps format
  poke _p (Image arr width height mipmaps format) = do
    pokeByteOff _p 0 =<< newArray (map fromIntegral arr :: [CUChar])
    pokeByteOff _p 8 (fromIntegral width :: CInt)
    pokeByteOff _p 12 (fromIntegral height :: CInt)
    pokeByteOff _p 16 (fromIntegral mipmaps :: CInt)
    pokeByteOff _p 20 format
    return ()

instance Freeable Image where
  rlFreeDependents _ ptr = do
    dataPtr <- (peekByteOff ptr 0 :: IO (Ptr CUChar))
    c'free $ castPtr dataPtr

data Texture = Texture
  { texture'id :: Integer,
    texture'width :: Int,
    texture'height :: Int,
    texture'mipmaps :: Int,
    texture'format :: PixelFormat
  }
  deriving (Eq, Show, Freeable)

instance Storable Texture where
  sizeOf _ = 20
  alignment _ = 4
  peek _p = do
    tId <- fromIntegral <$> (peekByteOff _p 0 :: IO CUInt)
    width <- fromIntegral <$> (peekByteOff _p 4 :: IO CInt)
    height <- fromIntegral <$> (peekByteOff _p 8 :: IO CInt)
    mipmaps <- fromIntegral <$> (peekByteOff _p 12 :: IO CInt)
    format <- peekByteOff _p 16
    return $ Texture tId width height mipmaps format
  poke _p (Texture tId width height mipmaps format) = do
    pokeByteOff _p 0 (fromIntegral tId :: CUInt)
    pokeByteOff _p 4 (fromIntegral width :: CInt)
    pokeByteOff _p 8 (fromIntegral height :: CInt)
    pokeByteOff _p 12 (fromIntegral mipmaps :: CInt)
    pokeByteOff _p 16 format
    return ()

type Texture2D = Texture

type TextureCubemap = Texture

data RenderTexture = RenderTexture
  { renderTexture'id :: Integer,
    renderTexture'texture :: Texture,
    renderTexture'depth :: Texture
  }
  deriving (Eq, Show, Freeable)

instance Storable RenderTexture where
  sizeOf _ = 44
  alignment _ = 4
  peek _p = do
    rtId <- fromIntegral <$> (peekByteOff _p 0 :: IO CUInt)
    texture <- peekByteOff _p 4
    depth <- peekByteOff _p 24
    return $ RenderTexture rtId texture depth
  poke _p (RenderTexture rtId texture depth) = do
    pokeByteOff _p 0 (fromIntegral rtId :: CUInt)
    pokeByteOff _p 4 texture
    pokeByteOff _p 24 depth
    return ()

type RenderTexture2D = RenderTexture

data NPatchInfo = NPatchInfo
  { nPatchInfo'source :: Rectangle,
    nPatchInfo'left :: Int,
    nPatchInfo'top :: Int,
    nPatchInfo'right :: Int,
    nPatchInfo'bottom :: Int,
    nPatchInfo'layout :: NPatchLayout
  }
  deriving (Eq, Show, Freeable)

instance Storable NPatchInfo where
  sizeOf _ = 36
  alignment _ = 4
  peek _p = do
    source <- peekByteOff _p 0
    left <- fromIntegral <$> (peekByteOff _p 16 :: IO CInt)
    top <- fromIntegral <$> (peekByteOff _p 20 :: IO CInt)
    right <- fromIntegral <$> (peekByteOff _p 24 :: IO CInt)
    bottom <- fromIntegral <$> (peekByteOff _p 28 :: IO CInt)
    layout <- peekByteOff _p 32
    return $ NPatchInfo source left right top bottom layout
  poke _p (NPatchInfo source left right top bottom layout) = do
    pokeByteOff _p 0 source
    pokeByteOff _p 16 (fromIntegral left :: CInt)
    pokeByteOff _p 20 (fromIntegral right :: CInt)
    pokeByteOff _p 24 (fromIntegral top :: CInt)
    pokeByteOff _p 28 (fromIntegral bottom :: CInt)
    pokeByteOff _p 32 layout
    return ()

data GlyphInfo = GlyphInfo
  { glyphInfo'value :: Int,
    glyphInfo'offsetX :: Int,
    glyphInfo'offsetY :: Int,
    glyphInfo'advanceX :: Int,
    glyphInfo'image :: Image
  }
  deriving (Eq, Show)

instance Storable GlyphInfo where
  sizeOf _ = 40
  alignment _ = 4
  peek _p = do
    value <- fromIntegral <$> (peekByteOff _p 0 :: IO CInt)
    offsetX <- fromIntegral <$> (peekByteOff _p 4 :: IO CInt)
    offsetY <- fromIntegral <$> (peekByteOff _p 8 :: IO CInt)
    advanceX <- fromIntegral <$> (peekByteOff _p 12 :: IO CInt)
    image <- peekByteOff _p 16
    return $ GlyphInfo value offsetX offsetY advanceX image
  poke _p (GlyphInfo value offsetX offsetY advanceX image) = do
    pokeByteOff _p 0 (fromIntegral value :: CInt)
    pokeByteOff _p 4 (fromIntegral offsetX :: CInt)
    pokeByteOff _p 8 (fromIntegral offsetY :: CInt)
    pokeByteOff _p 12 (fromIntegral advanceX :: CInt)
    pokeByteOff _p 16 image
    return ()

instance Freeable GlyphInfo where
  rlFreeDependents _ ptr = do
    dataPtr <- (peekByteOff ptr 16 :: IO (Ptr CUChar))
    c'free $ castPtr dataPtr

data Font = Font
  { font'baseSize :: Int,
    font'glyphCount :: Int,
    font'glyphPadding :: Int,
    font'texture :: Texture,
    font'recs :: [Rectangle],
    font'glyphs :: [GlyphInfo]
  }
  deriving (Eq, Show)

instance Storable Font where
  sizeOf _ = 48
  alignment _ = 4
  peek _p = do
    baseSize <- fromIntegral <$> (peekByteOff _p 0 :: IO CInt)
    glyphCount <- fromIntegral <$> (peekByteOff _p 4 :: IO CInt)
    glyphPadding <- fromIntegral <$> (peekByteOff _p 8 :: IO CInt)
    texture <- peekByteOff _p 12
    recPtr <- (peekByteOff _p 32 :: IO (Ptr Rectangle))
    recs <- peekArray glyphCount recPtr
    glyphPtr <- (peekByteOff _p 40 :: IO (Ptr GlyphInfo))
    glyphs <- peekArray glyphCount glyphPtr
    return $ Font baseSize glyphCount glyphPadding texture recs glyphs
  poke _p (Font baseSize glyphCount glyphPadding texture recs glyphs) = do
    pokeByteOff _p 0 (fromIntegral baseSize :: CInt)
    pokeByteOff _p 4 (fromIntegral glyphCount :: CInt)
    pokeByteOff _p 8 (fromIntegral glyphPadding :: CInt)
    pokeByteOff _p 12 texture
    pokeByteOff _p 32 =<< newArray recs
    pokeByteOff _p 40 =<< newArray glyphs
    return ()

instance Freeable Font where
  rlFreeDependents val ptr = do
    recsPtr <- (peekByteOff ptr 32 :: IO (Ptr Rectangle))
    c'free $ castPtr recsPtr
    glyphsPtr <- (peekByteOff ptr 40 :: IO (Ptr GlyphInfo))
    rlFreeArray (font'glyphs val) glyphsPtr

data Camera3D = Camera3D
  { camera3D'position :: Vector3,
    camera3D'target :: Vector3,
    camera3D'up :: Vector3,
    camera3D'fovy :: Float,
    camera3D'projection :: CameraProjection
  }
  deriving (Eq, Show, Freeable)

instance Storable Camera3D where
  sizeOf _ = 44
  alignment _ = 4
  peek _p = do
    position <- peekByteOff _p 0
    target <- peekByteOff _p 12
    up <- peekByteOff _p 24
    fovy <- realToFrac <$> (peekByteOff _p 36 :: IO CFloat)
    projection <- peekByteOff _p 40
    return $ Camera3D position target up fovy projection
  poke _p (Camera3D position target up fovy projection) = do
    pokeByteOff _p 0 position
    pokeByteOff _p 12 target
    pokeByteOff _p 24 up
    pokeByteOff _p 36 (realToFrac fovy :: CFloat)
    pokeByteOff _p 40 projection
    return ()

type Camera = Camera3D

data Camera2D = Camera2D
  { camera2D'offset :: Vector2,
    camera2D'target :: Vector2,
    camera2D'rotation :: Float,
    camera2D'zoom :: Float
  }
  deriving (Eq, Show, Freeable)

instance Storable Camera2D where
  sizeOf _ = 24
  alignment _ = 4
  peek _p = do
    offset <- peekByteOff _p 0
    target <- peekByteOff _p 8
    rotation <- realToFrac <$> (peekByteOff _p 16 :: IO CFloat)
    zoom <- realToFrac <$> (peekByteOff _p 20 :: IO CFloat)
    return $ Camera2D offset target rotation zoom
  poke _p (Camera2D offset target rotation zoom) = do
    pokeByteOff _p 0 offset
    pokeByteOff _p 8 target
    pokeByteOff _p 16 (realToFrac rotation :: CFloat)
    pokeByteOff _p 20 (realToFrac zoom :: CFloat)
    return ()

data Mesh = Mesh
  { mesh'vertexCount :: Int,
    mesh'triangleCount :: Int,
    mesh'vertices :: [Vector3],
    mesh'texcoords :: [Vector2],
    mesh'texcoords2 :: Maybe [Vector2],
    mesh'normals :: [Vector3],
    mesh'tangents :: Maybe [Vector4],
    mesh'colors :: Maybe [Color],
    mesh'indices :: Maybe [Word16],
    mesh'animVertices :: Maybe [Vector3],
    mesh'animNormals :: Maybe [Vector3],
    mesh'boneIds :: Maybe [Word8],
    mesh'boneWeights :: Maybe [Float],
    mesh'vaoId :: Integer,
    mesh'vboId :: Maybe [Integer]
  }
  deriving (Eq, Show)

instance Storable Mesh where
  sizeOf _ = 112
  alignment _ = 8
  peek _p = do
    vertexCount <- fromIntegral <$> (peekByteOff _p 0 :: IO CInt)
    triangleCount <- fromIntegral <$> (peekByteOff _p 4 :: IO CInt)
    verticesPtr <- (peekByteOff _p 8 :: IO (Ptr Vector3))
    vertices <- peekArray vertexCount verticesPtr
    texcoordsPtr <- (peekByteOff _p 16 :: IO (Ptr Vector2))
    texcoords <- peekArray vertexCount texcoordsPtr
    texcoords2Ptr <- (peekByteOff _p 24 :: IO (Ptr Vector2))
    texcoords2 <- peekMaybeArray vertexCount texcoords2Ptr
    normalsPtr <- (peekByteOff _p 32 :: IO (Ptr Vector3))
    normals <- peekArray vertexCount normalsPtr
    tangentsPtr <- (peekByteOff _p 40 :: IO (Ptr Vector4))
    tangents <- peekMaybeArray vertexCount tangentsPtr
    colorsPtr <- (peekByteOff _p 48 :: IO (Ptr Color))
    colors <- peekMaybeArray vertexCount colorsPtr
    indicesPtr <- (peekByteOff _p 56 :: IO (Ptr CUShort))
    indices <- (\m -> map fromIntegral <$> m) <$> peekMaybeArray vertexCount indicesPtr
    animVerticesPtr <- (peekByteOff _p 64 :: IO (Ptr Vector3))
    animVertices <- peekMaybeArray vertexCount animVerticesPtr
    animNormalsPtr <- (peekByteOff _p 72 :: IO (Ptr Vector3))
    animNormals <- peekMaybeArray vertexCount animNormalsPtr
    boneIdsPtr <- (peekByteOff _p 80 :: IO (Ptr CUChar))
    boneIds <- (\m -> map fromIntegral <$> m) <$> peekMaybeArray (vertexCount * 4) boneIdsPtr
    boneWeightsPtr <- (peekByteOff _p 88 :: IO (Ptr CFloat))
    boneWeights <- (map realToFrac <$>) <$> peekMaybeArray (vertexCount * 4) boneWeightsPtr
    vaoId <- fromIntegral <$> (peekByteOff _p 96 :: IO CUInt)
    vboIdPtr <- (peekByteOff _p 104 :: IO (Ptr CUInt))
    vboId <- (\m -> map fromIntegral <$> m) <$> peekMaybeArray 7 vboIdPtr
    return $ Mesh vertexCount triangleCount vertices texcoords texcoords2 normals tangents colors indices animVertices animNormals boneIds boneWeights vaoId vboId
  poke _p (Mesh vertexCount triangleCount vertices texcoords texcoords2 normals tangents colors indices animVertices animNormals boneIds boneWeights vaoId vboId) = do
    pokeByteOff _p 0 (fromIntegral vertexCount :: CInt)
    pokeByteOff _p 4 (fromIntegral triangleCount :: CInt)
    pokeByteOff _p 8 =<< newArray vertices
    pokeByteOff _p 16 =<< newArray texcoords
    newMaybeArray texcoords2 >>= pokeByteOff _p 24
    pokeByteOff _p 32 =<< newArray normals
    newMaybeArray tangents >>= pokeByteOff _p 40
    newMaybeArray colors >>= pokeByteOff _p 48
    newMaybeArray (map fromIntegral <$> indices :: Maybe [CUShort]) >>= pokeByteOff _p 56
    newMaybeArray animVertices >>= pokeByteOff _p 64
    newMaybeArray animNormals >>= pokeByteOff _p 72
    newMaybeArray (map fromIntegral <$> boneIds :: Maybe [CUChar]) >>= pokeByteOff _p 80
    newMaybeArray (map realToFrac <$> boneWeights :: Maybe [CFloat]) >>= pokeByteOff _p 88
    pokeByteOff _p 96 (fromIntegral vaoId :: CUInt)
    newMaybeArray (map fromIntegral <$> vboId :: Maybe [CUInt]) >>= pokeByteOff _p 104
    return ()

instance Freeable Mesh where
  rlFreeDependents _ ptr = do
    verticesPtr <- (peekByteOff ptr 8 :: IO (Ptr Float))
    c'free $ castPtr verticesPtr
    texcoordsPtr <- (peekByteOff ptr 16 :: IO (Ptr Vector2))
    c'free $ castPtr texcoordsPtr
    texcoords2Ptr <- (peekByteOff ptr 24 :: IO (Ptr Vector2))
    freeMaybePtr $ castPtr texcoords2Ptr
    normalsPtr <- (peekByteOff ptr 32 :: IO (Ptr Vector3))
    c'free $ castPtr normalsPtr
    tangentsPtr <- (peekByteOff ptr 40 :: IO (Ptr Vector4))
    freeMaybePtr $ castPtr tangentsPtr
    colorsPtr <- (peekByteOff ptr 48 :: IO (Ptr Color))
    freeMaybePtr $ castPtr colorsPtr
    indicesPtr <- (peekByteOff ptr 56 :: IO (Ptr CUShort))
    freeMaybePtr $ castPtr indicesPtr
    animVerticesPtr <- (peekByteOff ptr 64 :: IO (Ptr Vector3))
    freeMaybePtr $ castPtr animVerticesPtr
    animNormalsPtr <- (peekByteOff ptr 72 :: IO (Ptr Vector3))
    freeMaybePtr $ castPtr animNormalsPtr
    boneIdsPtr <- (peekByteOff ptr 80 :: IO (Ptr CUChar))
    freeMaybePtr $ castPtr boneIdsPtr
    boneWeightsPtr <- (peekByteOff ptr 88 :: IO (Ptr CFloat))
    freeMaybePtr $ castPtr boneWeightsPtr
    vboIdPtr <- (peekByteOff ptr 104 :: IO (Ptr CUInt))
    c'free $ castPtr vboIdPtr

data Shader = Shader
  { shader'id :: Integer,
    shader'locs :: [Int]
  }
  deriving (Eq, Show)

instance Storable Shader where
  sizeOf _ = 16
  alignment _ = 8
  peek _p = do
    sId <- fromIntegral <$> (peekByteOff _p 0 :: IO CUInt)
    locsPtr <- (peekByteOff _p 8 :: IO (Ptr CInt))
    locs <- map fromIntegral <$> peekArray 32 locsPtr
    return $ Shader sId locs
  poke _p (Shader sId locs) = do
    pokeByteOff _p 0 (fromIntegral sId :: CUInt)
    defaultShaderId <- c'rlGetShaderIdDefault
    locsArr <- newArray (map fromIntegral locs :: [CInt])
    if sId == fromIntegral defaultShaderId
      then do
        locsPtr <- newForeignPtr p'free locsArr
        withForeignPtr locsPtr $ pokeByteOff _p 8
      else pokeByteOff _p 8 locsArr
    return ()

instance Freeable Shader where
  rlFreeDependents val ptr = do
    defaultShaderId <- c'rlGetShaderIdDefault
    unless
      (shader'id val == fromIntegral defaultShaderId)
      ( do
          locsPtr <- (peekByteOff ptr 8 :: IO (Ptr CInt))
          c'free $ castPtr locsPtr
      )

data MaterialMap = MaterialMap
  { materialMap'texture :: Texture,
    materialMap'color :: Color,
    materialMap'value :: Float
  }
  deriving (Eq, Show, Freeable)

instance Storable MaterialMap where
  sizeOf _ = 28
  alignment _ = 4
  peek _p = do
    texture <- peekByteOff _p 0
    color <- peekByteOff _p 20
    value <- realToFrac <$> (peekByteOff _p 24 :: IO CFloat)
    return $ MaterialMap texture color value
  poke _p (MaterialMap texture color value) = do
    pokeByteOff _p 0 texture
    pokeByteOff _p 20 color
    pokeByteOff _p 24 (realToFrac value :: CFloat)
    return ()

data Material = Material
  { material'shader :: Shader,
    material'maps :: Maybe [MaterialMap],
    material'params :: [Float]
  }
  deriving (Eq, Show)

instance Storable Material where
  sizeOf _ = 40
  alignment _ = 8
  peek _p = do
    shader <- peekByteOff _p 0
    mapsPtr <- (peekByteOff _p 16 :: IO (Ptr MaterialMap))
    maps <- peekMaybeArray 12 mapsPtr
    params <- map realToFrac <$> peekStaticArrayOff 4 (castPtr _p :: Ptr CFloat) 24
    return $ Material shader maps params
  poke _p (Material shader maps params) = do
    pokeByteOff _p 0 shader
    pokeByteOff _p 16 =<< newMaybeArray maps
    pokeStaticArrayOff (castPtr _p :: Ptr CFloat) 24 (map realToFrac params :: [CFloat])
    return ()

instance Freeable Material where
  rlFreeDependents val ptr = do
    rlFreeDependents (material'shader val) (castPtr ptr :: Ptr Shader)
    mapsPtr <- (peekByteOff ptr 16 :: IO (Ptr MaterialMap))
    rlFreeMaybeArray (material'maps val) mapsPtr

data Transform = Transform
  { transform'translation :: Vector3,
    transform'rotation :: Quaternion,
    transform'scale :: Vector3
  }
  deriving (Eq, Show, Freeable)

instance Storable Transform where
  sizeOf _ = 40
  alignment _ = 4
  peek _p = do
    translation <- peekByteOff _p 0
    rotation <- peekByteOff _p 12
    scale <- peekByteOff _p 28
    return $ Transform translation rotation scale
  poke _p (Transform translation rotation scale) = do
    pokeByteOff _p 0 translation
    pokeByteOff _p 12 rotation
    pokeByteOff _p 28 scale
    return ()

data BoneInfo = BoneInfo
  { boneInfo'name :: String,
    boneinfo'parent :: Int
  }
  deriving (Eq, Show, Freeable)

instance Storable BoneInfo where
  sizeOf _ = 36
  alignment _ = 4
  peek _p = do
    name <- map castCCharToChar . takeWhile (/= 0) <$> peekStaticArray 32 (castPtr _p :: Ptr CChar)
    parent <- fromIntegral <$> (peekByteOff _p 32 :: IO CInt)
    return $ BoneInfo name parent
  poke _p (BoneInfo name parent) = do
    pokeStaticArray (castPtr _p :: Ptr CChar) (rightPad 32 0 $ map castCharToCChar name)
    pokeByteOff _p 32 (fromIntegral parent :: CInt)
    return ()

data Model = Model
  { model'transform :: Matrix,
    model'meshes :: [Mesh],
    model'materials :: [Material],
    model'meshMaterial :: [Int],
    model'boneCount :: Int,
    model'bones :: Maybe [BoneInfo],
    model'bindPose :: Maybe [Transform]
  }
  deriving (Eq, Show)

instance Storable Model where
  sizeOf _ = 120
  alignment _ = 4
  peek _p = do
    transform <- peekByteOff _p 0
    meshCount <- fromIntegral <$> (peekByteOff _p 64 :: IO CInt)
    materialCount <- fromIntegral <$> (peekByteOff _p 68 :: IO CInt)
    meshesPtr <- (peekByteOff _p 72 :: IO (Ptr Mesh))
    meshes <- peekArray meshCount meshesPtr
    materialsPtr <- (peekByteOff _p 80 :: IO (Ptr Material))
    materials <- peekArray materialCount materialsPtr
    meshMaterialPtr <- (peekByteOff _p 88 :: IO (Ptr CInt))
    meshMaterial <- map fromIntegral <$> peekArray meshCount meshMaterialPtr
    boneCount <- fromIntegral <$> (peekByteOff _p 96 :: IO CInt)
    bonesPtr <- (peekByteOff _p 104 :: IO (Ptr BoneInfo))
    bones <- peekMaybeArray boneCount bonesPtr
    bindPosePtr <- (peekByteOff _p 112 :: IO (Ptr Transform))
    bindPose <- peekMaybeArray boneCount bindPosePtr
    return $ Model transform meshes materials meshMaterial boneCount bones bindPose
  poke _p (Model transform meshes materials meshMaterial boneCount bones bindPose) = do
    pokeByteOff _p 0 transform
    pokeByteOff _p 64 (fromIntegral $ length meshes :: CInt)
    pokeByteOff _p 68 (fromIntegral $ length materials :: CInt)
    pokeByteOff _p 72 =<< newArray meshes
    pokeByteOff _p 80 =<< newArray materials
    pokeByteOff _p 88 =<< newArray (map fromIntegral meshMaterial :: [CInt])
    pokeByteOff _p 96 (fromIntegral boneCount :: CInt)
    newMaybeArray bones >>= pokeByteOff _p 104
    newMaybeArray bindPose >>= pokeByteOff _p 112
    return ()

instance Freeable Model where
  rlFreeDependents val ptr = do
    meshesPtr <- (peekByteOff ptr 72 :: IO (Ptr Mesh))
    rlFreeArray (model'meshes val) meshesPtr
    materialsPtr <- (peekByteOff ptr 80 :: IO (Ptr Material))
    rlFreeArray (model'materials val) materialsPtr
    meshMaterialPtr <- (peekByteOff ptr 88 :: IO (Ptr CInt))
    c'free $ castPtr meshMaterialPtr
    bonesPtr <- (peekByteOff ptr 104 :: IO (Ptr BoneInfo))
    freeMaybePtr $ castPtr bonesPtr
    bindPosePtr <- (peekByteOff ptr 112 :: IO (Ptr Transform))
    freeMaybePtr $ castPtr bindPosePtr

data ModelAnimation = ModelAnimation
  { modelAnimation'boneCount :: Int,
    modelAnimation'frameCount :: Int,
    modelAnimation'bones :: [BoneInfo],
    modelAnimation'framePoses :: [[Transform]]
  }
  deriving (Eq, Show)

instance Storable ModelAnimation where
  sizeOf _ = 24
  alignment _ = 4
  peek _p = do
    boneCount <- fromIntegral <$> (peekByteOff _p 0 :: IO CInt)
    frameCount <- fromIntegral <$> (peekByteOff _p 4 :: IO CInt)
    bonesPtr <- (peekByteOff _p 8 :: IO (Ptr BoneInfo))
    bones <- peekArray boneCount bonesPtr
    framePosesPtr <- (peekByteOff _p 16 :: IO (Ptr (Ptr Transform)))
    framePosesPtrArr <- peekArray frameCount framePosesPtr
    framePoses <- mapM (peekArray boneCount) framePosesPtrArr
    return $ ModelAnimation boneCount frameCount bones framePoses
  poke _p (ModelAnimation boneCount frameCount bones framePoses) = do
    pokeByteOff _p 0 (fromIntegral boneCount :: CInt)
    pokeByteOff _p 4 (fromIntegral frameCount :: CInt)
    pokeByteOff _p 8 =<< newArray bones
    mapM newArray framePoses >>= newArray >>= pokeByteOff _p 16
    return ()

instance Freeable ModelAnimation where
  rlFreeDependents val ptr = do
    bonesPtr <- (peekByteOff ptr 8 :: IO (Ptr BoneInfo))
    c'free $ castPtr bonesPtr
    framePosesPtr <- (peekByteOff ptr 16 :: IO (Ptr (Ptr Transform)))
    framePosesPtrArr <- peekArray (modelAnimation'frameCount val) framePosesPtr
    forM_ framePosesPtrArr (c'free . castPtr)
    c'free $ castPtr framePosesPtr

data Ray = Ray
  { ray'position :: Vector3,
    ray'direction :: Vector3
  }
  deriving (Eq, Show, Freeable)

instance Storable Ray where
  sizeOf _ = 24
  alignment _ = 4
  peek _p = do
    position <- peekByteOff _p 0
    direction <- peekByteOff _p 12
    return $ Ray position direction
  poke _p (Ray position direction) = do
    pokeByteOff _p 0 position
    pokeByteOff _p 12 direction
    return ()

data RayCollision = RayCollision
  { rayCollision'hit :: Bool,
    rayCollision'distance :: Float,
    rayCollision'point :: Vector3,
    rayCollision'normal :: Vector3
  }
  deriving (Eq, Show, Freeable)

instance Storable RayCollision where
  sizeOf _ = 32
  alignment _ = 4
  peek _p = do
    hit <- toBool <$> (peekByteOff _p 0 :: IO CBool)
    distance <- realToFrac <$> (peekByteOff _p 4 :: IO CFloat)
    point <- peekByteOff _p 8
    normal <- peekByteOff _p 20
    return $ RayCollision hit distance point normal
  poke _p (RayCollision hit distance point normal) = do
    pokeByteOff _p 0 (fromBool hit :: CInt)
    pokeByteOff _p 4 (realToFrac distance :: CFloat)
    pokeByteOff _p 8 point
    pokeByteOff _p 20 normal
    return ()

data BoundingBox = BoundingBox
  { boundingBox'min :: Vector3,
    boundingBox'max :: Vector3
  }
  deriving (Eq, Show, Freeable)

instance Storable BoundingBox where
  sizeOf _ = 24
  alignment _ = 4
  peek _p = do
    bMin <- peekByteOff _p 0
    bMax <- peekByteOff _p 12
    return $ BoundingBox bMin bMax
  poke _p (BoundingBox bMin bMax) = do
    pokeByteOff _p 0 bMin
    pokeByteOff _p 12 bMax
    return ()

data Wave = Wave
  { wave'frameCount :: Integer,
    wave'sampleRate :: Integer,
    wave'sampleSize :: Integer,
    wave'channels :: Integer,
    wave'data :: [Int]
  }
  deriving (Eq, Show)

instance Storable Wave where
  sizeOf _ = 24
  alignment _ = 4
  peek _p = do
    frameCount <- fromIntegral <$> (peekByteOff _p 0 :: IO CUInt)
    sampleRate <- fromIntegral <$> (peekByteOff _p 4 :: IO CUInt)
    sampleSize <- fromIntegral <$> (peekByteOff _p 8 :: IO CUInt)
    channels <- fromIntegral <$> (peekByteOff _p 12 :: IO CUInt)
    wDataPtr <- (peekByteOff _p 16 :: IO (Ptr CShort))
    wData <- map fromIntegral <$> peekArray (fromInteger $ frameCount * channels) wDataPtr
    return $ Wave frameCount sampleRate sampleSize channels wData
  poke _p (Wave frameCount sampleRate sampleSize channels wData) = do
    pokeByteOff _p 0 (fromIntegral frameCount :: CUInt)
    pokeByteOff _p 4 (fromIntegral sampleRate :: CUInt)
    pokeByteOff _p 8 (fromIntegral sampleSize :: CUInt)
    pokeByteOff _p 12 (fromIntegral channels :: CUInt)
    pokeByteOff _p 16 =<< newArray (map fromIntegral wData :: [CShort])
    return ()

instance Freeable Wave where
  rlFreeDependents _ ptr = do
    dataPtr <- peekByteOff ptr 16 :: IO (Ptr CShort)
    c'free $ castPtr dataPtr

-- RAudioBuffer/Processor don't work perfectly right now, I need to fix them later on.
-- They are currently used as `Ptr`s because peeking/poking them every time
-- an audio function is called doesn't work properly (they are stored in a
-- linked list in C, which makes it very difficult to properly marshal them)
data RAudioBuffer = RAudioBuffer
  { rAudioBuffer'converter :: [Int], -- Implemented as an array of 39 integers because binding the entire `ma_data_converter` type is too painful
    rAudioBuffer'callback :: AudioCallback,
    rAudioBuffer'processor :: Maybe RAudioProcessor,
    rAudioBuffer'volume :: Float,
    rAudioBuffer'pitch :: Float,
    rAudioBuffer'pan :: Float,
    rAudioBuffer'playing :: Bool,
    rAudioBuffer'paused :: Bool,
    rAudioBuffer'looping :: Bool,
    rAudioBuffer'usage :: Int,
    rAudioBuffer'isSubBufferProcessed :: [Bool],
    rAudioBuffer'sizeInFrames :: Integer,
    rAudioBuffer'frameCursorPos :: Integer,
    rAudioBuffer'framesProcessed :: Integer,
    rAudioBuffer'data :: [Word8],
    rAudioBuffer'next :: Maybe RAudioBuffer,
    rAudioBuffer'prev :: Maybe RAudioBuffer
  }
  deriving (Eq, Show, Freeable)

instance Storable RAudioBuffer where
  sizeOf _ = 392
  alignment _ = 8
  peek _p = do
    base <- loadBase _p
    nextPtr <- peekByteOff _p 376
    next <- loadNext nextPtr
    prevPtr <- peekByteOff _p 384
    prev <- loadPrev prevPtr
    return $
      let p =
            base
              ((\a -> a {rAudioBuffer'prev = Just p}) <$> next)
              ((\a -> a {rAudioBuffer'next = Just p}) <$> prev)
       in p
    where
      getBytesPerSample = ([0, 1, 2, 3, 4, 4] !!)
      loadBase ptr = do
        converter <- map fromIntegral <$> (peekStaticArray 39 (castPtr ptr) :: IO [CInt])
        callback <- peekByteOff ptr 312
        pPtr <- peekByteOff ptr 320 :: IO (Ptr RAudioProcessor)
        processor <- if pPtr == nullPtr then return Nothing else Just <$> peek pPtr

        volume <- realToFrac <$> (peekByteOff ptr 328 :: IO CFloat)
        pitch <- realToFrac <$> (peekByteOff ptr 332 :: IO CFloat)
        pan <- realToFrac <$> (peekByteOff ptr 336 :: IO CFloat)

        playing <- toBool <$> (peekByteOff ptr 340 :: IO CBool)
        paused <- toBool <$> (peekByteOff ptr 341 :: IO CBool)
        looping <- toBool <$> (peekByteOff ptr 342 :: IO CBool)
        usage <- fromIntegral <$> (peekByteOff ptr 344 :: IO CInt)

        isSubBufferProcessed <- map toBool <$> peekStaticArrayOff 2 (castPtr ptr :: Ptr CBool) 348
        sizeInFrames <- fromIntegral <$> (peekByteOff ptr 352 :: IO CUInt)
        frameCursorPos <- fromIntegral <$> (peekByteOff ptr 356 :: IO CUInt)
        framesProcessed <- fromIntegral <$> (peekByteOff ptr 360 :: IO CUInt)

        bData <- map fromIntegral <$> (peekArray (fromIntegral $ sizeInFrames * 2 * getBytesPerSample (head converter)) =<< (peekByteOff ptr 368 :: IO (Ptr CUChar)))

        return $ RAudioBuffer converter callback processor volume pitch pan playing paused looping usage isSubBufferProcessed sizeInFrames frameCursorPos framesProcessed bData
      loadNext ptr =
        if ptr == nullPtr
          then return Nothing
          else do
            base <- loadBase ptr
            nextPtr <- peekByteOff ptr 376
            next <- loadNext nextPtr
            let p = base ((\a -> a {rAudioBuffer'prev = Just p}) <$> next) Nothing
             in return (Just p)

      loadPrev ptr =
        if ptr == nullPtr
          then return Nothing
          else do
            base <- loadBase ptr
            prevPtr <- peekByteOff ptr 384
            prev <- loadPrev prevPtr
            let p = base Nothing ((\a -> a {rAudioBuffer'next = Just p}) <$> prev)
             in return (Just p)
  poke _p a = do
    pokeBase _p a
    pokeNext _p $ rAudioBuffer'next a
    pokePrev _p $ rAudioBuffer'prev a
    return ()
    where
      pokeBase ptr (RAudioBuffer converter callback processor volume pitch pan playing paused looping usage isSubBufferProcessed sizeInFrames frameCursorPos framesProcessed bData _ _) = do
        pokeStaticArray (castPtr ptr) (map fromIntegral converter :: [CInt])
        pokeByteOff ptr 312 callback
        pokeMaybeOff (castPtr ptr) 320 processor

        pokeByteOff ptr 328 (realToFrac volume :: CFloat)
        pokeByteOff ptr 332 (realToFrac pitch :: CFloat)
        pokeByteOff ptr 336 (realToFrac pan :: CFloat)

        pokeByteOff ptr 340 (fromBool playing :: CBool)
        pokeByteOff ptr 341 (fromBool paused :: CBool)
        pokeByteOff ptr 342 (fromBool looping :: CBool)
        pokeByteOff ptr 344 (fromIntegral usage :: CInt)

        pokeStaticArrayOff (castPtr ptr) 348 (map fromBool isSubBufferProcessed :: [CBool])
        pokeByteOff ptr 352 (fromIntegral sizeInFrames :: CUInt)
        pokeByteOff ptr 356 (fromIntegral frameCursorPos :: CUInt)
        pokeByteOff ptr 360 (fromIntegral framesProcessed :: CUInt)

        pokeByteOff ptr 368 =<< newArray (map fromIntegral bData :: [CUChar])

        return ()
      pokeNext basePtr pNext =
        case pNext of
          Nothing -> pokeByteOff basePtr 376 nullPtr
          Just val -> do
            nextPtr <- malloc
            pokeBase nextPtr val
            pokeNext nextPtr (rAudioBuffer'next val)
            pokeByteOff nextPtr 384 basePtr
            pokeByteOff basePtr 376 nextPtr
      pokePrev basePtr pPrev =
        case pPrev of
          Nothing -> pokeByteOff basePtr 384 nullPtr
          Just val -> do
            prevPtr <- malloc
            pokeBase prevPtr val
            pokeByteOff prevPtr 376 basePtr
            pokePrev prevPtr (rAudioBuffer'prev val)
            pokeByteOff basePtr 384 prevPtr

data RAudioProcessor = RAudioProcessor
  { rAudioProcessor'process :: Maybe AudioCallback,
    rAudioProcessor'next :: Maybe RAudioProcessor,
    rAudioProcessor'prev :: Maybe RAudioProcessor
  }
  deriving (Eq, Show, Freeable)

instance Storable RAudioProcessor where
  sizeOf _ = 24
  alignment _ = 8
  peek _p = do
    process <- loadProcess _p
    nextPtr <- peekByteOff _p 8
    next <- loadNext nextPtr
    prevPtr <- peekByteOff _p 16
    prev <- loadPrev prevPtr
    return $ let p = RAudioProcessor process ((\a -> a {rAudioProcessor'prev = Just p}) <$> next) ((\a -> a {rAudioProcessor'next = Just p}) <$> prev) in p
    where
      loadProcess ptr = do
        funPtr <- peekByteOff ptr 0
        if funPtr == nullFunPtr then return Nothing else return (Just funPtr)
      loadNext ptr =
        if ptr == nullPtr
          then return Nothing
          else do
            process <- loadProcess ptr
            nextPtr <- peekByteOff ptr 8
            next <- loadNext nextPtr
            let p = RAudioProcessor process ((\a -> a {rAudioProcessor'prev = Just p}) <$> next) Nothing
             in return (Just p)

      loadPrev ptr =
        if ptr == nullPtr
          then return Nothing
          else do
            process <- loadProcess ptr
            prevPtr <- peekByteOff ptr 16
            prev <- loadPrev prevPtr
            let p = RAudioProcessor process Nothing ((\a -> a {rAudioProcessor'next = Just p}) <$> prev)
             in return (Just p)
  poke _p (RAudioProcessor process next prev) = do
    pokeMaybeOff (castPtr _p) 0 process
    pokeNext (castPtr _p) next
    pokePrev (castPtr _p) prev
    return ()
    where
      pokeNext basePtr pNext =
        case pNext of
          Nothing -> pokeByteOff basePtr 8 nullPtr
          Just val -> do
            nextPtr <- malloc
            pokeMaybeOff nextPtr 0 (rAudioProcessor'process val)
            pokeNext nextPtr (rAudioProcessor'next val)
            pokeByteOff nextPtr 16 basePtr
            pokeByteOff basePtr 8 nextPtr
      pokePrev basePtr pPrev =
        case pPrev of
          Nothing -> pokeByteOff basePtr 16 nullPtr
          Just val -> do
            prevPtr <- malloc
            pokeMaybeOff prevPtr 0 (rAudioProcessor'process val)
            pokeByteOff prevPtr 8 basePtr
            pokePrev prevPtr (rAudioProcessor'prev val)
            pokeByteOff basePtr 16 prevPtr

data AudioStream = AudioStream
  { audioStream'buffer :: Ptr RAudioBuffer,
    audioStream'processor :: Ptr RAudioProcessor,
    audioStream'sampleRate :: Integer,
    audioStream'sampleSize :: Integer,
    audiostream'channels :: Integer
  }
  deriving (Eq, Show, Freeable)

instance Storable AudioStream where
  sizeOf _ = 32
  alignment _ = 8
  peek _p = do
    buffer <- peekByteOff _p 0
    processor <- peekByteOff _p 8
    sampleRate <- fromIntegral <$> (peekByteOff _p 16 :: IO CUInt)
    sampleSize <- fromIntegral <$> (peekByteOff _p 20 :: IO CUInt)
    channels <- fromIntegral <$> (peekByteOff _p 24 :: IO CUInt)
    return $ AudioStream buffer processor sampleRate sampleSize channels
  poke _p (AudioStream buffer processor sampleRate sampleSize channels) = do
    pokeByteOff _p 0 buffer
    pokeByteOff _p 8 processor
    pokeByteOff _p 16 (fromIntegral sampleRate :: CUInt)
    pokeByteOff _p 20 (fromIntegral sampleSize :: CUInt)
    pokeByteOff _p 24 (fromIntegral channels :: CUInt)
    return ()

data Sound = Sound
  { sound'stream :: AudioStream,
    sound'frameCount :: Integer
  }
  deriving (Eq, Show, Freeable)

instance Storable Sound where
  sizeOf _ = 40
  alignment _ = 8
  peek _p = do
    stream <- peekByteOff _p 0
    frameCount <- fromIntegral <$> (peekByteOff _p 32 :: IO CUInt)
    return $ Sound stream frameCount
  poke _p (Sound stream frameCount) = do
    pokeByteOff _p 0 stream
    pokeByteOff _p 32 (fromIntegral frameCount :: CUInt)
    return ()

data Music = Music
  { music'stream :: AudioStream,
    music'frameCount :: Integer,
    music'looping :: Bool,
    music'ctxType :: MusicContextType,
    music'ctxData :: Ptr ()
  }
  deriving (Eq, Show, Freeable)

instance Storable Music where
  sizeOf _ = 56
  alignment _ = 4
  peek _p = do
    stream <- peekByteOff _p 0
    frameCount <- fromIntegral <$> (peekByteOff _p 32 :: IO CUInt)
    looping <- toBool <$> (peekByteOff _p 36 :: IO CBool)
    ctxType <- peekByteOff _p 40
    ctxData <- peekByteOff _p 48
    return $ Music stream frameCount looping ctxType ctxData
  poke _p (Music stream frameCount looping ctxType ctxData) = do
    pokeByteOff _p 0 stream
    pokeByteOff _p 32 (fromIntegral frameCount :: CUInt)
    pokeByteOff _p 36 (fromBool looping :: CInt)
    pokeByteOff _p 40 ctxType
    pokeByteOff _p 48 ctxData
    return ()

data VrDeviceInfo = VrDeviceInfo
  { vrDeviceInfo'hResolution :: Int,
    vrDeviceInfo'vResolution :: Int,
    vrDeviceInfo'hScreenSize :: Float,
    vrDeviceInfo'vScreenSize :: Float,
    vrDeviceInfo'vScreenCenter :: Float,
    vrDeviceInfo'eyeToScreenDistance :: Float,
    vrDeviceInfo'lensSeparationDistance :: Float,
    vrDeviceInfo'interpupillaryDistance :: Float,
    vrDeviceInfo'lensDistortionValues :: [Float],
    vrDeviceInfo'chromaAbCorrection :: [Float]
  }
  deriving (Eq, Show, Freeable)

instance Storable VrDeviceInfo where
  sizeOf _ = 64
  alignment _ = 4
  peek _p = do
    hResolution <- fromIntegral <$> (peekByteOff _p 0 :: IO CInt)
    vResolution <- fromIntegral <$> (peekByteOff _p 4 :: IO CInt)
    hScreenSize <- realToFrac <$> (peekByteOff _p 8 :: IO CFloat)
    vScreenSize <- realToFrac <$> (peekByteOff _p 12 :: IO CFloat)
    vScreenCenter <- realToFrac <$> (peekByteOff _p 16 :: IO CFloat)
    eyeToScreenDistance <- realToFrac <$> (peekByteOff _p 20 :: IO CFloat)
    lensSeparationDistance <- realToFrac <$> (peekByteOff _p 24 :: IO CFloat)
    interpupillaryDistance <- realToFrac <$> (peekByteOff _p 28 :: IO CFloat)
    lensDistortionValues <- map realToFrac <$> (peekStaticArrayOff 4 (castPtr _p) 32 :: IO [CFloat])
    chromaAbCorrection <- map realToFrac <$> (peekStaticArrayOff 4 (castPtr _p) 48 :: IO [CFloat])
    return $ VrDeviceInfo hResolution vResolution hScreenSize vScreenSize vScreenCenter eyeToScreenDistance lensSeparationDistance interpupillaryDistance lensDistortionValues chromaAbCorrection
  poke _p (VrDeviceInfo hResolution vResolution hScreenSize vScreenSize vScreenCenter eyeToScreenDistance lensSeparationDistance interpupillaryDistance lensDistortionValues chromaAbCorrection) = do
    pokeByteOff _p 0 (fromIntegral hResolution :: CInt)
    pokeByteOff _p 4 (fromIntegral vResolution :: CInt)
    pokeByteOff _p 8 (realToFrac hScreenSize :: CFloat)
    pokeByteOff _p 12 (realToFrac vScreenSize :: CFloat)
    pokeByteOff _p 16 (realToFrac vScreenCenter :: CFloat)
    pokeByteOff _p 20 (realToFrac eyeToScreenDistance :: CFloat)
    pokeByteOff _p 24 (realToFrac lensSeparationDistance :: CFloat)
    pokeByteOff _p 28 (realToFrac interpupillaryDistance :: CFloat)
    pokeStaticArrayOff (castPtr _p) 32 (map realToFrac lensDistortionValues :: [CFloat])
    pokeStaticArrayOff (castPtr _p) 48 (map realToFrac chromaAbCorrection :: [CFloat])
    return ()

data VrStereoConfig = VrStereoConfig
  { vrStereoConfig'projection :: [Matrix],
    vrStereoConfig'viewOffset :: [Matrix],
    vrStereoConfig'leftLensCenter :: [Float],
    vrStereoConfig'rightLensCenter :: [Float],
    vrStereoConfig'leftScreenCenter :: [Float],
    vrStereoConfig'rightScreenCenter :: [Float],
    vrStereoConfig'scale :: [Float],
    vrStereoConfig'scaleIn :: [Float]
  }
  deriving (Eq, Show, Freeable)

instance Storable VrStereoConfig where
  sizeOf _ = 304
  alignment _ = 4
  peek _p = do
    projection <- peekStaticArrayOff 2 (castPtr _p) 0
    viewOffset <- peekStaticArrayOff 2 (castPtr _p) 128
    leftLensCenter <- map realToFrac <$> (peekStaticArrayOff 2 (castPtr _p) 256 :: IO [CFloat])
    rightLensCenter <- map realToFrac <$> (peekStaticArrayOff 2 (castPtr _p) 264 :: IO [CFloat])
    leftScreenCenter <- map realToFrac <$> (peekStaticArrayOff 2 (castPtr _p) 272 :: IO [CFloat])
    rightScreenCenter <- map realToFrac <$> (peekStaticArrayOff 2 (castPtr _p) 280 :: IO [CFloat])
    scale <- map realToFrac <$> (peekStaticArrayOff 2 (castPtr _p) 288 :: IO [CFloat])
    scaleIn <- map realToFrac <$> (peekStaticArrayOff 2 (castPtr _p) 296 :: IO [CFloat])
    return $ VrStereoConfig projection viewOffset leftLensCenter rightLensCenter leftScreenCenter rightScreenCenter scale scaleIn
  poke _p (VrStereoConfig projection viewOffset leftLensCenter rightLensCenter leftScreenCenter rightScreenCenter scale scaleIn) = do
    pokeStaticArrayOff (castPtr _p) 0 projection
    pokeStaticArrayOff (castPtr _p) 128 viewOffset
    pokeStaticArrayOff (castPtr _p) 256 (map realToFrac leftLensCenter :: [CFloat])
    pokeStaticArrayOff (castPtr _p) 264 (map realToFrac rightLensCenter :: [CFloat])
    pokeStaticArrayOff (castPtr _p) 272 (map realToFrac leftScreenCenter :: [CFloat])
    pokeStaticArrayOff (castPtr _p) 280 (map realToFrac rightScreenCenter :: [CFloat])
    pokeStaticArrayOff (castPtr _p) 288 (map realToFrac scale :: [CFloat])
    pokeStaticArrayOff (castPtr _p) 296 (map realToFrac scaleIn :: [CFloat])
    return ()

data FilePathList = FilePathList
  { filePathlist'capacity :: Integer,
    filePathList'paths :: [String]
  }
  deriving (Eq, Show)

instance Storable FilePathList where
  sizeOf _ = 16
  alignment _ = 4
  peek _p = do
    capacity <- fromIntegral <$> (peekByteOff _p 0 :: IO CUInt)
    count <- fromIntegral <$> (peekByteOff _p 4 :: IO CUInt)
    pathsPtr <- (peekByteOff _p 8 :: IO (Ptr CString))
    pathsCStrings <- peekArray count pathsPtr
    paths <- mapM peekCString pathsCStrings
    return $ FilePathList capacity paths
  poke _p (FilePathList capacity paths) = do
    pokeByteOff _p 0 (fromIntegral capacity :: CUInt)
    pokeByteOff _p 4 (fromIntegral (length paths) :: CUInt)
    pathsCStrings <- mapM newCString paths
    pokeByteOff _p 8 =<< newArray pathsCStrings
    return ()

instance Freeable FilePathList where
  rlFreeDependents val ptr = do
    pathsPtr <- (peekByteOff ptr 8 :: IO (Ptr CString))
    pathsCStrings <- peekArray (length $ filePathList'paths val) pathsPtr
    mapM_ (c'free . castPtr) pathsCStrings
    c'free $ castPtr pathsPtr

------------------------------------------------
-- Raylib callbacks ----------------------------
------------------------------------------------

type LoadFileDataCallback = FunPtr (CString -> Ptr CUInt -> IO (Ptr CUChar))

type SaveFileDataCallback = FunPtr (CString -> Ptr () -> CUInt -> IO CInt)

type LoadFileTextCallback = FunPtr (CString -> IO CString)

type SaveFileTextCallback = FunPtr (CString -> CString -> IO CInt)

type AudioCallback = FunPtr (Ptr () -> CUInt -> IO ())
