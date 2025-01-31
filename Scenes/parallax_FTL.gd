extends ParallaxBackground

const SCROLL_SPEED : float = 2500.0

func _process(delta: float) -> void:
	self.scroll_offset.x -= delta * SCROLL_SPEED
