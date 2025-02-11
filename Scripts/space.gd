extends Control

@onready var parallax_space: ParallaxBackground = %ParallaxSpace
@onready var parallax_ftl: ParallaxBackground = %ParallaxFTL
@onready var ftl_timer: Timer = %FTLTimer
@onready var nebulae_sprite: Sprite2D = %NebulaeSprite
@onready var far_star_sprite: Sprite2D = %FarStarSprite
@onready var near_star_sprite: Sprite2D = %NearStarSprite

var rng = RandomNumberGenerator.new()

signal ftl_finished()

func _ready() -> void:
	parallax_space.visibility_changed.connect(_randomize_position)

# show ftl for given seconds, hide space
func show_ftl():
	ftl_timer.start()
	parallax_space.visible = false
	parallax_ftl.visible = true

# show space, hide ftl
func _show_space():
	parallax_space.visible = true
	parallax_ftl.visible = false
	ftl_finished.emit()

func _randomize_position():
	var rand = (rng.randf_range(0,1200))
	nebulae_sprite.offset = Vector2(-1 * rand, 0)
	far_star_sprite.offset = Vector2(-1 * rand, 0)
	near_star_sprite.offset = Vector2(-1 * rand, 0)
