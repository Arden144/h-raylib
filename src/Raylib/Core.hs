{-# OPTIONS -Wall #-}
{-# LANGUAGE ForeignFunctionInterface #-}

module Raylib.Core where

import Foreign
  ( Ptr,
    Storable (peek, sizeOf),
    castPtr,
    fromBool,
    peekArray,
    toBool,
    with,
    withArray,
    withArrayLen,
  )
import Foreign.C
  ( CInt (CInt),
    CUChar,
    CUInt (CUInt),
    peekCString,
    withCString,
  )
import Raylib.Native
  ( c'beginBlendMode,
    c'beginMode2D,
    c'beginMode3D,
    c'beginScissorMode,
    c'beginShaderMode,
    c'beginTextureMode,
    c'beginVrStereoMode,
    c'changeDirectory,
    c'clearBackground,
    c'clearWindowState,
    c'compressData,
    c'decodeDataBase64,
    c'decompressData,
    c'directoryExists,
    c'encodeDataBase64,
    c'exportDataAsCode,
    c'fileExists,
    c'getApplicationDirectory,
    c'getCameraMatrix,
    c'getCameraMatrix2D,
    c'getCharPressed,
    c'getClipboardText,
    c'getCurrentMonitor,
    c'getDirectoryPath,
    c'getFPS,
    c'getFileExtension,
    c'getFileLength,
    c'getFileModTime,
    c'getFileName,
    c'getFileNameWithoutExt,
    c'getFrameTime,
    c'getGamepadAxisCount,
    c'getGamepadAxisMovement,
    c'getGamepadButtonPressed,
    c'getGamepadName,
    c'getGestureDetected,
    c'getGestureDragAngle,
    c'getGestureDragVector,
    c'getGestureHoldDuration,
    c'getGesturePinchAngle,
    c'getGesturePinchVector,
    c'getKeyPressed,
    c'getMonitorCount,
    c'getMonitorHeight,
    c'getMonitorName,
    c'getMonitorPhysicalHeight,
    c'getMonitorPhysicalWidth,
    c'getMonitorPosition,
    c'getMonitorRefreshRate,
    c'getMonitorWidth,
    c'getMouseDelta,
    c'getMousePosition,
    c'getMouseRay,
    c'getMouseWheelMove,
    c'getMouseWheelMoveV,
    c'getMouseX,
    c'getMouseY,
    c'getPrevDirectoryPath,
    c'getRandomValue,
    c'getRenderHeight,
    c'getRenderWidth,
    c'getScreenHeight,
    c'getScreenToWorld2D,
    c'getScreenWidth,
    c'getShaderLocation,
    c'getShaderLocationAttrib,
    c'getTime,
    c'getTouchPointCount,
    c'getTouchPointId,
    c'getTouchPosition,
    c'getTouchX,
    c'getTouchY,
    c'getWindowPosition,
    c'getWindowScaleDPI,
    c'getWorkingDirectory,
    c'getWorldToScreen,
    c'getWorldToScreen2D,
    c'getWorldToScreenEx,
    c'initWindow,
    c'isCursorHidden,
    c'isCursorOnScreen,
    c'isFileDropped,
    c'isFileExtension,
    c'isGamepadAvailable,
    c'isGamepadButtonDown,
    c'isGamepadButtonPressed,
    c'isGamepadButtonReleased,
    c'isGamepadButtonUp,
    c'isGestureDetected,
    c'isKeyDown,
    c'isKeyPressed,
    c'isKeyReleased,
    c'isKeyUp,
    c'isMouseButtonDown,
    c'isMouseButtonPressed,
    c'isMouseButtonReleased,
    c'isMouseButtonUp,
    c'isPathFile,
    c'isWindowFocused,
    c'isWindowFullscreen,
    c'isWindowHidden,
    c'isWindowMaximized,
    c'isWindowMinimized,
    c'isWindowReady,
    c'isWindowResized,
    c'isWindowState,
    c'loadDirectoryFiles,
    c'loadDirectoryFilesEx,
    c'loadDroppedFiles,
    c'loadFileData,
    c'loadFileText,
    c'loadShader,
    c'loadShaderFromMemory,
    c'loadVrStereoConfig,
    c'memAlloc,
    c'memFree,
    c'memRealloc,
    c'openURL,
    c'saveFileData,
    c'saveFileText,
    c'setCameraAltControl,
    c'setCameraMode,
    c'setCameraMoveControls,
    c'setCameraPanControl,
    c'setCameraSmoothZoomControl,
    c'setClipboardText,
    c'setConfigFlags,
    c'setExitKey,
    c'setGamepadMappings,
    c'setGesturesEnabled,
    c'setMouseCursor,
    c'setMouseOffset,
    c'setMousePosition,
    c'setMouseScale,
    c'setRandomSeed,
    c'setShaderValue,
    c'setShaderValueMatrix,
    c'setShaderValueTexture,
    c'setShaderValueV,
    c'setTargetFPS,
    c'setTraceLogLevel,
    c'setWindowIcon,
    c'setWindowMinSize,
    c'setWindowMonitor,
    c'setWindowOpacity,
    c'setWindowPosition,
    c'setWindowSize,
    c'setWindowState,
    c'setWindowTitle,
    c'takeScreenshot,
    c'traceLog,
    c'unloadDirectoryFiles,
    c'unloadDroppedFiles,
    c'unloadFileData,
    c'unloadFileText,
    c'unloadShader,
    c'unloadVrStereoConfig,
    c'updateCamera,
    c'waitTime,
    c'windowShouldClose,
  )
import Raylib.Types
    ( FilePathList,
      VrStereoConfig,
      VrDeviceInfo,
      Ray,
      Shader,
      Camera2D,
      Camera3D,
      RenderTexture,
      Texture,
      Image,
      Color,
      Matrix,
      Vector3,
      Vector2,
      CameraMode,
      Gesture,
      BlendMode,
      ShaderUniformDataType,
      GamepadAxis,
      GamepadButton,
      MouseCursor,
      MouseButton,
      KeyboardKey,
      TraceLogLevel,
      ConfigFlag,
      SaveFileTextCallback,
      LoadFileTextCallback,
      SaveFileDataCallback,
      LoadFileDataCallback )
import Raylib.Util (configsToBitflag, pop, withMaybeCString)

initWindow :: Int -> Int -> String -> IO ()
initWindow width height title = withCString title $ c'initWindow (fromIntegral width) (fromIntegral height)

windowShouldClose :: IO Bool
windowShouldClose = toBool <$> c'windowShouldClose

foreign import ccall safe "raylib.h CloseWindow"
  closeWindow ::
    IO ()

isWindowReady :: IO Bool
isWindowReady = toBool <$> c'isWindowReady

isWindowFullscreen :: IO Bool
isWindowFullscreen = toBool <$> c'isWindowFullscreen

isWindowHidden :: IO Bool
isWindowHidden = toBool <$> c'isWindowHidden

isWindowMinimized :: IO Bool
isWindowMinimized = toBool <$> c'isWindowMinimized

isWindowMaximized :: IO Bool
isWindowMaximized = toBool <$> c'isWindowMaximized

isWindowFocused :: IO Bool
isWindowFocused = toBool <$> c'isWindowFocused

isWindowResized :: IO Bool
isWindowResized = toBool <$> c'isWindowResized

isWindowState :: [ConfigFlag] -> IO Bool
isWindowState flags = toBool <$> c'isWindowState (fromIntegral $ configsToBitflag flags)

setWindowState :: [ConfigFlag] -> IO ()
setWindowState = c'setWindowState . fromIntegral . configsToBitflag

clearWindowState :: [ConfigFlag] -> IO ()
clearWindowState = c'clearWindowState . fromIntegral . configsToBitflag

foreign import ccall safe "raylib.h ToggleFullscreen"
  toggleFullscreen ::
    IO ()

foreign import ccall safe "raylib.h MaximizeWindow"
  maximizeWindow ::
    IO ()

foreign import ccall safe "raylib.h MinimizeWindow"
  minimizeWindow ::
    IO ()

foreign import ccall safe "raylib.h RestoreWindow"
  restoreWindow ::
    IO ()

setWindowIcon :: Raylib.Types.Image -> IO ()
setWindowIcon image = with image c'setWindowIcon

setWindowTitle :: String -> IO ()
setWindowTitle title = withCString title c'setWindowTitle

setWindowPosition :: Int -> Int -> IO ()
setWindowPosition x y = c'setWindowPosition (fromIntegral x) (fromIntegral y)

setWindowMonitor :: Int -> IO ()
setWindowMonitor = c'setWindowMonitor . fromIntegral

setWindowMinSize :: Int -> Int -> IO ()
setWindowMinSize x y = c'setWindowMinSize (fromIntegral x) (fromIntegral y)

setWindowSize :: Int -> Int -> IO ()
setWindowSize x y = c'setWindowSize (fromIntegral x) (fromIntegral y)

setWindowOpacity :: Float -> IO ()
setWindowOpacity opacity = c'setWindowOpacity $ realToFrac opacity

foreign import ccall safe "raylib.h GetWindowHandle"
  getWindowHandle ::
    IO (Ptr ())

getScreenWidth :: IO Int
getScreenWidth = fromIntegral <$> c'getScreenWidth

getScreenHeight :: IO Int
getScreenHeight = fromIntegral <$> c'getScreenHeight

getRenderWidth :: IO Int
getRenderWidth = fromIntegral <$> c'getRenderWidth

getRenderHeight :: IO Int
getRenderHeight = fromIntegral <$> c'getRenderHeight

getMonitorCount :: IO Int
getMonitorCount = fromIntegral <$> c'getMonitorCount

getCurrentMonitor :: IO Int
getCurrentMonitor = fromIntegral <$> c'getCurrentMonitor

getMonitorPosition :: Int -> IO Raylib.Types.Vector2
getMonitorPosition monitor = c'getMonitorPosition (fromIntegral monitor) >>= pop

getMonitorWidth :: Int -> IO Int
getMonitorWidth monitor = fromIntegral <$> c'getMonitorWidth (fromIntegral monitor)

getMonitorHeight :: Int -> IO Int
getMonitorHeight monitor = fromIntegral <$> c'getMonitorHeight (fromIntegral monitor)

getMonitorPhysicalWidth :: Int -> IO Int
getMonitorPhysicalWidth monitor = fromIntegral <$> c'getMonitorPhysicalWidth (fromIntegral monitor)

getMonitorPhysicalHeight :: Int -> IO Int
getMonitorPhysicalHeight monitor = fromIntegral <$> c'getMonitorPhysicalHeight (fromIntegral monitor)

getMonitorRefreshRate :: Int -> IO Int
getMonitorRefreshRate monitor = fromIntegral <$> c'getMonitorRefreshRate (fromIntegral monitor)

getWindowPosition :: IO Raylib.Types.Vector2
getWindowPosition = c'getWindowPosition >>= pop

getWindowScaleDPI :: IO Raylib.Types.Vector2
getWindowScaleDPI = c'getWindowScaleDPI >>= pop

getMonitorName :: Int -> IO String
getMonitorName monitor = c'getMonitorName (fromIntegral monitor) >>= peekCString

setClipboardText :: String -> IO ()
setClipboardText text = withCString text c'setClipboardText

getClipboardText :: IO String
getClipboardText = c'getClipboardText >>= peekCString

foreign import ccall safe "raylib.h EnableEventWaiting"
  enableEventWaiting ::
    IO ()

foreign import ccall safe "raylib.h DisableEventWaiting"
  disableEventWaiting ::
    IO ()

foreign import ccall safe "raylib.h SwapScreenBuffer"
  swapScreenBuffer ::
    IO ()

foreign import ccall safe "raylib.h PollInputEvents"
  pollInputEvents ::
    IO ()

waitTime :: Double -> IO ()
waitTime seconds = c'waitTime $ realToFrac seconds

foreign import ccall safe "raylib.h ShowCursor"
  showCursor ::
    IO ()

foreign import ccall safe "raylib.h HideCursor"
  hideCursor ::
    IO ()

isCursorHidden :: IO Bool
isCursorHidden = toBool <$> c'isCursorHidden

foreign import ccall safe "raylib.h EnableCursor"
  enableCursor ::
    IO ()

foreign import ccall safe "raylib.h DisableCursor"
  disableCursor ::
    IO ()

isCursorOnScreen :: IO Bool
isCursorOnScreen = toBool <$> c'isCursorOnScreen

clearBackground :: Raylib.Types.Color -> IO ()
clearBackground color = with color c'clearBackground

foreign import ccall safe "raylib.h BeginDrawing"
  beginDrawing ::
    IO ()

foreign import ccall safe "raylib.h EndDrawing"
  endDrawing ::
    IO ()

beginMode2D :: Raylib.Types.Camera2D -> IO ()
beginMode2D camera = with camera c'beginMode2D

foreign import ccall safe "raylib.h EndMode2D"
  endMode2D ::
    IO ()

beginMode3D :: Raylib.Types.Camera3D -> IO ()
beginMode3D camera = with camera c'beginMode3D

foreign import ccall safe "raylib.h EndMode3D"
  endMode3D ::
    IO ()

beginTextureMode :: Raylib.Types.RenderTexture -> IO ()
beginTextureMode renderTexture = with renderTexture c'beginTextureMode

foreign import ccall safe "raylib.h EndTextureMode"
  endTextureMode ::
    IO ()

beginShaderMode :: Raylib.Types.Shader -> IO ()
beginShaderMode shader = with shader c'beginShaderMode

foreign import ccall safe "raylib.h EndShaderMode"
  endShaderMode ::
    IO ()

beginBlendMode :: BlendMode -> IO ()
beginBlendMode = c'beginBlendMode . fromIntegral . fromEnum

foreign import ccall safe "raylib.h EndBlendMode"
  endBlendMode ::
    IO ()

beginScissorMode :: Int -> Int -> Int -> Int -> IO ()
beginScissorMode x y width height = c'beginScissorMode (fromIntegral x) (fromIntegral y) (fromIntegral width) (fromIntegral height)

foreign import ccall safe "raylib.h EndScissorMode"
  endScissorMode ::
    IO ()

beginVrStereoMode :: Raylib.Types.VrStereoConfig -> IO ()
beginVrStereoMode config = with config c'beginVrStereoMode

foreign import ccall safe "raylib.h EndVrStereoMode"
  endVrStereoMode ::
    IO ()

loadVrStereoConfig :: Raylib.Types.VrDeviceInfo -> IO Raylib.Types.VrStereoConfig
loadVrStereoConfig deviceInfo = with deviceInfo c'loadVrStereoConfig >>= pop

unloadVrStereoConfig :: Raylib.Types.VrStereoConfig -> IO ()
unloadVrStereoConfig config = with config c'unloadVrStereoConfig

loadShader :: Maybe String -> Maybe String -> IO Raylib.Types.Shader
loadShader vsFileName fsFileName =
  withMaybeCString vsFileName (withMaybeCString fsFileName . c'loadShader) >>= pop

loadShaderFromMemory :: Maybe String -> Maybe String -> IO Raylib.Types.Shader
loadShaderFromMemory vsCode fsCode = withMaybeCString vsCode (withMaybeCString fsCode . c'loadShaderFromMemory) >>= pop

getShaderLocation :: Raylib.Types.Shader -> String -> IO Int
getShaderLocation shader uniformName = fromIntegral <$> with shader (withCString uniformName . c'getShaderLocation)

getShaderLocationAttrib :: Raylib.Types.Shader -> String -> IO Int
getShaderLocationAttrib shader attribName = fromIntegral <$> with shader (withCString attribName . c'getShaderLocationAttrib)

setShaderValue :: Raylib.Types.Shader -> Int -> Ptr () -> ShaderUniformDataType -> IO ()
setShaderValue shader locIndex value uniformType = with shader (\s -> c'setShaderValue s (fromIntegral locIndex) value (fromIntegral $ fromEnum uniformType))

setShaderValueV :: Raylib.Types.Shader -> Int -> Ptr () -> ShaderUniformDataType -> Int -> IO ()
setShaderValueV shader locIndex value uniformType count = with shader (\s -> c'setShaderValueV s (fromIntegral locIndex) value (fromIntegral $ fromEnum uniformType) (fromIntegral count))

setShaderValueMatrix :: Raylib.Types.Shader -> Int -> Raylib.Types.Matrix -> IO ()
setShaderValueMatrix shader locIndex mat = with shader (\s -> with mat (c'setShaderValueMatrix s (fromIntegral locIndex)))

setShaderValueTexture :: Raylib.Types.Shader -> Int -> Raylib.Types.Texture -> IO ()
setShaderValueTexture shader locIndex tex = with shader (\s -> with tex (c'setShaderValueTexture s (fromIntegral locIndex)))

unloadShader :: Raylib.Types.Shader -> IO ()
unloadShader shader = with shader c'unloadShader

getMouseRay :: Raylib.Types.Vector2 -> Raylib.Types.Camera3D -> IO Raylib.Types.Ray
getMouseRay mousePosition camera = with mousePosition (with camera . c'getMouseRay) >>= pop

getCameraMatrix :: Raylib.Types.Camera3D -> IO Raylib.Types.Matrix
getCameraMatrix camera = with camera c'getCameraMatrix >>= pop

getCameraMatrix2D :: Raylib.Types.Camera2D -> IO Raylib.Types.Matrix
getCameraMatrix2D camera = with camera c'getCameraMatrix2D >>= pop

getWorldToScreen :: Raylib.Types.Vector3 -> Raylib.Types.Camera3D -> IO Raylib.Types.Vector2
getWorldToScreen position camera = with position (with camera . c'getWorldToScreen) >>= pop

getScreenToWorld2D :: Raylib.Types.Vector2 -> Raylib.Types.Camera2D -> IO Raylib.Types.Vector2
getScreenToWorld2D position camera = with position (with camera . c'getScreenToWorld2D) >>= pop

getWorldToScreenEx :: Raylib.Types.Vector3 -> Raylib.Types.Camera3D -> Int -> Int -> IO Raylib.Types.Vector2
getWorldToScreenEx position camera width height = with position (\p -> with camera (\c -> c'getWorldToScreenEx p c (fromIntegral width) (fromIntegral height))) >>= pop

getWorldToScreen2D :: Raylib.Types.Vector2 -> Raylib.Types.Camera2D -> IO Raylib.Types.Vector2
getWorldToScreen2D position camera = with position (with camera . c'getWorldToScreen2D) >>= pop

setTargetFPS :: Int -> IO ()
setTargetFPS fps = c'setTargetFPS $ fromIntegral fps

getFPS :: IO Int
getFPS = fromIntegral <$> c'getFPS

getFrameTime :: IO Float
getFrameTime = realToFrac <$> c'getFrameTime

getTime :: IO Double
getTime = realToFrac <$> c'getTime

getRandomValue :: Int -> Int -> IO Int
getRandomValue minVal maxVal = fromIntegral <$> c'getRandomValue (fromIntegral minVal) (fromIntegral maxVal)

setRandomSeed :: Integer -> IO ()
setRandomSeed seed = c'setRandomSeed $ fromIntegral seed

takeScreenshot :: String -> IO ()
takeScreenshot fileName = withCString fileName c'takeScreenshot

setConfigFlags :: [ConfigFlag] -> IO ()
setConfigFlags flags = c'setConfigFlags $ fromIntegral $ configsToBitflag flags

traceLog :: TraceLogLevel -> String -> IO ()
traceLog logLevel text = withCString text $ c'traceLog $ fromIntegral $ fromEnum logLevel

setTraceLogLevel :: TraceLogLevel -> IO ()
setTraceLogLevel = c'setTraceLogLevel . fromIntegral . fromEnum

memAlloc :: (Storable a) => Int -> IO (Ptr a)
memAlloc size = castPtr <$> c'memAlloc (fromIntegral size)

memRealloc :: (Storable a, Storable b) => Ptr a -> Int -> IO (Ptr b)
memRealloc ptr size = castPtr <$> c'memRealloc (castPtr ptr) (fromIntegral size)

memFree :: (Storable a) => Ptr a -> IO ()
memFree = c'memFree . castPtr

openURL :: String -> IO ()
openURL url = withCString url c'openURL

foreign import ccall safe "raylib.h SetLoadFileDataCallback"
  setLoadFileDataCallback ::
    LoadFileDataCallback -> IO ()

foreign import ccall safe "raylib.h SetSaveFileDataCallback"
  setSaveFileDataCallback ::
    SaveFileDataCallback -> IO ()

foreign import ccall safe "raylib.h SetLoadFileTextCallback"
  setLoadFileTextCallback ::
    LoadFileTextCallback -> IO ()

foreign import ccall safe "raylib.h SetSaveFileTextCallback"
  setSaveFileTextCallback ::
    SaveFileTextCallback -> IO ()

-- These functions use varargs so they can't be implemented through FFI
-- foreign import ccall safe "raylib.h SetTraceLogCallback"
--   SetTraceLogCallback ::
--     TraceLogCallback -> IO ()
-- foreign import ccall safe "raylib.h &SetTraceLogCallback"
--   p'SetTraceLogCallback ::
--     FunPtr (TraceLogCallback -> IO ())

loadFileData :: String -> IO [Integer]
loadFileData fileName =
  with
    0
    ( \size -> do
        withCString
          fileName
          ( \path -> do
              ptr <- c'loadFileData path size
              arrSize <- fromIntegral <$> peek size
              arr <- peekArray arrSize ptr
              c'unloadFileData ptr
              return $ map fromIntegral arr
          )
    )

saveFileData :: (Storable a) => String -> Ptr a -> Integer -> IO Bool
saveFileData fileName contents bytesToWrite =
  toBool <$> withCString fileName (\s -> c'saveFileData s (castPtr contents) (fromIntegral bytesToWrite))

exportDataAsCode :: [Integer] -> Integer -> String -> IO Bool
exportDataAsCode contents size fileName =
  toBool <$> withArray (map fromInteger contents) (\c -> withCString fileName (c'exportDataAsCode c (fromIntegral size)))

loadFileText :: String -> IO String
loadFileText fileName = withCString fileName c'loadFileText >>= peekCString

unloadFileText :: String -> IO ()
unloadFileText text = withCString text c'unloadFileText

saveFileText :: String -> String -> IO Bool
saveFileText fileName text = toBool <$> withCString fileName (withCString text . c'saveFileText)

fileExists :: String -> IO Bool
fileExists fileName = toBool <$> withCString fileName c'fileExists

directoryExists :: String -> IO Bool
directoryExists dirPath = toBool <$> withCString dirPath c'directoryExists

isFileExtension :: String -> String -> IO Bool
isFileExtension fileName ext = toBool <$> withCString fileName (withCString ext . c'isFileExtension)

getFileLength :: String -> IO Bool
getFileLength fileName = toBool <$> withCString fileName c'getFileLength

getFileExtension :: String -> IO String
getFileExtension fileName = withCString fileName c'getFileExtension >>= peekCString

getFileName :: String -> IO String
getFileName filePath = withCString filePath c'getFileName >>= peekCString

getFileNameWithoutExt :: String -> IO String
getFileNameWithoutExt fileName = withCString fileName c'getFileNameWithoutExt >>= peekCString

getDirectoryPath :: String -> IO String
getDirectoryPath filePath = withCString filePath c'getDirectoryPath >>= peekCString

getPrevDirectoryPath :: String -> IO String
getPrevDirectoryPath dirPath = withCString dirPath c'getPrevDirectoryPath >>= peekCString

getWorkingDirectory :: IO String
getWorkingDirectory = c'getWorkingDirectory >>= peekCString

getApplicationDirectory :: IO String
getApplicationDirectory = c'getApplicationDirectory >>= peekCString

changeDirectory :: String -> IO Bool
changeDirectory dir = toBool <$> withCString dir c'changeDirectory

isPathFile :: String -> IO Bool
isPathFile path = toBool <$> withCString path c'isPathFile

loadDirectoryFiles :: String -> IO Raylib.Types.FilePathList
loadDirectoryFiles dirPath = withCString dirPath c'loadDirectoryFiles >>= pop

loadDirectoryFilesEx :: String -> String -> Bool -> IO Raylib.Types.FilePathList
loadDirectoryFilesEx basePath filterStr scanSubdirs =
  withCString basePath (\b -> withCString filterStr (\f -> c'loadDirectoryFilesEx b f (fromBool scanSubdirs))) >>= pop

unloadDirectoryFiles :: Raylib.Types.FilePathList -> IO ()
unloadDirectoryFiles files = with files c'unloadDirectoryFiles

isFileDropped :: IO Bool
isFileDropped = toBool <$> c'isFileDropped

loadDroppedFiles :: IO Raylib.Types.FilePathList
loadDroppedFiles = c'loadDroppedFiles >>= pop

unloadDroppedFiles :: Raylib.Types.FilePathList -> IO ()
unloadDroppedFiles files = with files c'unloadDroppedFiles

getFileModTime :: String -> IO Integer
getFileModTime fileName = fromIntegral <$> withCString fileName c'getFileModTime

compressData :: [Integer] -> IO [Integer]
compressData contents = do
  withArrayLen
    (map fromIntegral contents)
    ( \size c -> do
        with
          0
          ( \ptr -> do
              compressed <- c'compressData c (fromIntegral $ size * sizeOf (0 :: CUChar)) ptr
              compressedSize <- fromIntegral <$> peek ptr
              arr <- peekArray compressedSize compressed
              return $ map fromIntegral arr
          )
    )

decompressData :: [Integer] -> IO [Integer]
decompressData compressedData = do
  withArrayLen
    (map fromIntegral compressedData)
    ( \size c -> do
        with
          0
          ( \ptr -> do
              decompressed <- c'decompressData c (fromIntegral $ size * sizeOf (0 :: CUChar)) ptr
              decompressedSize <- fromIntegral <$> peek ptr
              arr <- peekArray decompressedSize decompressed
              return $ map fromIntegral arr
          )
    )

encodeDataBase64 :: [Integer] -> IO [Integer]
encodeDataBase64 contents = do
  withArrayLen
    (map fromIntegral contents)
    ( \size c -> do
        with
          0
          ( \ptr -> do
              encoded <- c'encodeDataBase64 c (fromIntegral $ size * sizeOf (0 :: CUChar)) ptr
              encodedSize <- fromIntegral <$> peek ptr
              arr <- peekArray encodedSize encoded
              return $ map fromIntegral arr
          )
    )

decodeDataBase64 :: [Integer] -> IO [Integer]
decodeDataBase64 encodedData = do
  withArray
    (map fromIntegral encodedData)
    ( \c -> do
        with
          0
          ( \ptr -> do
              decoded <- c'decodeDataBase64 c ptr
              decodedSize <- fromIntegral <$> peek ptr
              arr <- peekArray decodedSize decoded
              return $ map fromIntegral arr
          )
    )

isKeyPressed :: KeyboardKey -> IO Bool
isKeyPressed key = toBool <$> c'isKeyPressed (fromIntegral $ fromEnum key)

isKeyDown :: KeyboardKey -> IO Bool
isKeyDown key = toBool <$> c'isKeyDown (fromIntegral $ fromEnum key)

isKeyReleased :: KeyboardKey -> IO Bool
isKeyReleased key = toBool <$> c'isKeyReleased (fromIntegral $ fromEnum key)

isKeyUp :: KeyboardKey -> IO Bool
isKeyUp key = toBool <$> c'isKeyUp (fromIntegral $ fromEnum key)

setExitKey :: KeyboardKey -> IO ()
setExitKey = c'setExitKey . fromIntegral . fromEnum

getKeyPressed :: IO KeyboardKey
getKeyPressed = toEnum . fromIntegral <$> c'getKeyPressed

getCharPressed :: IO Int
getCharPressed = fromIntegral <$> c'getCharPressed

isGamepadAvailable :: Int -> IO Bool
isGamepadAvailable gamepad = toBool <$> c'isGamepadAvailable (fromIntegral gamepad)

getGamepadName :: Int -> IO String
getGamepadName gamepad = c'getGamepadName (fromIntegral gamepad) >>= peekCString

isGamepadButtonPressed :: Int -> GamepadButton -> IO Bool
isGamepadButtonPressed gamepad button = toBool <$> c'isGamepadButtonPressed (fromIntegral gamepad) (fromIntegral $ fromEnum button)

isGamepadButtonDown :: Int -> GamepadButton -> IO Bool
isGamepadButtonDown gamepad button = toBool <$> c'isGamepadButtonDown (fromIntegral gamepad) (fromIntegral $ fromEnum button)

isGamepadButtonReleased :: Int -> GamepadButton -> IO Bool
isGamepadButtonReleased gamepad button = toBool <$> c'isGamepadButtonReleased (fromIntegral gamepad) (fromIntegral $ fromEnum button)

isGamepadButtonUp :: Int -> GamepadButton -> IO Bool
isGamepadButtonUp gamepad button = toBool <$> c'isGamepadButtonUp (fromIntegral gamepad) (fromIntegral $ fromEnum button)

getGamepadButtonPressed :: IO GamepadButton
getGamepadButtonPressed = toEnum . fromIntegral <$> c'getGamepadButtonPressed

getGamepadAxisCount :: Int -> IO Int
getGamepadAxisCount gamepad = fromIntegral <$> c'getGamepadAxisCount (fromIntegral gamepad)

getGamepadAxisMovement :: Int -> GamepadAxis -> IO Float
getGamepadAxisMovement gamepad axis = realToFrac <$> c'getGamepadAxisMovement (fromIntegral gamepad) (fromIntegral $ fromEnum axis)

setGamepadMappings :: String -> IO Int
setGamepadMappings mappings = fromIntegral <$> withCString mappings c'setGamepadMappings

isMouseButtonPressed :: MouseButton -> IO Bool
isMouseButtonPressed button = toBool <$> c'isMouseButtonPressed (fromIntegral $ fromEnum button)

isMouseButtonDown :: MouseButton -> IO Bool
isMouseButtonDown button = toBool <$> c'isMouseButtonDown (fromIntegral $ fromEnum button)

isMouseButtonReleased :: MouseButton -> IO Bool
isMouseButtonReleased button = toBool <$> c'isMouseButtonReleased (fromIntegral $ fromEnum button)

isMouseButtonUp :: MouseButton -> IO Bool
isMouseButtonUp button = toBool <$> c'isMouseButtonUp (fromIntegral $ fromEnum button)

getMouseX :: IO Int
getMouseX = fromIntegral <$> c'getMouseX

getMouseY :: IO Int
getMouseY = fromIntegral <$> c'getMouseY

getMousePosition :: IO Raylib.Types.Vector2
getMousePosition = c'getMousePosition >>= pop

getMouseDelta :: IO Raylib.Types.Vector2
getMouseDelta = c'getMouseDelta >>= pop

setMousePosition :: Int -> Int -> IO ()
setMousePosition x y = c'setMousePosition (fromIntegral x) (fromIntegral y)

setMouseOffset :: Int -> Int -> IO ()
setMouseOffset x y = c'setMouseOffset (fromIntegral x) (fromIntegral y)

setMouseScale :: Float -> Float -> IO ()
setMouseScale x y = c'setMouseScale (realToFrac x) (realToFrac y)

getMouseWheelMove :: IO Float
getMouseWheelMove = realToFrac <$> c'getMouseWheelMove

getMouseWheelMoveV :: IO Raylib.Types.Vector2
getMouseWheelMoveV = c'getMouseWheelMoveV >>= pop

setMouseCursor :: MouseCursor -> IO ()
setMouseCursor cursor = c'setMouseCursor . fromIntegral $ fromEnum cursor

getTouchX :: IO Int
getTouchX = fromIntegral <$> c'getTouchX

getTouchY :: IO Int
getTouchY = fromIntegral <$> c'getTouchY

getTouchPosition :: Int -> IO Raylib.Types.Vector2
getTouchPosition index = c'getTouchPosition (fromIntegral index) >>= pop

getTouchPointId :: Int -> IO Int
getTouchPointId index = fromIntegral <$> c'getTouchPointId (fromIntegral index)

getTouchPointCount :: IO Int
getTouchPointCount = fromIntegral <$> c'getTouchPointCount

setGesturesEnabled :: [Gesture] -> IO ()
setGesturesEnabled flags = c'setGesturesEnabled (fromIntegral $ configsToBitflag flags)

isGestureDetected :: Gesture -> IO Bool
isGestureDetected gesture = toBool <$> c'isGestureDetected (fromIntegral $ fromEnum gesture)

getGestureDetected :: IO Gesture
getGestureDetected = toEnum . fromIntegral <$> c'getGestureDetected

getGestureHoldDuration :: IO Float
getGestureHoldDuration = realToFrac <$> c'getGestureHoldDuration

getGestureDragVector :: IO Raylib.Types.Vector2
getGestureDragVector = c'getGestureDragVector >>= pop

getGestureDragAngle :: IO Float
getGestureDragAngle = realToFrac <$> c'getGestureDragAngle

getGesturePinchVector :: IO Raylib.Types.Vector2
getGesturePinchVector = c'getGesturePinchVector >>= pop

getGesturePinchAngle :: IO Float
getGesturePinchAngle = realToFrac <$> c'getGesturePinchAngle

setCameraMode :: Raylib.Types.Camera3D -> CameraMode -> IO ()
setCameraMode camera mode = with camera (\c -> c'setCameraMode c (fromIntegral $ fromEnum mode))

updateCamera :: Raylib.Types.Camera3D -> IO Raylib.Types.Camera3D
updateCamera camera =
  with
    camera
    ( \c -> do
        c'updateCamera c
        peek c
    )

setCameraPanControl :: Int -> IO ()
setCameraPanControl keyPan = c'setCameraPanControl $ fromIntegral keyPan

setCameraAltControl :: Int -> IO ()
setCameraAltControl keyAlt = c'setCameraAltControl $ fromIntegral keyAlt

setCameraSmoothZoomControl :: Int -> IO ()
setCameraSmoothZoomControl keySmoothZoom = c'setCameraSmoothZoomControl $ fromIntegral keySmoothZoom

setCameraMoveControls :: Int -> Int -> Int -> Int -> Int -> Int -> IO ()
setCameraMoveControls keyFront keyBack keyRight keyLeft keyUp keyDown =
  c'setCameraMoveControls
    (fromIntegral keyFront)
    (fromIntegral keyBack)
    (fromIntegral keyRight)
    (fromIntegral keyLeft)
    (fromIntegral keyUp)
    (fromIntegral keyDown)