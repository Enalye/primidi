module primidi.core.tween;

import std.math;

import primidi.common.all;
import primidi.core.util;

enum TimeMode {
	Stopped,
	Once,
	Loop,
	Bounce
}

struct Timer {
	private {
		float _time = 0f, _speed = 1f / nominalFps;
		bool _isReversed = false;
	}

	TimeMode mode = TimeMode.Stopped;

	@property {
		float time() const { return _time; }

		float duration() const { return _speed * nominalFps; }
		float duration(float newDuration) {
			if(newDuration <= 0f) {
				_speed = 0f;
				_time = 1f;
			}
			else
				_speed = 1f / (nominalFps * newDuration);
			return newDuration;
		}

		bool isRunning() const { return (mode != TimeMode.Stopped); }
	}

	void start(float newDuration, TimeMode newTimeMode = TimeMode.Once) {
		_time = 0f;
		duration(newDuration);
		mode = newTimeMode;
	}

	void update(float deltaTime) {
		switch(mode) with(TimeMode) {
		case Stopped:
			break;
		case Once:
			if(_time < 1f)
				_time += _speed * deltaTime;
			if(_time > 1f) {
				_time = 1f;
				mode = TimeMode.Stopped;
			}
			break;
		case Loop:
			if(_time < 1f)
				_time += _speed * deltaTime;
			if(_time > 1f)
				_time = (_time - 1f) + (_speed * deltaTime);
			break;
		case Bounce:
			if(_isReversed) {
				if(_time > 0f)
					_time -= _speed * deltaTime;
				if(_time < 0f) {
					_time = -(_time - (_speed * deltaTime));
					_isReversed = false;
				}
			}
			else {
				if(_time < 1f)
					_time += _speed * deltaTime;
				if(_time > 1f) {
					_time = 1f - ((_time - 1f) + (_speed * deltaTime));
					_isReversed = true;
				}
			}
			break;
		default:
			throw new Exception("Invalid time mode");
		}
	}
}

//Sine
float easeInSine(float t) {
	return sin((t - 1f) * PI_2) + 1f;
}

float easeOutSine(float t) {
	return sin(t * PI_2);
}

float easeInOutSine(float t) {
	return (1f - cos(t * PI)) / 2f;
}

//Quad
float easeInQuad(float t) {
	return t * t;
}

float easeOutQuad(float t) {
	return -(t * (t - 2));
}

float easeInOutQuad(float t) {
	if(t < .5f)
		return 2f * t * t;
	else
		return (-2f * t * t) + (4f * t) - 1f;
}

//Cubic
float easeInCubic(float t) {
	return t * t * t;
}

float easeOutCubic(float t) {
	t = (t - 1f);
	t = (t * t * t + 1f);
	return t;
}

float easeInOutCubic(float t) {
	if(t < .5f)
		return 4f * t * t * t;
	else {
		float f = ((2f * t) - 2f);
		return .5f * f * f * f + 1f;
	}
}

//Quart
float easeInQuart(float t) {
	return t * t * t * t;
}

float easeOutQuart(float t) {
	float f = (t - 1f);
	return f * f * f * (1f - t) + 1f;
}

float easeInOutQuart(float t) {
	if(t < .5f)
		return 8f * t * t * t * t;
	else {
		float f = (t - 1f);
		return -8f * f * f * f * f + 1f;
	}
}

//Quint
float easeInQuint(float t) {
	return t * t * t * t * t;
}

float easeOutQuint(float t) {
	float f = (t - 1f);
	return f * f * f * f * f + 1f;
}

float easeInOutQuint(float t) {
	if(t < .5f)
		return 16f * t * t * t * t * t;
	else {
		float f = ((2f * t) - 2f);
		return  .5f * f * f * f * f * f + 1f;
	}
}

//Exp
float easeInExp(float t) {
	return (t == 0f) ? t : pow(2f, 10f * (t - 1f));
}

float easeOutExp(float t) {
	return (t == 1f) ? t : 1f - pow(2f, -10f * t);
}

float easeInOutExp(float t) {
	if(t == 0f || t == 1f)
		return t;
	if(t < .5f)
		return .5f * pow(2f, (20f * t) - 10f);
	else
		return -.5f * pow(2f, (-20f * t) + 10f) + 1f;
}

//Circ
float easeInCirc(float t) {
	return 1f - sqrt(1f - (t * t));
}

float easeOutCirc(float t) {
	return sqrt((2f - t) * t);
}

float easeInOutCirc(float t) {
	if(t < .5f)
		return .5f * (1f - sqrt(1f - 4f * (t * t)));
	else
		return .5f * (sqrt(-((2f * t) - 3f) * ((2f * t) - 1f)) + 1f);
}

//Back
float easeInBack(float t) {
	return t * t * t - t * sin(t * PI);
}

float easeOutBack(float t) {
	float f = (1f - t);
	return 1f - (f * f * f - f * sin(f * PI));
}

float easeInOutBack(float t) {
	if(t < .5f) {
		t *= 2f;
		return (t * t * t - t * sin(t * PI)) / 2f;
	}
	t = (1f - (2f*t - 1f));
	return (1f - (t * t * t - t * sin(t * PI))) / 2f + .5f;
}

//Elastic
float easeInElastic(float t) {
	return sin(13f * PI_2 * t) * pow(2f, 10f * (t - 1f));
}

float easeOutElastic(float t) {
	return sin(-13f * PI_2 * (t + 1)) * pow(2f, -10f * t) + 1f;
}

float easeInOutElastic(float t) {
	if(t < .5f)
		return .5f * sin(13f * PI_2 * (2f * t)) * pow(2f, 10f * ((2f * t) - 1f));
	else
		return .5f * (sin(-13f * PI_2 * ((2f * t - 1f) + 1f)) * pow(2f, -10f * (2f * t - 1f)) + 2f);
}

//Bounce
float easeInBounce(float t) {
	return 1f - easeOutBounce(1f - t);
}

float easeOutBounce(float t) {
	if(t < 4f/11f)
		return (121f * t * t)/16f;
	else if(t < 8f/11f)
		return (363f/40f * t * t) - (99f/10f * t) + 17f/5f;
	else if(t < 9f/10f)
		return (4356f/361f * t * t) - (35442f/1805f * t) + 16061f/1805f;
	return (54f/5f * t * t) - (513f/25f * t) + 268f/25f;
}

float easeInOutBounce(float t) {
	if(t < .5f)
		return easeInBounce(t * 2f) / 2f;
	else
		return easeOutBounce(t * 2f - 1f) / 2f + .5f;
}