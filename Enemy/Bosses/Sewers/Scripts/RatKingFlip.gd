extends Sprite

func flip(value : bool):
	flip_h = value
	if value == false:
		$LeftRedLight.position.x = -8.5
		$BlueLight.position.x = -6.5
		$RightRedLight.position.x = -4.5
	if value == true:
		$LeftRedLight.position.x = 4.5
		$BlueLight.position.x = 6.5
		$RightRedLight.position.x = 8.5
