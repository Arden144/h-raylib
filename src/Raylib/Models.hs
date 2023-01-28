{-# OPTIONS -Wall #-}

module Raylib.Models where

import Foreign
  ( Ptr,
    Storable (peek),
    fromBool,
    peekArray,
    toBool,
    with,
    withArray,
    withArrayLen,
  )
import Foreign.C (CFloat, withCString)
import GHC.IO (unsafePerformIO)
import Raylib.Native
  ( c'checkCollisionBoxSphere,
    c'checkCollisionBoxes,
    c'checkCollisionSpheres,
    c'drawBillboard,
    c'drawBillboardPro,
    c'drawBillboardRec,
    c'drawBoundingBox,
    c'drawCapsule,
    c'drawCapsuleWires,
    c'drawCircle3D,
    c'drawCube,
    c'drawCubeV,
    c'drawCubeWires,
    c'drawCubeWiresV,
    c'drawCylinder,
    c'drawCylinderEx,
    c'drawCylinderWires,
    c'drawCylinderWiresEx,
    c'drawGrid,
    c'drawLine3D,
    c'drawMesh,
    c'drawMeshInstanced,
    c'drawModel,
    c'drawModelEx,
    c'drawModelWires,
    c'drawModelWiresEx,
    c'drawPlane,
    c'drawPoint3D,
    c'drawRay,
    c'drawSphere,
    c'drawSphereEx,
    c'drawSphereWires,
    c'drawTriangle3D,
    c'drawTriangleStrip3D,
    c'exportMesh,
    c'genMeshCone,
    c'genMeshCube,
    c'genMeshCubicmap,
    c'genMeshCylinder,
    c'genMeshHeightmap,
    c'genMeshHemiSphere,
    c'genMeshKnot,
    c'genMeshPlane,
    c'genMeshPoly,
    c'genMeshSphere,
    c'genMeshTangents,
    c'genMeshTorus,
    c'getMeshBoundingBox,
    c'getModelBoundingBox,
    c'getRayCollisionBox,
    c'getRayCollisionMesh,
    c'getRayCollisionQuad,
    c'getRayCollisionSphere,
    c'getRayCollisionTriangle,
    c'isModelAnimationValid,
    c'loadMaterialDefault,
    c'loadMaterials,
    c'loadModel,
    c'loadModelAnimations,
    c'loadModelFromMesh,
    c'setMaterialTexture,
    c'setModelMeshMaterial,
    c'unloadMaterial,
    c'unloadMesh,
    c'unloadModel,
    c'unloadModelAnimation,
    c'unloadModelAnimations,
    c'unloadModelKeepMeshes,
    c'updateMeshBuffer,
    c'updateModelAnimation,
    c'uploadMesh,
  )
import Raylib.Types
  ( BoundingBox,
    Camera3D,
    Color,
    Image,
    Material,
    Matrix,
    Mesh,
    Model,
    ModelAnimation,
    Ray,
    RayCollision,
    Rectangle,
    Texture,
    Vector2,
    Vector3,
  )
import Raylib.Util (pop)
import Prelude hiding (length)

drawLine3D :: Raylib.Types.Vector3 -> Raylib.Types.Vector3 -> Raylib.Types.Color -> IO ()
drawLine3D start end color = with start (\s -> with end (with color . c'drawLine3D s))

drawPoint3D :: Raylib.Types.Vector3 -> Raylib.Types.Color -> IO ()
drawPoint3D point color = with point (with color . c'drawPoint3D)

drawCircle3D :: Raylib.Types.Vector3 -> Float -> Raylib.Types.Vector3 -> Float -> Raylib.Types.Color -> IO ()
drawCircle3D center radius rotationAxis rotationAngle color = with center (\c -> with rotationAxis (\r -> with color (c'drawCircle3D c (realToFrac radius) r (realToFrac rotationAngle))))

drawTriangle3D :: Raylib.Types.Vector3 -> Raylib.Types.Vector3 -> Raylib.Types.Vector3 -> Raylib.Types.Color -> IO ()
drawTriangle3D v1 v2 v3 color = with v1 (\p1 -> with v2 (\p2 -> with v3 (with color . c'drawTriangle3D p1 p2)))

drawTriangleStrip3D :: [Raylib.Types.Vector3] -> Int -> Raylib.Types.Color -> IO ()
drawTriangleStrip3D points pointCount color = withArray points (\p -> with color (c'drawTriangleStrip3D p (fromIntegral pointCount)))

drawCube :: Raylib.Types.Vector3 -> Float -> Float -> Float -> Raylib.Types.Color -> IO ()
drawCube position width height length color = with position (\p -> with color (c'drawCube p (realToFrac width) (realToFrac height) (realToFrac length)))

drawCubeV :: Raylib.Types.Vector3 -> Raylib.Types.Vector3 -> Raylib.Types.Color -> IO ()
drawCubeV position size color = with position (\p -> with size (with color . c'drawCubeV p))

drawCubeWires :: Raylib.Types.Vector3 -> Float -> Float -> Float -> Raylib.Types.Color -> IO ()
drawCubeWires position width height length color = with position (\p -> with color (c'drawCubeWires p (realToFrac width) (realToFrac height) (realToFrac length)))

drawCubeWiresV :: Raylib.Types.Vector3 -> Raylib.Types.Vector3 -> Raylib.Types.Color -> IO ()
drawCubeWiresV position size color = with position (\p -> with size (with color . c'drawCubeWiresV p))

drawSphere :: Raylib.Types.Vector3 -> Float -> Raylib.Types.Color -> IO ()
drawSphere position radius color = with position (\p -> with color (c'drawSphere p (realToFrac radius)))

drawSphereEx :: Raylib.Types.Vector3 -> Float -> Int -> Int -> Raylib.Types.Color -> IO ()
drawSphereEx position radius rings slices color = with position (\p -> with color (c'drawSphereEx p (realToFrac radius) (fromIntegral rings) (fromIntegral slices)))

drawSphereWires :: Raylib.Types.Vector3 -> Float -> Int -> Int -> Raylib.Types.Color -> IO ()
drawSphereWires position radius rings slices color = with position (\p -> with color (c'drawSphereWires p (realToFrac radius) (fromIntegral rings) (fromIntegral slices)))

drawCylinder :: Raylib.Types.Vector3 -> Float -> Float -> Float -> Int -> Raylib.Types.Color -> IO ()
drawCylinder position radiusTop radiusBottom height slices color = with position (\p -> with color (c'drawCylinder p (realToFrac radiusTop) (realToFrac radiusBottom) (realToFrac height) (fromIntegral slices)))

drawCylinderEx :: Raylib.Types.Vector3 -> Raylib.Types.Vector3 -> Float -> Float -> Int -> Raylib.Types.Color -> IO ()
drawCylinderEx start end startRadius endRadius sides color = with start (\s -> with end (\e -> with color (c'drawCylinderEx s e (realToFrac startRadius) (realToFrac endRadius) (fromIntegral sides))))

drawCylinderWires :: Raylib.Types.Vector3 -> Float -> Float -> Float -> Int -> Raylib.Types.Color -> IO ()
drawCylinderWires position radiusTop radiusBottom height slices color = with position (\p -> with color (c'drawCylinderWires p (realToFrac radiusTop) (realToFrac radiusBottom) (realToFrac height) (fromIntegral slices)))

drawCylinderWiresEx :: Raylib.Types.Vector3 -> Raylib.Types.Vector3 -> Float -> Float -> Int -> Raylib.Types.Color -> IO ()
drawCylinderWiresEx start end startRadius endRadius sides color = with start (\s -> with end (\e -> with color (c'drawCylinderWiresEx s e (realToFrac startRadius) (realToFrac endRadius) (fromIntegral sides))))

drawCapsule :: Vector3 -> Vector3 -> CFloat -> Int -> Int -> Color -> IO ()
drawCapsule start end radius slices rings color = with start (\s -> with end (\e -> with color (c'drawCapsule s e (realToFrac radius) (fromIntegral slices) (fromIntegral rings))))

drawCapsuleWires :: Vector3 -> Vector3 -> CFloat -> Int -> Int -> Color -> IO ()
drawCapsuleWires start end radius slices rings color = with start (\s -> with end (\e -> with color (c'drawCapsuleWires s e (realToFrac radius) (fromIntegral slices) (fromIntegral rings))))

drawPlane :: Raylib.Types.Vector3 -> Raylib.Types.Vector2 -> Raylib.Types.Color -> IO ()
drawPlane center size color = with center (\c -> with size (with color . c'drawPlane c))

drawRay :: Raylib.Types.Ray -> Raylib.Types.Color -> IO ()
drawRay ray color = with ray (with color . c'drawRay)

drawGrid :: Int -> Float -> IO ()
drawGrid slices spacing = c'drawGrid (fromIntegral slices) (realToFrac spacing)

loadModel :: String -> IO Raylib.Types.Model
loadModel fileName = withCString fileName c'loadModel >>= pop

loadModelFromMesh :: Raylib.Types.Mesh -> IO Raylib.Types.Model
loadModelFromMesh mesh = with mesh c'loadModelFromMesh >>= pop

unloadModel :: Raylib.Types.Model -> IO ()
unloadModel model = with model c'unloadModel

unloadModelKeepMeshes :: Raylib.Types.Model -> IO ()
unloadModelKeepMeshes model = with model c'unloadModelKeepMeshes

getModelBoundingBox :: Raylib.Types.Model -> IO Raylib.Types.BoundingBox
getModelBoundingBox model = with model c'getModelBoundingBox >>= pop

drawModel :: Raylib.Types.Model -> Raylib.Types.Vector3 -> Float -> Raylib.Types.Color -> IO ()
drawModel model position scale tint = with model (\m -> with position (\p -> with tint (c'drawModel m p (realToFrac scale))))

drawModelEx :: Raylib.Types.Model -> Raylib.Types.Vector3 -> Raylib.Types.Vector3 -> Float -> Raylib.Types.Vector3 -> Raylib.Types.Color -> IO ()
drawModelEx model position rotationAxis rotationAngle scale tint = with model (\m -> with position (\p -> with rotationAxis (\r -> with scale (with tint . c'drawModelEx m p r (realToFrac rotationAngle)))))

drawModelWires :: Raylib.Types.Model -> Raylib.Types.Vector3 -> Float -> Raylib.Types.Color -> IO ()
drawModelWires model position scale tint = with model (\m -> with position (\p -> with tint (c'drawModelWires m p (realToFrac scale))))

drawModelWiresEx :: Raylib.Types.Model -> Raylib.Types.Vector3 -> Raylib.Types.Vector3 -> Float -> Raylib.Types.Vector3 -> Raylib.Types.Color -> IO ()
drawModelWiresEx model position rotationAxis rotationAngle scale tint = with model (\m -> with position (\p -> with rotationAxis (\r -> with scale (with tint . c'drawModelWiresEx m p r (realToFrac rotationAngle)))))

drawBoundingBox :: Raylib.Types.BoundingBox -> Raylib.Types.Color -> IO ()
drawBoundingBox box color = with box (with color . c'drawBoundingBox)

drawBillboard :: Raylib.Types.Camera3D -> Raylib.Types.Texture -> Raylib.Types.Vector3 -> Float -> Raylib.Types.Color -> IO ()
drawBillboard camera texture position size tint = with camera (\c -> with texture (\t -> with position (\p -> with tint (c'drawBillboard c t p (realToFrac size)))))

drawBillboardRec :: Raylib.Types.Camera3D -> Raylib.Types.Texture -> Raylib.Types.Rectangle -> Raylib.Types.Vector3 -> Raylib.Types.Vector2 -> Raylib.Types.Color -> IO ()
drawBillboardRec camera texture source position size tint = with camera (\c -> with texture (\t -> with source (\s -> with position (\p -> with size (with tint . c'drawBillboardRec c t s p)))))

drawBillboardPro :: Raylib.Types.Camera3D -> Raylib.Types.Texture -> Raylib.Types.Rectangle -> Raylib.Types.Vector3 -> Raylib.Types.Vector3 -> Raylib.Types.Vector2 -> Raylib.Types.Vector2 -> Float -> Raylib.Types.Color -> IO ()
drawBillboardPro camera texture source position up size origin rotation tint = with camera (\c -> with texture (\t -> with source (\s -> with position (\p -> with up (\u -> with size (\sz -> with origin (\o -> with tint (c'drawBillboardPro c t s p u sz o (realToFrac rotation)))))))))

uploadMesh :: Raylib.Types.Mesh -> Bool -> IO Raylib.Types.Mesh
uploadMesh mesh dynamic = with mesh (\m -> c'uploadMesh m (fromBool dynamic) >> peek m)

updateMeshBuffer :: Raylib.Types.Mesh -> Int -> Ptr () -> Int -> Int -> IO ()
updateMeshBuffer mesh index dataValue dataSize offset = with mesh (\m -> c'updateMeshBuffer m (fromIntegral index) dataValue (fromIntegral dataSize) (fromIntegral offset))

unloadMesh :: Raylib.Types.Mesh -> IO ()
unloadMesh mesh = with mesh c'unloadMesh

drawMesh :: Raylib.Types.Mesh -> Raylib.Types.Material -> Raylib.Types.Matrix -> IO ()
drawMesh mesh material transform = with mesh (\m -> with material (with transform . c'drawMesh m))

drawMeshInstanced :: Raylib.Types.Mesh -> Raylib.Types.Material -> [Raylib.Types.Matrix] -> IO ()
drawMeshInstanced mesh material transforms = with mesh (\m -> with material (\mat -> withArrayLen transforms (\size t -> c'drawMeshInstanced m mat t (fromIntegral size))))

exportMesh :: Raylib.Types.Mesh -> String -> IO Bool
exportMesh mesh fileName = toBool <$> with mesh (withCString fileName . c'exportMesh)

getMeshBoundingBox :: Raylib.Types.Mesh -> IO Raylib.Types.BoundingBox
getMeshBoundingBox mesh = with mesh c'getMeshBoundingBox >>= pop

genMeshTangents :: Raylib.Types.Mesh -> IO Raylib.Types.Mesh
genMeshTangents mesh = with mesh (\m -> c'genMeshTangents m >> peek m)

genMeshPoly :: Int -> Float -> IO Raylib.Types.Mesh
genMeshPoly sides radius = c'genMeshPoly (fromIntegral sides) (realToFrac radius) >>= pop

genMeshPlane :: Float -> Float -> Int -> Int -> IO Raylib.Types.Mesh
genMeshPlane width length resX resZ = c'genMeshPlane (realToFrac width) (realToFrac length) (fromIntegral resX) (fromIntegral resZ) >>= pop

genMeshCube :: Float -> Float -> Float -> IO Raylib.Types.Mesh
genMeshCube width height length = c'genMeshCube (realToFrac width) (realToFrac height) (realToFrac length) >>= pop

genMeshSphere :: Float -> Int -> Int -> IO Raylib.Types.Mesh
genMeshSphere radius rings slices = c'genMeshSphere (realToFrac radius) (fromIntegral rings) (fromIntegral slices) >>= pop

genMeshHemiSphere :: Float -> Int -> Int -> IO Raylib.Types.Mesh
genMeshHemiSphere radius rings slices = c'genMeshHemiSphere (realToFrac radius) (fromIntegral rings) (fromIntegral slices) >>= pop

genMeshCylinder :: Float -> Float -> Int -> IO Raylib.Types.Mesh
genMeshCylinder radius height slices = c'genMeshCylinder (realToFrac radius) (realToFrac height) (fromIntegral slices) >>= pop

genMeshCone :: Float -> Float -> Int -> IO Raylib.Types.Mesh
genMeshCone radius height slices = c'genMeshCone (realToFrac radius) (realToFrac height) (fromIntegral slices) >>= pop

genMeshTorus :: Float -> Float -> Int -> Int -> IO Raylib.Types.Mesh
genMeshTorus radius size radSeg sides = c'genMeshTorus (realToFrac radius) (realToFrac size) (fromIntegral radSeg) (fromIntegral sides) >>= pop

genMeshKnot :: Float -> Float -> Int -> Int -> IO Raylib.Types.Mesh
genMeshKnot radius size radSeg sides = c'genMeshKnot (realToFrac radius) (realToFrac size) (fromIntegral radSeg) (fromIntegral sides) >>= pop

genMeshHeightmap :: Raylib.Types.Image -> Raylib.Types.Vector3 -> IO Raylib.Types.Mesh
genMeshHeightmap heightmap size = with heightmap (with size . c'genMeshHeightmap) >>= pop

genMeshCubicmap :: Raylib.Types.Image -> Raylib.Types.Vector3 -> IO Raylib.Types.Mesh
genMeshCubicmap cubicmap cubeSize = with cubicmap (with cubeSize . c'genMeshCubicmap) >>= pop

loadMaterials :: String -> IO [Raylib.Types.Material]
loadMaterials fileName =
  withCString
    fileName
    ( \f ->
        with
          0
          ( \n -> do
              ptr <- c'loadMaterials f n
              num <- peek n
              peekArray (fromIntegral num) ptr
          )
    )

loadMaterialDefault :: IO Raylib.Types.Material
loadMaterialDefault = c'loadMaterialDefault >>= pop

unloadMaterial :: Raylib.Types.Material -> IO ()
unloadMaterial material = with material c'unloadMaterial

setMaterialTexture :: Raylib.Types.Material -> Int -> Raylib.Types.Texture -> IO Raylib.Types.Material
setMaterialTexture material mapType texture = with material (\m -> with texture (c'setMaterialTexture m (fromIntegral mapType)) >> peek m)

setModelMeshMaterial :: Raylib.Types.Model -> Int -> Int -> IO Raylib.Types.Model
setModelMeshMaterial model meshId materialId = with model (\m -> c'setModelMeshMaterial m (fromIntegral meshId) (fromIntegral materialId) >> peek m)

loadModelAnimations :: String -> IO [Raylib.Types.ModelAnimation]
loadModelAnimations fileName =
  withCString
    fileName
    ( \f ->
        with
          0
          ( \n -> do
              ptr <- c'loadModelAnimations f n
              num <- peek n
              peekArray (fromIntegral num) ptr
          )
    )

updateModelAnimation :: Raylib.Types.Model -> Raylib.Types.ModelAnimation -> Int -> IO ()
updateModelAnimation model animation frame = with model (\m -> with animation (\a -> c'updateModelAnimation m a (fromIntegral frame)))

unloadModelAnimation :: ModelAnimation -> IO ()
unloadModelAnimation animation = with animation c'unloadModelAnimation

unloadModelAnimations :: [ModelAnimation] -> IO ()
unloadModelAnimations animations = withArrayLen animations (\num a -> c'unloadModelAnimations a (fromIntegral num))

isModelAnimationValid :: Model -> ModelAnimation -> IO Bool
isModelAnimationValid model animation = toBool <$> with model (with animation . c'isModelAnimationValid)

checkCollisionSpheres :: Vector3 -> Float -> Vector3 -> Float -> Bool
checkCollisionSpheres center1 radius1 center2 radius2 = toBool $ unsafePerformIO (with center1 (\c1 -> with center2 (\c2 -> c'checkCollisionSpheres c1 (realToFrac radius1) c2 (realToFrac radius2))))

checkCollisionBoxes :: BoundingBox -> BoundingBox -> Bool
checkCollisionBoxes box1 box2 = toBool $ unsafePerformIO (with box1 (with box2 . c'checkCollisionBoxes))

checkCollisionBoxSphere :: BoundingBox -> Vector3 -> Float -> Bool
checkCollisionBoxSphere box center radius = toBool $ unsafePerformIO (with box (\b -> with center (\c -> c'checkCollisionBoxSphere b c (realToFrac radius))))

getRayCollisionSphere :: Ray -> Vector3 -> Float -> RayCollision
getRayCollisionSphere ray center radius = unsafePerformIO $ with ray (\r -> with center (\c -> c'getRayCollisionSphere r c (realToFrac radius))) >>= pop

getRayCollisionBox :: Ray -> BoundingBox -> RayCollision
getRayCollisionBox ray box = unsafePerformIO $ with ray (with box . c'getRayCollisionBox) >>= pop

getRayCollisionMesh :: Ray -> Mesh -> Matrix -> RayCollision
getRayCollisionMesh ray mesh transform = unsafePerformIO $ with ray (\r -> with mesh (with transform . c'getRayCollisionMesh r)) >>= pop

getRayCollisionTriangle :: Ray -> Vector3 -> Vector3 -> Vector3 -> RayCollision
getRayCollisionTriangle ray v1 v2 v3 = unsafePerformIO $ with ray (\r -> with v1 (\p1 -> with v2 (with v3 . c'getRayCollisionTriangle r p1))) >>= pop

getRayCollisionQuad :: Ray -> Vector3 -> Vector3 -> Vector3 -> Vector3 -> RayCollision
getRayCollisionQuad ray v1 v2 v3 v4 = unsafePerformIO $ with ray (\r -> with v1 (\p1 -> with v2 (\p2 -> with v3 (with v4 . c'getRayCollisionQuad r p1 p2)))) >>= pop