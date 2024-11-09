extends MeshInstance3D

#our mask images and dirt mask images
var mask_image: Image
var dirt_mask: ImageTexture

#texture rect so we can see the mask update
@onready var dirt_mask_texture: TextureRect = $"../../Extras/CanvasLayer/dirt_mask_texture"

#camera so we can see
@onready var camera_3d: Camera3D = $"../Camera3D"

#brush radius
var brush_radius = Vector2(20, 20)

#size of the dirt mask, can make larger for better resolution
@export var size_of_dirt_mask : int = 1024

#mesh details so we can apply math
var mesh_position
var mesh_end
var mesh_height
var mesh_width

#handle mouse input and draw while dragging
var dragging: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#gets the size of the mesh so we can calculate height and width of our brush
	mesh_position = self.mesh.get_aabb().position
	mesh_end = self.mesh.get_aabb().end
	mesh_height = abs(mesh_position.x) + abs(mesh_end.x)
	mesh_width = abs(mesh_position.z) + abs(mesh_end.z)
	
	#fancy math so if the x or z is scaled the brush is still square. 
	#without this, it would look like a caligraphy brush if a transform is scaled
	brush_radius.x = (size_of_dirt_mask / 1000) * mesh_width
	brush_radius.y = (size_of_dirt_mask / 1000) * mesh_height
	
	mask_image = Image.new()  # This should be created with the size of your dirt mask texture
	mask_image = Image.create(size_of_dirt_mask, size_of_dirt_mask, false, Image.FORMAT_L8)  # Create image with dirt mask texture size
	mask_image.fill(Color(1, 1, 1))  # Start fully dirty (white)
	
	#creates image from the mask_image
	dirt_mask = ImageTexture.new()
	dirt_mask = ImageTexture.create_from_image(mask_image)
	
	
	#sets our dirt_mask from our shader to the dirt_mask we just made
	var override_material: ShaderMaterial = get_surface_override_material(0)
	override_material.set_shader_parameter('dirt_mask', dirt_mask)
	
	#updates texture rect so we can visualize our mask
	dirt_mask_texture.texture = override_material.get_shader_parameter('dirt_mask')


func _process(delta: float) -> void:
	if dragging:
		#gets raycast of mouse position to draw accordingly
		var raycast_hit = raycast_from_mouse(get_viewport().get_mouse_position(), 1)

		if raycast_hit != {} and raycast_hit.collider is StaticBody3D:
			clean_surface(raycast_hit.position)


func clean_surface(brush_position):
	# Convert the world position to local image coordinates
	var local_position: Vector3 = to_local(brush_position)
	
	#sets coordinates of brush position to the ratio of the mesh itself
	local_position.x = size_of_dirt_mask * (((local_position.x + mesh_height / 2 )/ mesh_height))
	local_position.z = size_of_dirt_mask * (((local_position.z + mesh_width / 2 )/ mesh_width))
	
	#loops through brush radius, if values are within the images shape, it sets the pixel to black 
	for x in range(-brush_radius.x, brush_radius.x):
		for y in range(-brush_radius.y, brush_radius.y):
			
			var dx = x + local_position.x
			var dy = y + local_position.z

			if dx >= 0 and dx < mask_image.get_width() and dy >= 0 and dy < mask_image.get_height():
				mask_image.set_pixel(dx, dy, Color(0, 0, 0))  # Black for cleaned areas
	
	# Update the dirt mask texture
	dirt_mask = ImageTexture.create_from_image(mask_image)
	
	#update the shader to use the updated mask texture
	var override_material: ShaderMaterial = get_surface_override_material(0)
	override_material.set_shader_parameter('dirt_mask', dirt_mask)
	
	#extra call to update our texture rect so you can see the texture updating
	dirt_mask_texture.texture = dirt_mask
	


func _unhandled_input(event: InputEvent) -> void:
	
	#handles input so we can brush
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.is_pressed():
				dragging = true
				get_viewport().set_input_as_handled()
			elif event.is_released():
				dragging = false
				get_viewport().set_input_as_handled()
		
	#pressing space to calculate how much is filled in
	if event.is_pressed() and event.is_action("count_colored_pixels"):
		
		#value to count the black pixels
		var total_count: int
		
		#gets the size of the image in pixels
		var max_filled: int = size_of_dirt_mask * size_of_dirt_mask 
	
		#loops through the image to count the black pixels
		for i in mask_image.get_width():
			for j in mask_image.get_height():
				if mask_image.get_pixel(i, j) == Color(0, 0, 0):
					total_count += 1
		
		#calculates percentage of filled pixels
		var percentage: String = "%.2f" % ((1.0 * total_count) / (1.0 * max_filled) * 100)
		print("total size of our mask: ", max_filled, "\ntotal pixels in mask cleaned: ", total_count, "\npercentage: ", percentage, "%")


# just to get this working, I borrowed this function from 
# https://godotforums.org/d/33479-godot-4-raycasting-to-get-mouse-position-in-3d/3
func raycast_from_mouse(m_pos, collision_mask):
	var ray_length = 1000
	var ray_start = camera_3d.project_ray_origin(m_pos)
	var ray_end = ray_start + camera_3d.project_ray_normal(m_pos) * ray_length
	var world3d : World3D = get_world_3d()
	var space_state = world3d.direct_space_state
	
	if space_state == null:
		return
	
	var query = PhysicsRayQueryParameters3D.create(ray_start, ray_end, collision_mask)
	query.collide_with_areas = true
	
	return space_state.intersect_ray(query)
