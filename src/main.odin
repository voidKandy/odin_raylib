package game

import "core:fmt"
import rl "vendor:raylib"

Key :: rl.KeyboardKey
MAX_COLUMNS :: 20
MOVE_SPEED :: 0.1

main :: proc() {
	rl.InitWindow(1280, 720, "My First Game")
	camera: rl.Camera3D
	camera.position = {0.0, 2.0, 4.0} // Camera position
	camera.target = {0.0, 1.0, 0.0} // Camera looking at point
	camera.up = {0.0, 1.0, 0.0} // Camera up vector (rotation towards target)
	camera.fovy = 90.0 // Camera field-of-view Y
	camera.projection = rl.CameraProjection.PERSPECTIVE // Camera projection type


	// Generates some random columns
	heights: [MAX_COLUMNS]f32 = {}
	positions: [MAX_COLUMNS][3]f32 = {}
	colors: [MAX_COLUMNS]rl.Color = {}

	for i in 0 ..< MAX_COLUMNS {
		heights[i] = auto_cast rl.GetRandomValue(1, 12)
		positions[i] = {
			auto_cast rl.GetRandomValue(-15, 15),
			heights[i] / 2.0,
			auto_cast rl.GetRandomValue(-15, 15),
		}
		colors[i] = rl.Color {
			auto_cast rl.GetRandomValue(20, 255),
			auto_cast rl.GetRandomValue(10, 55),
			30,
			255,
		}
	}


	for !rl.WindowShouldClose() {

		move_forward: f32 = 1.0 if (rl.IsKeyDown(Key.W) || rl.IsKeyDown(Key.UP)) else 0.0
		move_down: f32 = 1.0 if (rl.IsKeyDown(Key.S) || rl.IsKeyDown(Key.DOWN)) else 0.0
		move_right: f32 = 1.0 if (rl.IsKeyDown(Key.D) || rl.IsKeyDown(Key.RIGHT)) else 0.0
		move_left: f32 = 1.0 if (rl.IsKeyDown(Key.A) || rl.IsKeyDown(Key.LEFT)) else 0.0

		mouse_delta := rl.GetMouseDelta()

		camera_translation: [3]f32 = {
			move_forward * MOVE_SPEED - move_down * MOVE_SPEED,
			move_right * MOVE_SPEED - move_left * MOVE_SPEED,
			0.0, // Move up-down
		}

		camera_rotation: [3]f32 = {
			mouse_delta.x * 0.05, // Rotation: yaw
			mouse_delta.y * 0.05, // Rotation: pitch
			0.0, // Rotation: roll
		}

		fmt.printfln("POSITION: %v\n", camera.position)
		rl.DisableCursor()
		rl.SetTargetFPS(60)
		rl.UpdateCamera(&camera, rl.CameraMode.FIRST_PERSON)
		rl.UpdateCameraPro(
			&camera,
			camera_translation,
			camera_rotation,
			rl.GetMouseWheelMove() * 2.0,
		)

		rl.BeginDrawing()
		rl.ClearBackground(rl.Color{0, 0, 255, 0})

		rl.BeginMode3D(camera)

		rl.DrawPlane({0, -1, 0}, {100, 100}, rl.Color{255, 255, 255, 1})
		// rl.DrawCube({-6, 2.5, 0}, 1, 5, 32, rl.Color{0, 0, 255, 1})
		// rl.DrawCube({6, 2.5, 0}, 1, 5, 32, rl.Color{0, 255, 0, 1})
		// rl.DrawCube({0, 2.5, 10}, 32, 5, 1, rl.Color{255, 0, 0, 1})
		for i in 0 ..< MAX_COLUMNS {
			rl.DrawCube(positions[i], 2.0, heights[i], 2.0, colors[i])
			rl.DrawCubeWires(positions[i], 2.0, heights[i], 2.0, rl.Color{255, 255, 255, 1})
		}


		rl.EndMode3D()

		rl.EndDrawing()
	}

	rl.CloseWindow()
}

