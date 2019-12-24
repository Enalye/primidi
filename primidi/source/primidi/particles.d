/** 
 * Copyright: Enalye
 * License: Zlib
 * Authors: Enalye
 */
module primidi.particles;

import atelier;

private final class Particle  {
	Color startColor = Color.white;
	Color endColor = Color.white;
	Vec2f position = Vec2f.zero;
    float time = 0f;
	float timeToLive = 60f;
	float angle = 0f;
	float speed = 0f;
	float angleSpeed = 0f;

	bool update(float deltaTime) {
		time += deltaTime;
		if(time > timeToLive)
			return true;

		const Vec2f direction = Vec2f(1f, 0f).rotated(angle) * speed;
		position += direction * deltaTime;
		angle += angleSpeed * deltaTime;
		
		return false;
	}

	void draw() const {
		drawFilledRect(position, Vec2f.one, lerp(startColor, endColor, time / timeToLive));
	}
}

private {
    alias ParticleArray = IndexedArray!(Particle, 5000u);
    ParticleArray _particles;
}

void initializeParticles() {
    _particles = new ParticleArray;
}

void updateParticles(float deltaTime) {
    foreach(Particle particle, uint index; _particles) {
        if(particle.update(deltaTime))
            _particles.markInternalForRemoval(index);
    }
    _particles.sweepMarkedData();
}

void drawParticles() {
    foreach(const Particle particle; _particles)
        particle.draw();
}

void createParticle(Vec2f position, float angle, float speed, float angleSpeed, int timeToLive, Color startColor, Color endColor) {
    if((_particles.length + 1u) == _particles.capacity)
        return;

    Particle particle = new Particle;
    particle.position = position;
    particle.angle = angle;
    particle.speed = speed;
    particle.angleSpeed = angleSpeed;
    particle.timeToLive = timeToLive;
    particle.startColor = startColor;
    particle.endColor = endColor;
    _particles.push(particle);
}

