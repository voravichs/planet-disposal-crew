extends Control

@onready var classification: RichTextLabel = %Classification
@onready var population: RichTextLabel = %Population
@onready var dom_species: RichTextLabel = %DomSpecies
@onready var tech_level: RichTextLabel = %TechLevel
@onready var resources: RichTextLabel = %Resources
@onready var extra: RichTextLabel = %Extra
@onready var planet_name: RichTextLabel = %PlanetName

func set_console_info(current_planet: Dictionary):
	planet_name.text = format_center(current_planet.name)
	classification.text = "[color=dodger_blue]Planet Class: [/color]" + current_planet.classification
	population.text = "[color=dodger_blue]Population: [/color]" + current_planet.population
	dom_species.text = "[color=dodger_blue]Species: [/color]" + current_planet.dom_species
	tech_level.text = "[color=dodger_blue]Tech Level: [/color]" + current_planet.tech_level
	resources.text = "[color=dodger_blue]Resources: [/color]" + current_planet.resources
	extra.text = "[wave]POGCHAMP[/wave]"

func hide_console_info():
	planet_name.text = format_center("?????")
	classification.text = ""
	population.text = ""
	dom_species.text = ""
	tech_level.text = ""
	resources.text = ""
	extra.text = "[wave]POGCHAMP[/wave]"

func format_center(text: String):
	return "[center]" + text + "[/center]"
