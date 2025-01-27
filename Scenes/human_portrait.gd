extends TextureRect

var portrait_index: int

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	print(self.texture)
	var atlas: AtlasTexture = self.texture
	atlas.region = Rect2(Vector2(64, 0), Vector2(64,64))
