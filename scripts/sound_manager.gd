extends Node
class_name SoundManager

static var sfx_frost: AudioStreamWAV
static var sfx_storm: AudioStreamWAV
static var sfx_cinder: AudioStreamWAV
static var sfx_beam: AudioStreamWAV
static var sfx_snare: AudioStreamWAV
static var sfx_dash: AudioStreamWAV
static var sfx_hit: AudioStreamWAV

static func init_audio() -> void:
	if sfx_frost != null:
		return
	sfx_frost = _generate_tone(880.0, 0.45, "bell")
	sfx_storm = _generate_noise_burst(0.35, 1200.0)
	sfx_cinder = _generate_tone(90.0, 0.6, "boom")
	sfx_beam = _generate_tone(440.0, 0.5, "laser")
	sfx_snare = _generate_tone(320.0, 0.4, "snap")
	sfx_dash = _generate_noise_burst(0.2, 500.0)
	sfx_hit = _generate_tone(1200.0, 0.1, "bell")

static func play_sound(node: Node, stream: AudioStreamWAV, volume_db: float = 0.0) -> void:
	if not stream:
		init_audio()
	var player := AudioStreamPlayer.new()
	player.stream = stream
	player.volume_db = volume_db
	node.add_child(player)
	player.play()
	player.finished.connect(player.queue_free)

static func _generate_tone(freq: float, duration: float, envelope_type: String) -> AudioStreamWAV:
	var stream := AudioStreamWAV.new()
	stream.format = AudioStreamWAV.FORMAT_16_BITS
	stream.mix_rate = 22050
	var sample_count: int = int(duration * 22050.0)
	var data := PackedByteArray()
	data.resize(sample_count * 2)

	for i in range(sample_count):
		var t: float = float(i) / 22050.0
		var env: float = 1.0 - (float(i) / float(sample_count))

		if envelope_type == "bell":
			env = exp(-t * 9.0)
		elif envelope_type == "boom":
			env = exp(-t * 6.0)
		elif envelope_type == "laser":
			freq = freq * (1.0 + (1.0 - t / duration) * 2.0)
			env = exp(-t * 4.0)
		elif envelope_type == "snap":
			env = exp(-t * 12.0)

		var wave: float = sin(t * freq * TAU)
		if envelope_type == "boom":
			wave += sin(t * (freq * 0.5) * TAU) * 0.5

		var sample_val: int = int(clampf(wave * env, -1.0, 1.0) * 32000.0)
		var byte_idx: int = i * 2
		data[byte_idx] = sample_val & 0xFF
		data[byte_idx + 1] = (sample_val >> 8) & 0xFF

	stream.data = data
	return stream

static func _generate_noise_burst(duration: float, _filter_freq: float) -> AudioStreamWAV:
	var stream := AudioStreamWAV.new()
	stream.format = AudioStreamWAV.FORMAT_16_BITS
	stream.mix_rate = 22050
	var sample_count: int = int(duration * 22050.0)
	var data := PackedByteArray()
	data.resize(sample_count * 2)

	for i in range(sample_count):
		var t: float = float(i) / 22050.0
		var env: float = exp(-t * 8.0)
		var noise: float = randf_range(-1.0, 1.0)
		var sample_val: int = int(clampf(noise * env, -1.0, 1.0) * 28000.0)
		var byte_idx: int = i * 2
		data[byte_idx] = sample_val & 0xFF
		data[byte_idx + 1] = (sample_val >> 8) & 0xFF

	stream.data = data
	return stream
