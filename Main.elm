module Main exposing (..)

import Math.Vector2 exposing (..)
import Math.Matrix4 exposing (..)
import WebGL exposing (..)
import Html exposing (Html)
import Html.Attributes exposing (width, height)


type alias Vertex =
    { position : Vec2, circlePos : Vec2 }


-- Create a mesh with two triangles
mesh : Drawable Vertex
mesh =
    Triangle
        [ ( Vertex (vec2 -1 -1) (vec2 -0.5 -0.5)
          , Vertex (vec2  1  1) (vec2  0.5  0.5)
          , Vertex (vec2  1 -1) (vec2  0.5 -0.5)
          )
        , ( Vertex (vec2  -1 -1) (vec2 -0.5 -0.5)
          , Vertex (vec2  -1  1) (vec2 -0.5  0.5)
          , Vertex (vec2   1  1) (vec2  0.5  0.5)
          )
        ]

main : Html msg
main = view

view : Html msg
view =
    WebGL.toHtml
        [ width 400, height 400 ]
        [ render vertexShader fragmentShader mesh { perspective = perspective } ]


perspective : Mat4
perspective =
    makeOrtho2D -1.0 1.0 -1.0 1.0


-- Shaders
vertexShader : Shader { attr | position : Vec2, circlePos : Vec2 } { unif | perspective : Mat4 } { circleOut : Vec2 }
vertexShader =
    [glsl|

attribute vec2 position;
attribute vec2 circlePos;
uniform mat4 perspective;
varying vec2 circleOut;

void main () {
    gl_Position = perspective * vec4(position, 0.0, 1.0);
    circleOut = circlePos;
}

|]


fragmentShader : Shader {} u { circleOut : Vec2 }
fragmentShader =
    [glsl|

precision mediump float;
varying vec2 circleOut;

void main () {
    vec4 col = vec4(1.0, 0.0, 0.0, 1.0);

    if (sqrt((circleOut.x * circleOut.x) + (circleOut.y * circleOut.y)) > 0.5) {
        discard;
    }
    gl_FragColor = col;
}

|]