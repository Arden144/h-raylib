{-# OPTIONS -Wall #-}

module Main where

import Raylib.Core (beginDrawing, beginMode3D, beginShaderMode, beginTextureMode, changeDirectory, clearBackground, endDrawing, endMode3D, endShaderMode, endTextureMode, getApplicationDirectory, initWindow, isKeyPressed, loadShader, setShaderValue, setTargetFPS, updateCamera)
import Raylib.Core.Models (drawCube, drawGrid, drawSphere)
import Raylib.Core.Textures (drawTextureRec, loadRenderTexture)
import Raylib.Types (Camera3D (Camera3D), CameraMode (CameraModeOrbital), CameraProjection (CameraPerspective), KeyboardKey (KeyLeft, KeyRight), Rectangle (Rectangle), RenderTexture (renderTexture'texture), ShaderUniformData (ShaderUniformVec2), Vector2 (Vector2), Vector3 (Vector3))
import Raylib.Util (whileWindowOpen_)
import Raylib.Util.Colors (orange, white, black, green, darkGreen, red, maroon, blue, darkBlue)
import Raylib.Core.Text (drawText)

assetsPath :: String
assetsPath = "../../../../../../../../../examples/postprocessing-effects/assets/"

main :: IO ()
main = do
  let width = 1300
      height = 800

  initWindow width height "raylib [shaders] example - postprocessing effects"
  setTargetFPS 60
  _ <- changeDirectory =<< getApplicationDirectory

  let camera = Camera3D (Vector3 3 4 3) (Vector3 0 1 0) (Vector3 0 1 0) 45 CameraPerspective

  rt <- loadRenderTexture width height

  -- Most of the shaders here are based on the ones at https://github.com/raysan5/raylib/tree/master/examples/shaders/resources/shaders/glsl330
  defaultShader <- loadShader Nothing Nothing
  grayscaleShader <- loadShader Nothing (Just $ assetsPath ++ "grayscale.frag")
  blurShader <- loadShader Nothing (Just $ assetsPath ++ "blur.frag")
  pixelateShader <- loadShader Nothing (Just $ assetsPath ++ "pixelate.frag")
  bloomShader <- loadShader Nothing (Just $ assetsPath ++ "bloom.frag")

  let shaders = [("None", defaultShader), ("Grayscale", grayscaleShader), ("Blur", blurShader), ("Pixelate", pixelateShader), ("Bloom", bloomShader)]

  setShaderValue blurShader "renderSize" (ShaderUniformVec2 (Vector2 (fromIntegral width) (fromIntegral height)))
  setShaderValue bloomShader "renderSize" (ShaderUniformVec2 (Vector2 (fromIntegral width) (fromIntegral height)))

  whileWindowOpen_
    ( \(c, currentShader) -> do
        let (shaderName, selectedShader) = shaders !! currentShader

        beginTextureMode rt

        beginMode3D c

        clearBackground white

        drawGrid 30 1.0
        drawCube (Vector3 0 1 0) 2.0 2.0 2.0 orange
        drawSphere (Vector3 0 2 0) 0.5 green
        drawSphere (Vector3 0 0 0) 0.5 darkGreen
        drawSphere (Vector3 1 1 0) 0.5 red
        drawSphere (Vector3 (-1) 1 0) 0.5 maroon
        drawSphere (Vector3 0 1 1) 0.5 blue
        drawSphere (Vector3 0 1 (-1)) 0.5 darkBlue

        endMode3D

        endTextureMode

        beginDrawing

        clearBackground white

        beginShaderMode selectedShader

        drawTextureRec (renderTexture'texture rt) (Rectangle 0 0 (fromIntegral width) (fromIntegral $ - height)) (Vector2 0 0) white

        endShaderMode

        drawText "Press the left and right arrow keys to change the effect" 20 20 20 black
        drawText ("Current effect: " ++ shaderName) 20 50 20 black

        endDrawing

        leftDown <- isKeyPressed KeyLeft
        rightDown <- isKeyPressed KeyRight
        let newShaderIdx = clamp (currentShader + change)
              where
                total = length shaders
                clamp x
                  | x < 0 = total + x
                  | x >= total = x - total
                  | otherwise = x
                change
                  | leftDown = -1
                  | rightDown = 1
                  | otherwise = 0

        newCam <- updateCamera c CameraModeOrbital
        return (newCam, newShaderIdx)
    )
    (camera, 0)
